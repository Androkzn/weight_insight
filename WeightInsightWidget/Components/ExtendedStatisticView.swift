//
//  AverageStatisticWidgetView.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import Foundation
import SwiftUI

struct ExtendedStatisticView: View {
    var data: SharedData

    var body: some View {
        VStack {
            HStack {
                statisticRow(
                    imageName: "scalemass",
                    imageColor: .blue,
                    value: "Weight",
                    today: data.todayWeight,
                    average: data.avgWeight,
                    target: data.targetWeight,
                    format: "%.2f"
                )
                Spacer()
                statisticRow(
                    imageName: "figure.walk",
                    imageColor: .green,
                    value: "Steps",
                    today: data.todaySteps,
                    average: data.avgSteps,
                    target: data.targetSteps,
                    format: "%.0f"
                )
                Spacer()
                statisticRow(
                    imageName: "flame",
                    imageColor: .orange,
                    value: "Calories",
                    today: data.todayCalories,
                    average: data.avgCalories,
                    target: data.targetCalories,
                    format: "%.0f"
                )
            }
            .padding(EdgeInsets(top:0, leading: 0, bottom: 3, trailing: 0))
            
            BarChartLegendView(period: data.selectedPeriod)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 10, trailing: 10))
        .background(Color.blue.opacity(0.2))
    }
    
    func statisticRow(imageName: String, imageColor: Color, value: String, today: Double, average: Double, target: Double, format: String) -> some View {
        ExtendedStatisticRow(
            imageName: imageName,
            imageColor: imageColor,
            value: value,
            dataPoints: [
                (Color.blue.opacity(0.3), CGFloat(today)),
                (Color.orange.opacity(0.3), CGFloat(average)),
                (Color.green.opacity(0.3), CGFloat(target))
            ],
            format: format
        )
    }
}

 
