//
//  MainView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import RealmSwift

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var settingsViewModel: SettingsView.ViewModel
    
    @State private var selectedFilter: StatisticFilter = .thisWeek
    @State private var selectedDate: Date = Date()
    @State private var selectedChartStatistic: [Statistic] = [.weight]
    @State private var selectedWeight: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isEditingTodayStatistic: Bool = false
    @State private var statisticData: [StatisticDataObject] = []
    @State private var statisticCurrent: StatisticData = StatisticData(weight: "0", steps: "0", calories: "0")
    @State private var statisticAverage: StatisticData = StatisticData(weight: "0", steps: "0", calories: "0")
    @State private var selectedStatisticType: Statistic?  
    
    var body: some View {
        VStack {
            //Average Statistic View 
            AverageStatisticView(
                selectedFilter: $selectedFilter,
                avgWeight: $statisticAverage.weight,
                avgSteps: $statisticAverage.steps,
                avgCalories: $statisticAverage.calories,
                goalWeight: $settingsViewModel.weightGoal,
                goalSteps: $settingsViewModel.stepsGoal,
                goalCalories: $settingsViewModel.caloriesGoal
            ) {
                self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
                self.statisticAverage = viewModel.getStatisticFor(filter: selectedFilter)
                viewModel.saveSharedData(filter: selectedFilter)
            }.onChange(of: isEditingTodayStatistic) { _ in
                self.statisticAverage = viewModel.getStatisticFor(filter: selectedFilter)
            }
            
            // Multi Statistic Chart View
            ChartView(
                selectedChartStatistic: $selectedChartStatistic,
                statisticData: $statisticData,
                isEditingTodayStatistic: $isEditingTodayStatistic
            )
            // Selection of statistic type for displaying on the chart
            StatisticChartSelectionView(
                selectedChartStatistic: $selectedChartStatistic
            )
            
            // Specific date statistic view
            DateStatisticView(
                selectedWeight: $selectedWeight,
                selectedSteps: $selectedSteps,
                selectedCalories: $selectedCalories,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: $selectedDate,
                selectedStatisticType: $selectedStatisticType
            ) { selectedDate in
                // Date selected action
                self.selectedDate = selectedDate
                self.updateStatisticForSelectedDate(date: selectedDate)
                viewModel.saveSharedData(filter: selectedFilter)
            }
        }.onAppear {
            // Update statistic data for chart based on current filter
            self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
            // Update average statistic data based on current filter
            self.statisticAverage = viewModel.getStatisticFor(filter: selectedFilter)
            // Fill with saved statistic data
            updateStatisticForSelectedDate(date: selectedDate)
            // Update shared data statistic
            viewModel.saveSharedData(filter: selectedFilter)
        }
    }
    
    func updateStatisticForSelectedDate(date: Date) {
        self.statisticCurrent = viewModel.getStatisticForDate(date: date)
        self.selectedWeight = Double(self.statisticCurrent.weight) ?? 0
        self.selectedSteps = Double(self.statisticCurrent.steps) ?? 0
        self.selectedCalories = Double(self.statisticCurrent.calories) ?? 0
    }
}
 
#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
            .environmentObject(MainView.ViewModel())
            .environmentObject(SettingsView.ViewModel())
            .environmentObject(StatisticsView.ViewModel())
    }
}
#endif





