//
//  ChartView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-16.
//

import Foundation
import SwiftUI
import Charts

 
struct ChartView: View {
    @Binding var selectedChartStatistic: [Statistic]
    @Binding var statisticData: [StatisticDataObject]
    @Binding var isEditingTodayStatistic: Bool
    @State var isDataNormalized: Bool = false
    
    func yValuesRange(isDataNormalized: Bool) -> (min: Double, max: Double) {
        if isDataNormalized {
            return (min: 0, max: 100) // Normalized range
        } else if selectedChartStatistic.count == 1 , let firstStatistic = selectedChartStatistic.first {
            return rangeFor(statistic: firstStatistic)
        } else {
            return (min: 0, max: 100) // Default range
        }
    }
    
    func rangeFor(statistic: Statistic) -> (min: Double, max: Double) {
        var values: [Double] = []
        var leverage: Double = 0
        switch statistic {
        case .weight:
            values = statisticData.map { $0.weight }.filter { $0 != 0 }
            leverage = 1
        case .steps:
            values = statisticData.map { Double($0.steps) }.filter { $0 != 0 }
            leverage = 500
        case .calories:
            values = statisticData.map { Double($0.calories) }.filter { $0 != 0 }
            leverage = 200
        }

        let minValue = (values.min() ?? 0) - leverage
        let maxValue = (values.max() ?? 0) + leverage
        return (min: minValue, max: maxValue)
    }
    
    // Get color based on Statistic
    func getColorForStatistic(_ statistic: Statistic) -> Color {
        switch statistic {
        case .weight:
            return Color.blue
        case .steps:
            return Color.green
        case .calories:
            return Color.orange
        }
    }

    var body: some View {
        let (seriesData, wasDataNormalized) = getSeries(statisticData: statisticData, selectedChartStatistic: selectedChartStatistic)
        let range = yValuesRange(isDataNormalized: wasDataNormalized)
        
        return Chart(seriesData) { series in
            ForEach(series.data, id: \.self) { data in
                LineMark(
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(by: .value("", series.name))
                .interpolationMethod(.catmullRom)
                
                PointMark (
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(by: .value("", series.name))
                .interpolationMethod(.linear)
            }
        }
        .chartXAxis() {
            AxisMarks(
                values: .stride(by: .day, count: 1)
            ) { value in
                if let date = value.as(Date.self) {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.1))
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                    AxisValueLabel {
                        if statisticData.count <= 7 {
                            Text(date, format: .dateTime.day(.defaultDigits).month(.abbreviated)
                            )
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: (UIScreen.main.bounds.width / CGFloat(statisticData.count)))
                        } else if statisticData.count > 15 && statisticData.count <= 31 {
                            if statisticData.count <= 31 && Calendar.current.component(.day, from: date) == 1 ||
                                Calendar.current.component(.day, from: date) == statisticData.count ||
                                (statisticData.count > 16 && Calendar.current.component(.day, from: date) % 3 == 1) {
                                Text(date, format: .dateTime.day(.defaultDigits))
                                    .multilineTextAlignment(.center)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .frame(width: 50)
                            } else {
                                Text("")
                            }
                        } else if statisticData.count > 31 {
                            // Show months names only
                            if date.isFirstDayOfMonth {
                                Text(date, format: .dateTime.month(.abbreviated)
                                )
                                .frame(width: 100)
                            }
                        }
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic()) { value in
                if !wasDataNormalized, let labelValue = value.as(Int.self) {
                    // Only show label when data is not normalized
                    AxisValueLabel {
                        VStack() {
                            Text("\(labelValue)")
                        }
                    }
                }
                
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                AxisTick(stroke: StrokeStyle(lineWidth: 0))
            }
        }
        .chartYScale(domain: [range.min, range.max])
        .chartLegend(.visible)
        .chartLegend(position: .automatic, alignment: .center, spacing: 10)
        .opacity(isEditingTodayStatistic ? 0 : 1)
        .animation(SwiftUI.Animation.default, value: 0.5)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    func getSeries(statisticData: [StatisticDataObject], selectedChartStatistic: [Statistic]) -> ([StatisticSeries], Bool) {
        var dataMappings: [Statistic: [DataSeries]] = [
            .weight: [],
            .steps: [],
            .calories: []
        ]
        var isDataNormalized = false

        for data in statisticData {
            let date = data.date

            let normalizedWeight = normalize(value: data.weight, fromOldRange: (40, 150), toNewRange: (0, 100))
            let normalizedSteps = normalize(value: Double(data.steps), fromOldRange: (0, 20000), toNewRange: (0, 100))
            let normalizedCalories = normalize(value: Double(data.calories), fromOldRange: (0, 3000), toNewRange: (0, 100))

            if selectedChartStatistic.contains(.weight), data.weight != 0 {
                let value = selectedChartStatistic.count > 1 ? normalizedWeight : data.weight
                dataMappings[.weight]?.append(DataSeries(value: value, date: date))
            }

            if selectedChartStatistic.contains(.steps), data.steps != 0 {
                let value = selectedChartStatistic.count > 1 ? normalizedSteps : Double(data.steps)
                dataMappings[.steps]?.append(DataSeries(value: value, date: date))
            }

            if selectedChartStatistic.contains(.calories), data.calories != 0 {
                let value = selectedChartStatistic.count > 1 ? normalizedCalories : Double(data.calories)
                dataMappings[.calories]?.append(DataSeries(value: value, date: date))
            }

            if selectedChartStatistic.count > 1 {
                isDataNormalized = true
            }
        }

        let seriesData = selectedChartStatistic.compactMap { statistic -> StatisticSeries? in
            guard let dataSeries = dataMappings[statistic] else { return nil }
            return StatisticSeries(name: statistic.rawValue.capitalized, data: dataSeries)
        }

        return (seriesData, isDataNormalized)
    }


}



struct StatisticSeries: Identifiable {
    let name: String
    let data: [DataSeries]
    
    var id: String { name }
}

struct DataSeries: Identifiable, Hashable {
    let value: Double
    let date: Date
    
    var id: Date { date }
}

func normalize(value: Double, fromOldRange oldRange: (Double, Double), toNewRange newRange: (Double, Double)) -> Double {
    return (value - oldRange.0) / (oldRange.1 - oldRange.0) * (newRange.1 - newRange.0) + newRange.0
}



