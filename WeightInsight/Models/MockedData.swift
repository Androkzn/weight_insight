//
//  MockedModel.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 27.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Foundation

#if DEBUG

extension StatisticDataObject {

    func createMockedDataStatistic() {
        let startDate =  Date.date(from: "2023-01-01")
        let endDate =  Date()
        var currentDate = startDate
        
        while currentDate <= endDate {
            let newData = StatisticDataObject()
            newData.id = currentDate.formattedString()
            newData.weight = Double.random(in: 75...85)  // Random weight between 79 and 85
            newData.steps = Int.random(in: 5000...20000) // Random steps between 5000 and 15000
            newData.calories = Int(Double.random(in: 1200...2500))  // Random calories between 1200 and 2000
            newData.date = currentDate
            
            // Add only once per installation
            guard  RealmService.shared.getObjectById(newData.id, StatisticDataObject.self) == nil else {
                return
            }
            
            RealmService.shared.saveObject(entity: newData)
            
            // Move to the next day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
}

extension SharedData {
    static var mockedData: SharedData = {
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
