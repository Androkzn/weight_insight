//
//  WeightInsightApp.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-15.
//

import SwiftUI
import Combine

@main
struct WeightInsightApp: App {
    let dependencyFactory = DependencyFactory()

    var body: some Scene {
        let mainViewModel = dependencyFactory.createMainViewModel()
        let statisticViewModel = dependencyFactory.createStatisticViewModel(mainViewModel: mainViewModel)
        let settingsViewModel = dependencyFactory.createSettingsViewModel()
        
        WindowGroup {
            SplashScreenView()
                .environmentObject(mainViewModel)
                .environmentObject(statisticViewModel)
                .environmentObject(settingsViewModel)
        }
    }
}
