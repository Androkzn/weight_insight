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
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Text(value)
                .font(.subheadline)
            Spacer(minLength: 10)
            Text("Goal: \(goalValue)")
                .font(.subheadline)
        }
        .padding(10)
    }
}
