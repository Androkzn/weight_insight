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
        
        func saveSettingValue(_ value: String, for settingType: SettingsType) {
            UserDefaults.standard.setValue(value, forKey: settingType.rawValue)
        }

        func loadSettingValue(for settingType: SettingsType) -> String {
            UserDefaults.standard.string(forKey: settingType.rawValue) ?? ""
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

