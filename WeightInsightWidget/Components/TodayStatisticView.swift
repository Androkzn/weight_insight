//
//  TodayStatisticView.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import SwiftUI

struct TodayStatisticView: View {
    var data: SharedData
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(Date().formattedString(format: "dd MMM yyyy"))
                    .font(.headline)
                    .bold()
                    .frame(width: 200,height: 40)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                TodayStatisticRowView(imageName: "scalemass", color: Color.blue, value: String(format: data.todayWeight == 0 ? "%.0f" : "%.2f", data.todayWeight), units: "kg")
                TodayStatisticRowView(imageName: "figure.walk", color: Color.green, value: NumberFormatter.localizedString(from: NSNumber(value: data.todaySteps), number: .decimal),units: "st.")
                TodayStatisticRowView(imageName: "flame", color: Color.orange, value:  String(format: "%.0f", data.todayCalories), units: "kcal")
            }
            .padding(EdgeInsets(top: 00, leading: 10, bottom: 10, trailing: 10))
            Spacer()
        }
        .background(Color.white.opacity(0.1))
    }
}
