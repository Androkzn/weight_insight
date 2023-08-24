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
    
    @State private var selectedChartStatistic: [Statistic] = [.weight]
    @State private var selectedWeight: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isEditingTodayStatistic: Bool = false
    @State private var selectedStatisticType: Statistic?  
    @State private var selectedStatistic: StatisticDataObject = StatisticDataObject()
    
    var body: some View {
        VStack {
            //Average Statistic View 
            AverageStatisticView(
                selectedFilter: $viewModel.dataStore.selectedFilter,
                avgData: $viewModel.dataStore.averageStatistic,
                goals: $viewModel.dataStore.goals
            ) {
                viewModel.dataStore.updateStatisticForFilter()
                viewModel.saveSharedData()
            } 
            
            // Multi Statistic Chart View
            ChartView(
                selectedChartStatistic: $selectedChartStatistic,
                statisticData: $viewModel.dataStore.statisticDataFiltered,
                isEditingTodayStatistic: $isEditingTodayStatistic
            )
            // Selection of statistic type for displaying on the chart
            StatisticChartSelectionView(
                selectedChartStatistic: $selectedChartStatistic
            )
            
            // Specific date statistic view
            DateStatisticView(
                selectedStatistic: $selectedStatistic,
                isEditingTodayStatistic: $isEditingTodayStatistic,
                selectedDate: viewModel.selectedDate,
                selectedStatisticType: $selectedStatisticType
            ) { selectedDate in
                // Date selected action
                viewModel.selectedDate = selectedDate
                selectedStatistic = viewModel.getStatisticForDate
                viewModel.saveSharedData()
            }
        }.onAppear {
            // Fill with saved statistic data
            selectedStatistic = viewModel.getStatisticForDate
            // Update shared data statistic
            viewModel.saveSharedData()
        }
    }
    
    
}
 
#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
    }
}
#endif





