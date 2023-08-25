//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mainViewModel: MainView.ViewModel
    @StateObject private var statisticViewModel: StatisticsView.ViewModel
    @StateObject private var settingsViewModel = SettingsView.ViewModel()

    init() {
        let realmService = RealmService()
        _mainViewModel = StateObject(wrappedValue: MainView.ViewModel(dataService: realmService))
        _statisticViewModel = StateObject(wrappedValue: StatisticsView.ViewModel(dataService: realmService))
       
        #if DEBUG
            realmService.createMockedDataStatistic()
        #endif
    }
    
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
                .environmentObject(mainViewModel)
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
