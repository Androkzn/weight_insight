//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI


@main
struct WeightInsightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .environmentObject(MainView.ViewModel())
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
            StatisticsView()
                .environmentObject(StatisticsView.ViewModel())
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            SettingsView()
                .environmentObject(SettingsView.ViewModel())
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

