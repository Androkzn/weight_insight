//
//  BarChartView.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import Foundation
import  SwiftUI

struct BarChartView: View {
    var dataPoints: [(color: Color, value: CGFloat)]
    var format: String
    var maxBarHeight: CGFloat = 70

    var maxValue: CGFloat {
        dataPoints.map { $0.value }.max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(dataPoints, id: \.color) { data in
                ZStack(alignment: .leading) {
                    if data.value == 0 {
                        RightRoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(width: maxBarHeight, height: 15)
                            .overlay(
                                RightRoundedRectangle(cornerRadius: 8)
                                    .stroke(data.color.opacity(2), lineWidth: 1)
                            )
                    } else {
                        RightRoundedRectangle(cornerRadius: 8)
                            .fill(data.color)
                            .frame(width: self.barWidth(for: data.value), height: 20)
                    }
                    
                    Text(String(format: data.value == 0 ? "%.0f" : format, data.value))
                        .foregroundColor(.black)
                        .font(.system(size: 13))
                        .bold()
                        .padding(.leading, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .zIndex(1)
                }
            }
        }
        .animation(SwiftUI.Animation.default, value: 0.5)
    }



    func barWidth(for value: CGFloat) -> CGFloat {
        (value / maxValue) * maxBarHeight
    }
}


struct RightRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
