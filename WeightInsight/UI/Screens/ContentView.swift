//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var mainViewModel: MainView.ViewModel
    @EnvironmentObject private var statisticViewModel: StatisticsView.ViewModel
    @EnvironmentObject private var settingsViewModel: SettingsView.ViewModel

    var body: some View {
        TabView {
            MainView()
                .environmentObject(mainViewModel)
                .environmentObject(statisticViewModel)
                .environmentObject(settingsViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
      
            StatisticsView()
                .environmentObject(statisticViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            SettingsView()
                .environmentObject(settingsViewModel)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(.blue.opacity(0.6))
        .preferredColorScheme(.light)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
