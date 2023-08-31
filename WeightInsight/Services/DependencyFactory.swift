//
//  DependencyFactory.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-25.
//

import Foundation
import Combine

class DependencyFactory: Factory {
    private(set) var dataService: DataServiceProtocol

    init() {
        dataService = RealmService()
        #if DEBUG
            dataService.createMockedDataStatistic()
        #endif
    }

    func createMainViewModel() -> MainView.ViewModel {
        return MainView.ViewModel(
            dataService: dataService
        )
    }

    func createStatisticViewModel(mainViewModel: MainView.ViewModel) -> StatisticsView.ViewModel {
        return StatisticsView.ViewModel(
            dataService: dataService,
            mainViewModel: mainViewModel
        )
    }

    func createSettingsViewModel() -> SettingsView.ViewModel {
        return SettingsView.ViewModel()
    }
}

