//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI

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
        }.accentColor(.blue.opacity(0.6))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
