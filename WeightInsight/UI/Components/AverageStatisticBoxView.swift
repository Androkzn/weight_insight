//
//  StatisticBoxView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct AverageStatisticBoxView: View {
    var title: String
    var value: String
    var goalValue: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.subheadline)
                .padding(EdgeInsets(top: 1, leading: 25, bottom: 1, trailing: 25))
                .bold()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            Text("Goal: \(goalValue)")
                .font(.subheadline)
               
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .frame(width: 110)
        .cornerRadius(10)
    }
 
}
