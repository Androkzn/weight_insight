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
        private var cancellables = Set<AnyCancellable>()
        @Published var previousFiler: StatisticFilter = .thisWeek
        @Published var statisticDataGrouped: [String: [StatisticDataObject]] = [:]
        @Published var statisticDataFiltered: [StatisticDataObject] = []
        @Published var selectedChartStatistic: [Statistic] = [.weight]
        @Published var selectedStatisticType: Statistic?
        @Published var selectedStatistic: StatisticData = StatisticData.defaultInstance()
        @Published var averageStatistic: StatisticData = StatisticData.defaultInstance()
        @Published var isEditingTodayStatistic: Bool = false
        @Published var showCustomFilterPopup: Bool = false
        @Published var selectedStartDate: Date = Date()
        @Published var selectedEndDate: Date = Date()
        
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
                
                if selectedFilter == .custom {
                    showCustomFilterPopup = true
                } else {
                    previousFiler = selectedFilter
                }
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
                
                selectedStatistic =  StatisticData.fromObject(statisticObject)
            } else {
                // if do not have statistic data for the selected date
                // we need to create an empty statistic object
                let newStatisticObject = dataService.saveNewStatisticData(data: StatisticData.defaultInstance())
                selectedStatistic = StatisticData.fromObject(newStatisticObject)
            }
        }
        
        func saveStatisticData(statistic: Statistic, value: String, date: Date = Date()) {
            let doubleValue = Double(value) ?? 0
            dataService.saveStatistic(type: statistic, value: doubleValue, date: date)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.getStatisticDataFiltered()
                    self?.getAverageStatistic()
                    // Update shared data statistic
                    self?.saveSharedData()
                }
                .store(in: &cancellables)
        }
        
        func loadSettingValue(for settingType: SettingsType) -> String {
            UserDefaults.standard.string(forKey: settingType.rawValue) ?? "0"
        }
        
        func saveSharedData()  {
            let todayStat = selectedStatistic

            // Populate with new data
            // Today stat
            var sharedData = SharedData.defaultInstance()
            sharedData.todayWeight = Double(todayStat.weight) ?? 0
            sharedData.todaySteps = Double(todayStat.steps) ?? 0
            sharedData.todayCalories = Double(todayStat.calories) ?? 0
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
            case .custom: return
            }
            
            averageStatistic = computeAverageStatistic(data: filteredData)
        }
        
        func computeAverageStatistic(data: [StatisticDataObject]) -> StatisticData {
            // Compute averages for each type separately
            let totalWeight = data.reduce(0.0) { $0 + ($1.weight > 0 ? $1.weight : 0) }
            let totalSteps = data.reduce(0) { $0 + ($1.steps > 0 ? $1.steps : 0) }
            let totalCalories = data.reduce(0) { $0 + ($1.calories > 0 ? $1.calories : 0) }
            
            let nonZeroWeightCount = data.filter { $0.weight > 0 }.count
            let nonZeroStepsCount = data.filter { $0.steps > 0 }.count
            let nonZeroCaloriesCount = data.filter { $0.calories > 0 }.count
            
            var averageWeight = nonZeroWeightCount > 0 ? totalWeight / Double(nonZeroWeightCount) : 0
            averageWeight = (averageWeight * 100).rounded() / 100  // Format to 2 decimal places
            
            let averageSteps = nonZeroStepsCount > 0 ? Int(totalSteps) / nonZeroStepsCount : 0
            let averageCalories = nonZeroCaloriesCount > 0 ? Int(totalCalories) / nonZeroCaloriesCount : 0
            return StatisticData(weight: String(averageWeight), steps: String(averageSteps), calories: String(averageCalories))
        }
    
        func getStatisticDataFiltered() {
            let allData = Array(dataService.getAllStatistic())
            
            switch selectedFilter {
            case .thisWeek:
                statisticDataFiltered =  allData.filter { $0.date.isInThisWeek }
            case .previousWeek:
                statisticDataFiltered = allData.filter { $0.date.isInPreviousWeek }
            case .thisMonth:
                statisticDataFiltered = allData.filter { $0.date.isInThisMonth }
            case .lastMonth:
                statisticDataFiltered = allData.filter { $0.date.isInLastMonth }
            case .custom: break
            }
        }
        
        func customFilterSelected() {
            let allData = Array(dataService.getAllStatistic())
            let data = allData.filter { $0.date.isBetween(selectedStartDate, and: selectedEndDate)}
            if  data.count > 0 {
                statisticDataFiltered = data
                averageStatistic = computeAverageStatistic(data: data)
            }
        }
    }
}
