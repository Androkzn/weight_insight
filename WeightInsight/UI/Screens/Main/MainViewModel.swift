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
        @Published var dataStore: DataStore
        @Published var selectedDate: Date = Date()
        
        init(dataStore: DataStore) {
            self.dataStore = dataStore
        }
        
        var averageStatistic: StatisticData {
            return dataStore.averageStatistic
        }
        
        var goals: Goals {
            return dataStore.goals
        }
        
        var selectedFilter: StatisticFilter {
            return dataStore.selectedFilter
        }
        
        var getStatisticForDate: StatisticDataObject {
            if let statisticObject  = RealmService.shared.getStatisticForDate(date: selectedDate) {
                return statisticObject
            }
            return StatisticDataObject()
        }
        
        func saveStatisticData(statistic: Statistic, value: Double, date: Date = Date()) {
            RealmService.shared.saveStatistic(type: statistic, value: value, date: date)
        }
        
        func loadSettingValue(for settingType: SettingsType) -> String {
            UserDefaults.standard.string(forKey: settingType.rawValue) ?? "0"
        }
        
        func getStatisticObjects(filter: StatisticFilter) -> [StatisticDataObject] {
            return RealmService.shared.getStatistic(filter: filter)
        }
        
        func saveSharedData()  {
            let todayStat = getStatisticForDate

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
            sharedData.selectedPeriod = dataStore.selectedFilter.title
            
            // Save data
            sharedData.save()
            
            // Refresh widget
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct StatisticData  {
    var weight: String = ""
    var steps: String = ""
    var calories: String = ""
    var date: Date? = nil
}

enum Statistic: String, CaseIterable{
    case weight
    case steps
    case calories
    
    var title: String {
        switch self {
        case .weight:
            return "Weight"
        case .steps:
            return "Steps"
        case .calories:
            return "Calories"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .weight:
            return "Add weight"
        case .steps:
            return "Add steps"
        case .calories:
            return "Import calories"
        }
    }
}

enum StatisticFilter: String, CaseIterable {
    case thisWeek
    case previousWeek
    case thisMonth
    case lastMonth
    case all
    
    var title: String {
        switch self {
        case .thisWeek:
            return "This Week"
        case .previousWeek:
            return "Previous Week"
        case .thisMonth:
            return "This Month"
        case .lastMonth:
            return "Previous Month"
        case .all:
            return "All available"
        }
    }
}
