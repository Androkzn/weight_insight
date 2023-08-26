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
        WindowGroup {
            SplashScreenView()
                .environmentObject(dependencyFactory.createMainViewModel())
                .environmentObject(dependencyFactory.createStatisticViewModel())
                .environmentObject(dependencyFactory.createSettingsViewModel())
        }
    }
}
