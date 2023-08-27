//
//  StatisticData.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-25.
//

import Foundation

struct StatisticData  {
    var weight: String = ""
    var steps: String = ""
    var calories: String = ""
    var date: Date? = nil
    
    static func defaultInstance() -> StatisticData {
        return StatisticData (weight: "0", steps: "0", calories: "0")
    }
    
    static func fromObject(_ object: StatisticDataObject) -> StatisticData {
        return  StatisticData (
            weight: String(object.weight.decimalFormatter),
            steps: String(object.steps.intFormatter),
            calories: String(object.calories.intFormatter),
            date: object.date
        )
    }
    
    mutating func sanitizeData() {
        weight = weight.withoutThousandsSeparator
        steps = steps.withoutThousandsSeparator
        calories = calories.withoutThousandsSeparator
    }
}
