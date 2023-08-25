//
//  DataServiceProtocol.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import Foundation

protocol DataService {
    func getStatisticForDate(date: Date) -> StatisticDataObject?
    func getAllStatistic() -> [StatisticDataObject]
    func saveStatistic(type: Statistic, value: Double, date: Date)
    func saveStatisticData(data: StatisticData)
    func clearStatisticData(id: String)
}
