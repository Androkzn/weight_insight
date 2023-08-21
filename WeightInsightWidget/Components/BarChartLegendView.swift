//
//  BarChartLegendView.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import SwiftUI

struct BarChartLegendView: View {
    var period: String = "This Week"
    
    var body: some View {
        HStack {
            Spacer()
            LegendItem(color: Color.blue.opacity(0.5), text: "Today")
            Spacer()
            LegendItem(color: Color.orange.opacity(0.5), text: "Avg \(period)")
            Spacer()
            LegendItem(color: Color.green.opacity(0.5), text: "Your goal")
            Spacer()
        }
    }
}

struct LegendItem: View {
    var color: Color
    var text: String
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(text)
                .font(.system(size: 11))
        }
    }
}

