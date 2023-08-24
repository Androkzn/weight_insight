//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel = MainView.ViewModel()
    @StateObject private var settingsViewModel = SettingsView.ViewModel()
    @StateObject private var statisticsViewModel = StatisticsView.ViewModel()

    var body: some View {
        TabView {
            MainView()
                .environmentObject(mainViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(statisticsViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
      
            StatisticsView()
                .environmentObject(statisticsViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            SettingsView()
                .environmentObject(settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }.accentColor(.blue.opacity(0.6))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
