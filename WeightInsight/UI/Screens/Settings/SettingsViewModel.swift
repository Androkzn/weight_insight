//
//  SettingsViewModel.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
 
extension SettingsView {
    class ViewModel: ObservableObject {
         
        
        @Published var goals: Goals = Goals(weightGoal: "", stepsGoal: "", caloriesGoal: "")
        @Published var myFitnessPal: String = ""
        @Published var showWebView: Bool = false
        @Published var authorizationCode: String? = nil
        @Published var units: Units = .metric
        
        init() {
            getGoals()
        }
    
        func saveSettingValue(_ value: String, for settingType: SettingsType) {
            UserDefaults.standard.setValue(value, forKey: settingType.rawValue)
            
            switch settingType {
            case .weight: goals.weightGoal = value
            case .steps: goals.stepsGoal = value
            case .calories: goals.caloriesGoal = value
            default: break
            }
        }
        
        func getGoals()  {
            var goalsUpdated: Goals = goals
            goalsUpdated.weightGoal = UserDefaults.standard.string(forKey: SettingsType.weight.rawValue) ?? ""
            goalsUpdated.stepsGoal = UserDefaults.standard.string(forKey: SettingsType.steps.rawValue) ?? ""
            goalsUpdated.caloriesGoal = UserDefaults.standard.string(forKey: SettingsType.calories.rawValue) ?? ""
            goals =  goalsUpdated
        }

        func connectMyFitnessPal() {
            
        }
    }
}
