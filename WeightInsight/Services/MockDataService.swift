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
    
    var mockStatisticData: [StatisticDataObject] = []
    
    func getAllStatistic() -> [StatisticDataObject] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let thisWeek = generateData(for: calendar.dateInterval(of: .weekOfYear, for: currentDate)!)
        let lastWeek = generateData(for: calendar.dateInterval(of: .weekOfYear, for: currentDate.addingTimeInterval(-7 * 24 * 60 * 60))!)
        let thisMonth = generateData(for: calendar.dateInterval(of: .month, for: currentDate)!)
        let lastMonth = generateData(for: calendar.dateInterval(of: .month, for: currentDate.addingTimeInterval(-30 * 24 * 60 * 60))!)
        
        return thisWeek + lastWeek + thisMonth + lastMonth
    }
    
    func generateData(for dateInterval: DateInterval) -> [StatisticDataObject] {
        let startDate = dateInterval.start
        var currentDate = startDate
        var data: [StatisticDataObject] = []
        
        let weights: [Double] = [75.0, 80.0, 85.0]
        let steps: [Double] = [10000.0, 15000.0, 20000.0]
        let calories: [Double] = [1500.0, 2000.0, 2500.0]
        
        var weightIndex = 0
        var stepsIndex = 0
        var caloriesIndex = 0
        
        while currentDate <= dateInterval.end {
            let id = UUID().uuidString
            let weight = weights[weightIndex % weights.count]
            let stepsValue = steps[stepsIndex % steps.count]
            let caloriesValue = calories[caloriesIndex % calories.count]
            
            let statisticData = StatisticDataObject(id: id, weight: weight, steps: stepsValue, calories: caloriesValue, date: currentDate)
            data.append(statisticData)
            
            weightIndex += 1
            stepsIndex += 1
            caloriesIndex += 1
            
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return data
    }
    
    func getStatisticForDate(date: Date) -> StatisticDataObject? {
           let currentDate = Calendar.current.startOfDay(for: date)
           let data = generateData(for: DateInterval(start: currentDate, end: currentDate))
           return data.first
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
