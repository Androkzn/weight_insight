//
//  MultiLineChartView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-16.
//

import Foundation
import SwiftUICharts
import SwiftUI

struct MultiLineChartView: View {
    @Binding  var statisticData: [StatisticDataObject]
     
    var multiLineChartData: MultiLineChartData {
        
        var weightDataset: [LineChartDataPoint] = []
        var stepsDataset: [LineChartDataPoint] = []
        var caloriesDataset: [LineChartDataPoint] = []
        
        for data in statisticData  {
            weightDataset.append(LineChartDataPoint(value: data.weight, xAxisLabel: data.date.formattedString(format: "dd MMM"), description: ""))
            stepsDataset.append(LineChartDataPoint(value: Double(data.steps), xAxisLabel: data.date.formattedString(format: "dd MMM"), description: ""))
            caloriesDataset.append(LineChartDataPoint(value: Double(data.calories), xAxisLabel: data.date.formattedString(format: "dd MMM"), description: ""))
            
        }
        
        let multiLineDataSet = MultiLineDataSet(dataSets: [
            LineDataSet(dataPoints: weightDataset,
                        legendTitle: "",
                        pointStyle: PointStyle(pointType: .filled, pointShape: .roundSquare),
                        style: LineStyle(lineColour: ColourStyle(colour: .blue), lineType: .curvedLine)),
            LineDataSet(dataPoints: stepsDataset,
                        pointStyle: PointStyle(pointType: .filled, pointShape: .roundSquare),
                        style: LineStyle(lineColour: ColourStyle(colour: .green), lineType: .curvedLine)),
            LineDataSet(dataPoints: caloriesDataset,
                        pointStyle: PointStyle(pointType: .filled, pointShape: .roundSquare),
                        style: LineStyle(lineColour: ColourStyle(colour: .orange), lineType: .curvedLine)),
        ])
        
        let lineChartStyle = LineChartStyle(
            infoBoxPlacement: .floating,
            // markerType: .full(attachment: .line(dot: .style(DotStyle()))),
            xAxisGridStyle: GridStyle(numberOfLines: 1),
            yAxisGridStyle: GridStyle(numberOfLines: 1),
            yAxisNumberOfLabels: 6,
            baseline: .zero,
            topLine: .maximumValue
        )
        
        return MultiLineChartData(dataSets: multiLineDataSet, chartStyle: lineChartStyle)
    }

    var body: some View {
        VStack {
            MultiLineChart(chartData: multiLineChartData)
                //.touchOverlay(chartData: multiLineChartData, specifier: "%.01f", unit: .suffix(of: "ºC"))
                .pointMarkers(chartData: multiLineChartData)
                .xAxisGrid(chartData: multiLineChartData)
                .yAxisGrid(chartData: multiLineChartData)
                .xAxisLabels(chartData: multiLineChartData)
                .yAxisLabels(chartData: multiLineChartData, specifier: "%.01f")
                .floatingInfoBox(chartData: multiLineChartData)
                .headerBox(chartData: multiLineChartData)
                .legends(chartData: multiLineChartData, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                .id(multiLineChartData.id)
                .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 500, maxHeight: 600, alignment: .center)
                .padding(SwiftUI.EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}
