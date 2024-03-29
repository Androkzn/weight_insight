//
//  DateStatisticView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-22.
//

import SwiftUI

struct DateStatisticView: View {
    @Binding var selectedStatistic: StatisticData
    @Binding var isEditingTodayStatistic: Bool
    @Binding var selectedDate: Date 
    @Binding var selectedStatisticType: Statistic?
    
    var body: some View {
        // Date picker
        HStack() {
            Text("Your data for")
                .font(.headline)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
            
            Spacer()
            
            DatePicker("", selection: $selectedDate,  in: ...Date(), displayedComponents: .date)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            
        }
        .background(Color.orange.opacity(0.3))
        .cornerRadius(10)
        .padding(EdgeInsets(top:10, leading: 10, bottom:0, trailing: 10))
        
        // Statistic for selected date
        HStack(spacing: 10) {
            DateStatisticBoxView(
                value: $selectedStatistic.weight,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .weight
            )

            DateStatisticBoxView(
                value: $selectedStatistic.steps,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .steps
            )

            DateStatisticBoxView(
                value: $selectedStatistic.calories,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .calories
            )
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

