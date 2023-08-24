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
        @Published var dataStore: DataStore
        
        init(dataStore: DataStore) {
            self.dataStore = dataStore
        }
        
        func editStatisticData(data: StatisticData) {
            RealmService.shared.saveStatisticData(data: data)
        }
        
        func clearStatisticData(id: String) {
            RealmService.shared.clearStatisticData(id: id)
        }
        
        func sortedKeys() -> [String] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            
            let calendar = Calendar.current
            let currentDate = Date()
            let currentYear = calendar.component(.year, from: currentDate)
            let currentMonth = calendar.component(.month, from: currentDate)
            
            let groupedKeys = Array(dataStore.statisticDataGrouped.keys)
            
            return groupedKeys.sorted { key1, key2 in
                guard let date1 = dateFormatter.date(from: key1),
                      let date2 = dateFormatter.date(from: key2) else { return false }
                
                let year1 = calendar.component(.year, from: date1)
                let year2 = calendar.component(.year, from: date2)
                let month1 = calendar.component(.month, from: date1)
                let month2 = calendar.component(.month, from: date2)
                
                // If one of the months is the current month, it should come first
                if month1 == currentMonth && year1 == currentYear {
                    return true
                } else if month2 == currentMonth && year2 == currentYear {
                    return false
                }
                
                // If both dates are from the current year
                if year1 == currentYear && year2 == currentYear {
                    return month1 > month2
                }
                
                // If only the first date is from the current year
                if year1 == currentYear {
                    return true
                }
                
                // If only the second date is from the current year
                if year2 == currentYear {
                    return false
                }
                
                // If neither date is from the current year, sort by year first and then by month
                if year1 != year2 {
                    return year1 > year2
                }
                
                return month1 > month2
            }
        }
    }
}
