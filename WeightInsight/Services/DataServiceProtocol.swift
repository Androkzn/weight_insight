//
//  DataServiceProtocol.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    func getStatisticForDate(date: Date) -> StatisticDataObject?
    func getAllStatistic() -> [StatisticDataObject]
    func saveStatistic(type: Statistic, value: Double, date: Date)
    func saveStatisticData(data: StatisticData) -> AnyPublisher<Void, Never>
    func saveNewStatisticData(data: StatisticData) -> StatisticDataObject
    func clearStatisticData(id: String) -> AnyPublisher<Void, Never>
    func createMockedDataStatistic()
}
