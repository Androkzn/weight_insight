//
//  ViewModel.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation
import RealmSwift

class ViewModel: ObservableObject {
    @Published var statisticData: [StatisticData]
    
    init() {
        let realm = try! Realm()
        statisticData = Array(realm.objects(StatisticData.self))
    }
    
    // Other methods for saving, updating, and fetching data from Realm
}
