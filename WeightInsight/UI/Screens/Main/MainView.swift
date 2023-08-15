//
//  MainView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import Charts

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
            HStack() {
                Text("Average statistic for the period: ")
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .font(.headline)
                Spacer()
                Button(action: {
                    withAnimation {
                        isStatisticPickerExpanded.toggle()
                    }
                }) {
                    Text(selectedFilter.title)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(10)
                        .tint(.black)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    
            }
            .background(Color.blue.opacity(0.7))
            .cornerRadius(10)
            .frame(height: 100)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        
            HStack(spacing: 10) {
                StatisticBoxView(
                    title: Statistic.weight.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).weight,
                    goalValue: "\(viewModel.loadSettingValue(for: .weight))"
                )
                StatisticBoxView(
                    title: Statistic.steps.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).steps,
                    goalValue: "\(viewModel.loadSettingValue(for: .steps))"
                )
                StatisticBoxView(
                    title: Statistic.calories.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).calories,
                    goalValue: "\(viewModel.loadSettingValue(for: .calories))"
                )
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
            
            Spacer()
            
        }.onAppear {
            // Fill with saved statistic data
            let statisticData = viewModel.getTodayStatistic()
            self.selectedWeight = Double(statisticData.weight) ?? 0
            self.selectedSteps = Double(statisticData.steps) ?? 0
            self.selectedCalories = Double(statisticData.calories) ?? 0
        }
    }
}


 












