//
//  SharedStatisticData.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-20.
//

import Foundation

struct SharedData: Codable {
    var todayWeight: Double
    var todaySteps: Double
    var todayCalories: Double
    var avgWeight: Double
    var avgSteps: Double
    var avgCalories: Double
    var targetWeight: Double
    var targetSteps: Double
    var targetCalories: Double
    var selectedPeriod: String
}


extension SharedData {
    static func defaultInstance() -> SharedData {
        // Return a default instance of SharedData
        return SharedData(todayWeight: 0.0,
                          todaySteps: 0.0,
                          todayCalories: 0.0,
                          avgWeight: 0.0,
                          avgSteps: 0.0,
                          avgCalories: 0.0,
                          targetWeight: 0.0,
                          targetSteps: 0.0,
                          targetCalories: 0.0,
                          selectedPeriod: "N/A")
    }
 
    func save()  {
        guard let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weight_insight")?.appendingPathComponent("data.json") else { return }

        do {
            let data = try JSONEncoder().encode(self)
            try data.write(to: sharedContainerURL)
        } catch {
            print("Error saving shared data: \(error)")
        }
    }
    
    static func get() -> SharedData {
        guard let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weight_insight")?.appendingPathComponent("data.json") else { return SharedData.defaultInstance() }
        
        if let data = try? Data(contentsOf: sharedContainerURL) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(SharedData.self, from: data) {
                return decodedData
            }
        }
        return SharedData.defaultInstance()
    }
    
}

#if DEBUG
extension SharedData {
    static var mockedWidgetData: SharedData = {
        return SharedData(todayWeight: 80.0,
                          todaySteps: 12500.0,
                          todayCalories: 1950.0,
                          avgWeight: 81.55,
                          avgSteps: 10520.0,
                          avgCalories: 1745.0,
                          targetWeight: 79.0,
                          targetSteps: 10000.0,
                          targetCalories: 1850.0,
                          selectedPeriod: "thisWeek")
    }()
}

#endif
