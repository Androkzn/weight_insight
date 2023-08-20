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
    @objc dynamic var steps: Int = 0
    @objc dynamic var calories: Int = 0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}