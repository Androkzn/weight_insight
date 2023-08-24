//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataStore = DataStore()

    var body: some View {
        TabView {
            MainView()
                .environmentObject(MainView.ViewModel(dataStore: dataStore))
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
      
            StatisticsView()
                .environmentObject(StatisticsView.ViewModel(dataStore: dataStore))
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            SettingsView()
                .environmentObject(SettingsView.ViewModel(dataStore: dataStore))
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }.onAppear {
            // Fetch and populate data
            dataStore.update()
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
