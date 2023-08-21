//
//  ExtendedStatisticRow.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import SwiftUI


struct ExtendedStatisticRow: View {
    var imageName: String
    var imageColor: Color
    var value: String
    var dataPoints: [(color: Color, value: CGFloat)]
    var format: String

    var body: some View {
        VStack() {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(6)
                .frame(width: 25, height: 25)
                .foregroundColor(imageColor)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(imageColor, lineWidth: 2)
                )
            BarChartView(dataPoints: dataPoints, format: format)
            Spacer()
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        .background(Color.white.opacity(1.0))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.6), lineWidth: 1)
        )
    }
}
