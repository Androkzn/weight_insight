//
//  DataStore.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import SwiftUI

class DataStore: ObservableObject {
    @Published var statisticDataGrouped: [String: [StatisticDataObject]] = [:]
    @Published var statisticDataFiltered: [StatisticDataObject] = []
    @Published var selectedFilter: StatisticFilter = .thisWeek
    @Published var goals: Goals = Goals(weightGoal: "", stepsGoal: "", caloriesGoal: "")
    @Published var averageStatistic: StatisticData = StatisticData(weight: "0", steps: "0", calories: "0")
    
    init() {
        // Listen for the notification
        RealmService.shared.realmUpdated = { [weak self] in
            self?.update()
        }
        // Initial data fetch and population
        update()
    }

    func update() {
        averageStatistic = getAverageStatistic()
        statisticDataGrouped = RealmService.shared.getStatisticGrouped()
        statisticDataFiltered = RealmService.shared.getStatistic(filter: selectedFilter)
        goals = getGoals()
    }
    
    
    func getGoals() -> Goals {
        var goals: Goals = self.goals
        goals.weightGoal = UserDefaults.standard.string(forKey: SettingsType.weight.rawValue) ?? ""
        goals.stepsGoal = UserDefaults.standard.string(forKey: SettingsType.steps.rawValue) ?? ""
        goals.caloriesGoal = UserDefaults.standard.string(forKey: SettingsType.calories.rawValue) ?? ""
        return goals
    }
    
    func getAverageStatistic() -> StatisticData {
        let allData = RealmService.shared.getAllStatistic()
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
        
        return StatisticData(weight: String(averageWeight), steps: String(averageSteps), calories: String(averageCalories))
    }
    
    func updateStatisticForFilter() {
        averageStatistic = getAverageStatistic()
        statisticDataFiltered = RealmService.shared.getStatistic(filter: selectedFilter)
    }
}
