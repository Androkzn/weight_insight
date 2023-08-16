//
//  MainViewModel.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import UIKit


extension MainView {
    class ViewModel: ObservableObject {
        func getStatisticFor(filter: StatisticFilter) -> StatisticData {
            return RealmService.shared.getAverageStatistic(filter: filter)
        }
        
        func getStatisticForDate(date: Date) -> StatisticData {
            if let statisticObject  = RealmService.shared.getStatisticForDate(date: date) {
                let statisticData = StatisticData(
                    weight: String(statisticObject.weight),
                    steps: String(statisticObject.steps),
                    calories: String(statisticObject.calories)
                    )
                return statisticData
            }
            
            return StatisticData(weight: "0",steps: "0",calories: "0")
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
