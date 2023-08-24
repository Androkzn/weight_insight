//
//  DateStatisticView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-22.
//

import SwiftUI

struct DateStatisticView: View {
    @Binding var selectedWeight: Double
    @Binding var selectedSteps: Double
    @Binding var selectedCalories: Double
    @Binding var isEditingTodayStatistic: Bool
    @Binding var selectedDate: Date
    @Binding var selectedStatisticType: Statistic?

    var onDateSelected: (Date) -> Void
    
    var body: some View {
        // Date picker
        HStack() {
            Text("Your data for")
                .font(.headline)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
            
            Spacer()
            
            DatePicker("", selection: $selectedDate,  in: ...Date(), displayedComponents: .date)
                .onChange(of: selectedDate) { newDate in
                    onDateSelected(newDate)
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
            
        }
        .background(Color.orange.opacity(0.3))
        .cornerRadius(10)
        .padding(EdgeInsets(top:10, leading: 10, bottom:0, trailing: 10))
        
        // Statistic for selected date
        HStack(spacing: 10) {
            DateStatisticBoxView(
                value: $selectedWeight,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .weight
            )
            
            DateStatisticBoxView(
                value: $selectedSteps,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .steps
            )
            
            DateStatisticBoxView(
                value: $selectedCalories,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType,
                statisticType: .calories
            )  
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    private func updateAllStatistic() {
       
    }
}

