//
//  StatisticBoxView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct StatisticBoxView: View {
    var title: String
    var value: String
    var goalValue: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
            Text(value)
                .font(.subheadline)
            Spacer()
            Text("Goal: \(goalValue)")
                .font(.subheadline)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
        }
        .frame(width: 110, height: 100) // Set a fixed width and height for each box
        .background(Color.blue.opacity(0.7))
        .cornerRadius(10)
    }
}
