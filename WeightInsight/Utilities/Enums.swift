//
//  Enums.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-25.
//
 

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
    
    var placeholder: String {
        switch self {
        case .weight:
            return "Enter weight"
        case .steps:
            return "Enter steps"
        case .calories:
            return "Enter calories"
        }
    }
    
    var image: String {
        switch self {
        case .weight:
            return "scalemass"
        case .steps:
            return "figure.walk"
        case .calories:
            return "flame"
        }
    }
    
    func data(entry: StatisticData) -> String {
        switch self {
        case .weight:
            return entry.weight
        case .steps:
            return entry.steps
        case .calories:
            return entry.calories
        }
    }
}

enum StatisticFilter: String, CaseIterable {
    case thisWeek
    case previousWeek
    case thisMonth
    case lastMonth
    case custom
    
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
        case .custom:
            return "Custom"
        }
    }
}

enum SettingsType: String, CaseIterable{
    case weight
    case steps
    case calories
    case myFitnessPal
    case fatSecret
    case units
}


enum Units: String, CaseIterable{
    case metric = "kg"
    case imperial = "pound"
}
