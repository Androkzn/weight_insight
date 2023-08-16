//
//  StatisticViewModel.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

extension StatisticsView {
    class ViewModel: ObservableObject {
        @Published var statisticData: [StatisticDataObject]
        
        init() {
            statisticData = RealmService.shared.getAllStatistic()
        }
        
        func editStatisticData(data: StatisticData) {
            RealmService.shared.saveStatisticData(data: data)
        }
        
        func groupedByMonth() -> [String: [StatisticDataObject]] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            
            
            return Dictionary(grouping: statisticData, by: { entry in
                return dateFormatter.string(from: entry.date)
            })
        }
    }
}
