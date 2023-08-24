//
//  AverageStatisticView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-22.
//

import SwiftUI

struct AverageStatisticView: View {
    @Binding  var selectedFilter: StatisticFilter
    @Binding var avgWeight: String
    @Binding var avgSteps: String
    @Binding var avgCalories: String
    @Binding var goalWeight: String
    @Binding var goalSteps: String
    @Binding var goalCalories: String
    
    var onFilterTapped: () -> Void
    
    var body: some View {
        // Filter box view
        HStack() {
            Text("Average statistic:")
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .font(.headline)
            
            Spacer()
            
            Picker("Filter period", selection: $selectedFilter) {
                ForEach(StatisticFilter.allCases, id: \.self) {
                    Text($0.title)
                }
            }.onChange(of: selectedFilter) { selectedFilter in
                onFilterTapped()
            }
            .pickerStyle(.menu)
            .tint(.black)
        }
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        
        // Average statistic boxes view
        HStack(spacing: 0) {
            AverageStatisticBoxView(
                title: Statistic.weight.title,
                value: avgWeight,
                goalValue: goalWeight
            )
            
            Spacer()
            
            AverageStatisticBoxView(
                title: Statistic.steps.title,
                value: avgSteps,
                goalValue: goalSteps
            )
            
            Spacer()
            
            AverageStatisticBoxView(
                title: Statistic.calories.title,
                value: avgCalories,
                goalValue: goalCalories
            )
            
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
