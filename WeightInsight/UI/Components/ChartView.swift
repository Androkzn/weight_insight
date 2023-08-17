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
    @State private var isDataNormalized: Bool = false
    
    var yValuesRange: (min: Double, max: Double) {
        if isDataNormalized {
            return (min: 0, max: 100) // Normalized range
        } else if selectedChartStatistic.count > 1 {
            return combinedRangeFor(selectedStatistics: selectedChartStatistic)
        } else if let firstStatistic = selectedChartStatistic.first {
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
            values = statisticData.map { $0.weight }
            leverage = 1
        case .steps:
            values = statisticData.map { Double($0.steps) }
            leverage = 500
        case .calories:
            values = statisticData.map { Double($0.calories) }
            leverage = 200
        }
 
        let minValue = (values.min() ?? 0) - leverage
        let maxValue = (values.max() ?? 0) + leverage
        return (min: minValue, max: maxValue)
    }

    func combinedRangeFor(selectedStatistics: [Statistic]) -> (min: Double, max: Double) {
        var allValues: [Double] = []

        for statistic in selectedStatistics {
            switch statistic {
            case .weight:
                allValues.append(contentsOf: statisticData.map { $0.weight })
            case .steps:
                allValues.append(contentsOf: statisticData.map { Double($0.steps) })
            case .calories:
                allValues.append(contentsOf: statisticData.map { Double($0.calories) })
            }
        }

        let minValue = (allValues.min() ?? 0) - 50
        let maxValue = (allValues.max() ?? 0) + 50
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
        Chart(getSeries(statisticData: statisticData, selectedChartStatistic: selectedChartStatistic)) { series in
            ForEach(series.data, id: \.self) { data in
                LineMark(
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(by: .value("City", series.name))
                .interpolationMethod(.linear)
                
                PointMark (
                    x: .value("Day", data.date, unit: .day),
                    y: .value("Value", data.value)
                )
                .foregroundStyle(by: .value("City", series.name))
                .interpolationMethod(.linear)
            }
        }
        .chartXAxis {
            AxisMarks(
                values: .stride(by: .day, count: 1)
            ) { value in
                if let date = value.as(Date.self) {
                    AxisTick()
                    AxisValueLabel {
                        VStack() {
                            if statisticData.count <= 7 {
                                Text(date, format: .dateTime.day(.defaultDigits).month(.abbreviated)
                                )
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 110)
                            } else if statisticData.count <= 31 {
                                Text(date, format: .dateTime.day(.defaultDigits)
                                )
                                .multilineTextAlignment(.center)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 110)
//                                .rotationEffect(.degrees(90))
//                                .layoutPriority(1)
                            } else {
                                Text(date, format: .dateTime.month(.abbreviated))
                            }
                        }
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic())
        }
        .chartYScale(domain: [yValuesRange.min, yValuesRange.max])
        .chartLegend(.hidden)
        .opacity(isEditingTodayStatistic ? 0 : 1)
        .animation(SwiftUI.Animation.default, value: 0.5)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    func getSeries(statisticData: [StatisticDataObject], selectedChartStatistic: [Statistic]) -> [StatisticSeries] {
        var dataMappings: [Statistic: [DataSeries]] = [
            .weight: [],
            .steps: [],
            .calories: []
        ]
        
        for data in statisticData {
            let date = data.date
            
            let normalizedWeight = normalize(value: data.weight, fromOldRange: (40, 150), toNewRange: (0, 100))
            let normalizedSteps = normalize(value: Double(data.steps), fromOldRange: (0, 20000), toNewRange: (0, 100))
            let normalizedCalories = normalize(value: Double(data.calories), fromOldRange: (0, 3000), toNewRange: (0, 100))
            
            if selectedChartStatistic.contains(.weight) {
                let value = selectedChartStatistic.count > 1 ? normalizedWeight : data.weight
                dataMappings[.weight]?.append(DataSeries(value: value, date: date))
            }
            
            if selectedChartStatistic.contains(.steps) {
                let value = selectedChartStatistic.count > 1 ? normalizedSteps : Double(data.steps)
                dataMappings[.steps]?.append(DataSeries(value: value, date: date))
            }
            
            if selectedChartStatistic.contains(.calories) {
                let value = selectedChartStatistic.count > 1 ? normalizedCalories : Double(data.calories)
                dataMappings[.calories]?.append(DataSeries(value: value, date: date))
            }
            
            if selectedChartStatistic.count > 1 {
                isDataNormalized = true
            } else {
                isDataNormalized = false
            }
        }
        
        let seriesData = selectedChartStatistic.compactMap { statistic -> StatisticSeries? in
            guard let dataSeries = dataMappings[statistic] else { return nil }
            return StatisticSeries(name: statistic.rawValue.capitalized, data: dataSeries)
        }
        
        return seriesData
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



