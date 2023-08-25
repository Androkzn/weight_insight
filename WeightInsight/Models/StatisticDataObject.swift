//
//  StatisticData.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation
import RealmSwift

class StatisticDataObject: Object, Identifiable {
    @objc dynamic var id = Date().formattedString(format: "yyyy-MM-dd")
    @objc dynamic var weight: Double = 0
    @objc dynamic var steps: Double = 0
    @objc dynamic var calories: Double = 0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, weight: Double, steps: Double, calories: Double, date: Date) {
        self.init()
        self.id = id
        self.weight = weight
        self.steps = steps
        self.calories = calories
        self.date = date
    }
}
