//
//  MockDataService.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//
import Foundation
import Combine
 
class MockDataService: DataServiceProtocol {
    private let dataSubject = PassthroughSubject<Void, Never>()
    
    var mockStatisticData: [StatisticDataObject]
    
    init() {
        self.mockStatisticData = []
        self.mockStatisticData = createStatistic()
    }
    
    func createStatistic() -> [StatisticDataObject] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let thisWeekWeight = 70.0
        let thisWeekSteps = 5000.0
        let thisWeekCalories = 1000.0
        let thisWeekData = generateData(for: calendar.dateInterval(of: .weekOfYear, for: currentDate)!, weight: thisWeekWeight, steps: thisWeekSteps, calories: thisWeekCalories)
        
        let previousWeekWeight = 80.0
        let previousWeekSteps = 15000.0
        let previousWeekCalories = 2000.0
        let previousWeekData = generateData(for: calendar.dateInterval(of: .weekOfYear, for: currentDate.addingTimeInterval(-7 * 24 * 60 * 60))!, weight: previousWeekWeight, steps: previousWeekSteps, calories: previousWeekCalories)
        
        let allData = thisWeekData + previousWeekData
        return allData
    }
    
    func getAllStatistic() -> [StatisticDataObject] {
         return mockStatisticData
    }

    func generateData(for dateInterval: DateInterval, weight: Double, steps: Double, calories: Double) -> [StatisticDataObject] {
        let startDate = dateInterval.start
        var currentDate = startDate
        var data: [StatisticDataObject] = []
        
        while currentDate < dateInterval.end {
            let id = currentDate.formattedString()
            let statisticData = StatisticDataObject(id: id, weight: weight, steps: steps, calories: calories, date: currentDate)
            data.append(statisticData)
            
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return data
    }
    
    
    func getStatisticForDate(date: Date) -> StatisticDataObject? {
        let result = mockStatisticData.filter {$0.id ==  date.formattedString()}
            
        return result.first
    }
    
    func saveStatistic(type: Statistic, value: Double, date: Date)  -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            let id = UUID().uuidString
            let statisticData = StatisticDataObject(id: id, weight: 0, steps: 0, calories: 0, date: date)
            
            switch type {
            case .weight: statisticData.weight = value
            case .steps: statisticData.steps = value
            case .calories: statisticData.calories = value
            }
            
            self?.mockStatisticData.append(statisticData)
            promise(.success(()))
        }.eraseToAnyPublisher()
    }

    func saveStatisticData(data: StatisticData) {
        guard let date = data.date else { return }
        let id = UUID().uuidString
        let statisticData = StatisticDataObject(id: id, weight: Double(data.weight) ?? 0, steps: Double(data.steps.replacingOccurrences(of: ",", with: "")) ?? 0, calories: Double(data.calories.replacingOccurrences(of: ",", with: "")) ?? 0, date: date)
        
        mockStatisticData.append(statisticData)
    }
    
    func saveStatisticData(data: StatisticData) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            guard let date = data.date else { return }
            let id = UUID().uuidString
            let statisticData = StatisticDataObject(id: id, weight: Double(data.weight) ?? 0, steps: Double(data.steps.replacingOccurrences(of: ",", with: "")) ?? 0, calories: Double(data.calories.replacingOccurrences(of: ",", with: "")) ?? 0, date: date)
            
            self?.mockStatisticData.append(statisticData)
            promise(.success(()))
        }.eraseToAnyPublisher()
    }
    
    

    func clearStatisticData(id: String) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            self?.mockStatisticData.removeAll { $0.id == id }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    func createMockedDataStatistic() {
        
    }
    
    func saveNewStatisticData(data: StatisticData) -> StatisticDataObject {
        return StatisticDataObject()
    }
}
