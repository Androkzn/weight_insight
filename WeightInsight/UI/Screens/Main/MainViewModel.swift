//
//  MainViewModel.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import UIKit
import WidgetKit

extension MainView {
    class ViewModel: ObservableObject {
        private let dataService: DataServiceProtocol
        
        @Published var statisticDataGrouped: [String: [StatisticDataObject]] = [:]
        @Published var statisticDataFiltered: [StatisticDataObject] = []
        @Published var selectedChartStatistic: [Statistic] = [.weight]
        @Published var selectedStatisticType: Statistic?
        @Published var selectedStatistic: StatisticDataObject = StatisticDataObject()
        @Published var averageStatistic: StatisticData = StatisticData.defaultInstance()
        
        @Published var selectedDate: Date = Date() {
            didSet {
                getStatisticForDate()
                saveSharedData()
            }
        }
        
        @Published var selectedFilter: StatisticFilter = .thisWeek{
            didSet {
                getStatisticDataFiltered()
                getAverageStatistic()
                saveSharedData()
            }
        }
        
        @Published var isEditingTodayStatistic: Bool = false {
            didSet {
                getStatisticDataFiltered()
                getAverageStatistic()
            }
        }
        
        @Published var statisticDataSaved: Bool = false  {
            didSet {
                getStatisticDataFiltered()
                getAverageStatistic()
                getStatisticForDate()
                saveSharedData()
            }
        }
         
        init(dataService: DataServiceProtocol) {
            self.dataService = dataService
            
            getStatisticDataFiltered()
            getAverageStatistic()
            getStatisticForDate()
            saveSharedData()
        }
        
        func getStatisticForDate()  {
            if let statisticObject  = dataService.getStatisticForDate(date: selectedDate) {
                selectedStatistic =  statisticObject
            } else {
                // if do not have statistic data for the selected date
                // we need to create an empty statistic object
                selectedStatistic = dataService.saveNewStatisticData(data: StatisticData.defaultInstance())
            }
        }
        
        func saveStatisticData(statistic: Statistic, value: Double, date: Date = Date()) {
            dataService.saveStatistic(type: statistic, value: value, date: date)
            // Update shared data statistic
            saveSharedData()
        }
        
        func loadSettingValue(for settingType: SettingsType) -> String {
            UserDefaults.standard.string(forKey: settingType.rawValue) ?? "0"
        }
        
        func saveSharedData()  {
            let todayStat = selectedStatistic

            // Populate with new data
            // Today stat
            var sharedData = SharedData.defaultInstance()
            sharedData.todayWeight = Double(todayStat.weight)
            sharedData.todaySteps = Double(todayStat.steps)
            sharedData.todayCalories = Double(todayStat.calories)
            // Average stat
            sharedData.avgWeight = Double(averageStatistic.weight) ?? 0
            sharedData.avgSteps = Double(averageStatistic.steps) ?? 0
            sharedData.avgCalories = Double(averageStatistic.calories) ?? 0
            // Target stat
            sharedData.targetWeight = Double(loadSettingValue(for: .weight)) ?? 0
            sharedData.targetSteps = Double(loadSettingValue(for: .steps)) ?? 0
            sharedData.targetCalories = Double(loadSettingValue(for: .calories)) ?? 0
            // Period
            sharedData.selectedPeriod = selectedFilter.title
            
            // Save data
            sharedData.save()
            
            // Refresh widget
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        func getAverageStatistic() {
            let allData = dataService.getAllStatistic()
            let filter = selectedFilter
            var filteredData: [StatisticDataObject] = []
            
            switch filter {
            case .thisWeek:
                filteredData = allData.filter { $0.date.isInThisWeek }
            case .previousWeek:
                filteredData = allData.filter { $0.date.isInPreviousWeek }
            case .thisMonth:
                filteredData = allData.filter { $0.date.isInThisMonth }
            case .lastMonth:
                filteredData = allData.filter { $0.date.isInLastMonth }
            case .all:
                filteredData = allData
            }
            
            // Compute averages for each type separately
            let totalWeight = filteredData.reduce(0.0) { $0 + ($1.weight > 0 ? $1.weight : 0) }
            let totalSteps = filteredData.reduce(0) { $0 + ($1.steps > 0 ? $1.steps : 0) }
            let totalCalories = filteredData.reduce(0) { $0 + ($1.calories > 0 ? $1.calories : 0) }
            
            let nonZeroWeightCount = filteredData.filter { $0.weight > 0 }.count
            let nonZeroStepsCount = filteredData.filter { $0.steps > 0 }.count
            let nonZeroCaloriesCount = filteredData.filter { $0.calories > 0 }.count
            
            var averageWeight = nonZeroWeightCount > 0 ? totalWeight / Double(nonZeroWeightCount) : 0
            averageWeight = (averageWeight * 100).rounded() / 100  // Format to 2 decimal places
            
            let averageSteps = nonZeroStepsCount > 0 ? Int(totalSteps) / nonZeroStepsCount : 0
            let averageCalories = nonZeroCaloriesCount > 0 ? Int(totalCalories) / nonZeroCaloriesCount : 0
            
            averageStatistic = StatisticData(weight: String(averageWeight), steps: String(averageSteps), calories: String(averageCalories))
        }
    
        func getStatisticDataFiltered()  {
            let allData = Array(dataService.getAllStatistic())
            
            switch selectedFilter {
            case .thisWeek:
                statisticDataFiltered =  allData.filter { $0.date.isInThisWeek }
            case .previousWeek:
                statisticDataFiltered = allData.filter { $0.date.isInPreviousWeek }
            case .thisMonth:
                statisticDataFiltered = allData.filter { $0.date.isInThisMonth }
            case .lastMonth:
                statisticDataFiltered =   allData.filter { $0.date.isInLastMonth }
            case .all:
                statisticDataFiltered = allData
            }
        }
    }
}
