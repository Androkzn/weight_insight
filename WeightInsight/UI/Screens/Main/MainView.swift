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
    
    var body: some View {
        VStack {
            //Average Statistic View 
            AverageStatisticView(
                selectedFilter: $viewModel.selectedFilter,
                avgData: $viewModel.averageStatistic,
                goals: $settingsViewModel.goals
            )
            
            // Multi Statistic Chart View
            ChartView(
                selectedChartStatistic: $viewModel.selectedChartStatistic,
                statisticData: $viewModel.statisticDataFiltered,
                isEditingTodayStatistic: $viewModel.isEditingTodayStatistic
            )
            
            // Selection of statistic type for displaying on the chart
            StatisticChartSelectionView(
                selectedChartStatistic: $viewModel.selectedChartStatistic
            )
            
            // Specific date statistic view
            DateStatisticView(
                selectedStatistic: $viewModel.selectedStatistic,
                isEditingTodayStatistic: $viewModel.isEditingTodayStatistic,
                selectedDate: $viewModel.selectedDate,
                selectedStatisticType: $viewModel.selectedStatisticType
            )
        }
    }
}
 
#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
            .environmentObject(StatisticsView.ViewModel(dataService: RealmService(),mainViewModel:  MainView.ViewModel(dataService: RealmService())))
            .environmentObject(SettingsView.ViewModel())
            .environmentObject(MainView.ViewModel(dataService: RealmService()))
    }
}
#endif





