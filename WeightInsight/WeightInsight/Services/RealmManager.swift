//
//  RealmManager.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation

import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    private init() {
        // Create a Realm configuration
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("myrealm.realm")
        Realm.Configuration.defaultConfiguration = config

        // Get the shared Realm instance
        self.realm = try! Realm()
    }

    let realm: Realm
}
