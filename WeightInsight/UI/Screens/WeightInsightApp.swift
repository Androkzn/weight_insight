//
//  WeightInsightApp.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-15.
//

import SwiftUI


@main
struct WeightInsightApp: App {
    init() {
    #if DEBUG
        StatisticDataObject().createMockedDataStatistic()
    #endif
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
