//
//  MainView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var selectedFilter: StatisticFilter = .thisWeek
    @State private var selectedWeight: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isStatisticPickerExpanded: Bool = false
    @State private var isWeightPickerExpanded: Bool = false
    @State private var isEditingTodayStatistic: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                StatisticBoxView(
                    title: Statistic.weight.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).weight,
                    goalValue: "\(viewModel.loadSettingValue(for: .weight))"
                )
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
                
                StatisticBoxView(
                    title: Statistic.steps.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).steps,
                    goalValue: "\(viewModel.loadSettingValue(for: .steps))"
                )
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
                
                StatisticBoxView(
                    title: Statistic.calories.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).calories,
                    goalValue: "\(viewModel.loadSettingValue(for: .calories))"
                )
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                withAnimation {
                    isStatisticPickerExpanded.toggle()
                }
            }) {
                Text(selectedFilter.title)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            if isStatisticPickerExpanded {
                WheelPickerView(selectedItem: $selectedFilter, isPickerExpanded: $isStatisticPickerExpanded)
                .frame(height: 150)
                .padding(.horizontal)
                .transition(.slide)
            }
            
            Text("Your numbers today")
                .font(.headline)
                .padding(.top, 20)
            

            HStack(spacing: 10) {
                TodayStatisticBoxView(value: $selectedWeight, isEditingTodayStatistic: $isEditingTodayStatistic, statisticType: Statistic.weight) {
                     withAnimation {
                         isWeightPickerExpanded.toggle()
                         isEditingTodayStatistic.toggle()
                     }
                 }
                 TodayStatisticBoxView(value: $selectedSteps, isEditingTodayStatistic: $isEditingTodayStatistic, statisticType: Statistic.steps) {
                     isEditingTodayStatistic.toggle()
                }
                 TodayStatisticBoxView(value: $selectedCalories, isEditingTodayStatistic: $isEditingTodayStatistic, statisticType: Statistic.calories) {
                     isEditingTodayStatistic.toggle()
                }
            }
            .padding()
            
            if isWeightPickerExpanded {
                DoubleWheelPickerView(selectedWeight: $selectedWeight, isPickerExpanded: $isWeightPickerExpanded)
                    .transition(.move(edge: .bottom))
            }
            
        }.onAppear {
            // Fill with saved statistic data
            let statisticData = viewModel.getTodayStatistic()
            self.selectedWeight = Double(statisticData.weight) ?? 0
            self.selectedSteps = Double(statisticData.steps) ?? 0
            self.selectedCalories = Double(statisticData.calories) ?? 0
        }
    }
}






