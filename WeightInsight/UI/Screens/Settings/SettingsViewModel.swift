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
        @Published var dataStore: DataStore
        
        init(dataStore: DataStore) {
            self.dataStore = dataStore
        }
        
        func saveSettingValue(_ value: String, for settingType: SettingsType) {
            UserDefaults.standard.setValue(value, forKey: settingType.rawValue)
            
            switch settingType {
            case .weight: self.dataStore.goals.weightGoal = value
            case .steps: self.dataStore.goals.stepsGoal = value
            case .calories: self.dataStore.goals.caloriesGoal = value
            default: break
            }
        }

        func connectMyFitnessPal() {
            
        }
    }
}

enum SettingsType: String, CaseIterable{
    case weight
    case steps
    case calories
    case myFitnessPal
}

struct Goals {
    var weightGoal: String
    var stepsGoal: String
    var caloriesGoal: String
}
