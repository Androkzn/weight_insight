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
        @Published var weightGoal: String  = ""
        @Published var stepsGoal: String = ""
        @Published var caloriesGoal: String = ""
        
        init() {
            weightGoal =  loadSettingValue(for: .weight)
            stepsGoal =  loadSettingValue(for: .steps)
            caloriesGoal =  loadSettingValue(for: .calories)
        }
        
        func saveSettingValue(_ value: String, for settingType: SettingsType) {
            UserDefaults.standard.setValue(value, forKey: settingType.rawValue)
            
            switch settingType {
            case .weight: self.weightGoal = value
            case .steps: self.stepsGoal = value
            case .calories: self.caloriesGoal = value
            default: break
            }
        }

        func loadSettingValue(for settingType: SettingsType, hideZeroValue: Bool = false ) -> String {
            guard let value = UserDefaults.standard.string(forKey: settingType.rawValue) else {
                return hideZeroValue ? "" : "0"
            }
            
            if value.isEmpty && hideZeroValue {
                return ""
            }
           
            return value.isEmpty ? "0" : value
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

