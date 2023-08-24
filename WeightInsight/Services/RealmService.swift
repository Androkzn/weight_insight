//
//  RealmService.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation
import RealmSwift
import Realm
import Combine

class RealmService {
    static let shared = RealmService()
    //let databaseQueue = DispatchQueue(label: "database.serial", qos: .background)
    let databaseQueue = DispatchQueue.main
    var onRealmConfigured: (() -> Void)?
    var realmUpdated: (() -> Void)?
    
    // Мain realm object
    private static var realm: Realm {
        get {
            // Checks if realm has been initialized
            // if it hasn't initialize it.
            if _realm == nil {
                self.setupDatabase()
                return _realm!
            }
            return _realm!
        }
        set {
            _realm = newValue
        }
    }
    
    private static var _realm: Realm? {
        didSet {
            // Ensures that realm is set
            let callBack = RealmService.shared.onRealmConfigured
            RealmService.shared.onRealmConfigured = nil
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                callBack?()
            }
        }
    }
    
    class func setupDatabase() {
        dispatchPrecondition(condition: .onQueue(shared.databaseQueue))
        
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                switch oldSchemaVersion {
                case 1: break
                default: break
                }
            }
        )
        do {
            // If companyId not provided, we use default realm file
            config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weight_insight")?.appendingPathComponent("default.realm")
            
            // Tell Realm to use this new configuration object for the default Realm
            Realm.Configuration.defaultConfiguration = config
            
            // create default realm reference
            try RealmService.configure(configuration: config)
            
            // Settings additional attributes for DB File to avoid crashes in background
            if let realmPath: NSString = config.fileURL?.path as NSString?,
               let pathOne = realmPath.appendingPathExtension("lock"),
               let pathTwo = realmPath.appendingPathExtension("log"),
               let pathThree = realmPath.appendingPathExtension("log_a"),
               let pathFour = realmPath.appendingPathExtension("log_b") {
                let allRealmRelatedFiles = [String(realmPath),
                                            pathOne,
                                            pathTwo,
                                            pathThree,
                                            pathFour]
                try allRealmRelatedFiles.forEach { path in
                    if FileManager.default.fileExists(atPath: path) {
                        try FileManager.default.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: path)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    class func configure(configuration: Realm.Configuration) throws {
        let realmConfigured = try Realm(configuration: configuration, queue:  RealmService.shared.databaseQueue)
        realm = realmConfigured
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    class func isDBAvailable() -> Bool {
        return _realm != nil
    }
    
    // Get entities
    func getObjects<Element: Object>(_ type: Element.Type, filter: NSPredicate? = nil) async -> Results<Element>? {
        let objects = (filter == nil) ? RealmService.realm.objects(type) : RealmService.realm.objects(type).filter(filter ?? NSPredicate(format: ""))
        return objects
    }
    
    // Get entity by ID
    func getObjectById<Element: Object>(_ id: String, _ type: Element.Type) -> Element? {
        return RealmService.realm.object(ofType: type, forPrimaryKey: id)
    }
    
   // Save entity
   func saveObject(entity: Object) {
       RealmService.write {
           RealmService.realm.add(entity, update: .modified)
        }
    }
    // Save entities
    func saveObjects(entities: [Object]) {
        RealmService.write {
            RealmService.realm.add(entities, update: .modified)
        }
    }
    
    // realm write function that catches global errors to prevent an app crashing
    public static func write(writeClosure: @escaping () -> Void) {
        return RealmService.shared.databaseQueue.async {
            do {
                try realm.safeWrite {
                    writeClosure()
                }
                RealmService.shared.realmUpdated?()
            } catch {
                 
            }
        }
    }
    
    // Specific methods for Statistic
    func getAllStatistic() -> [StatisticDataObject] {
        return Array(RealmService.realm.objects(StatisticDataObject.self).sorted(by: { $0.date > $1.date}))
    }
    
    func getStatisticForDate(date: Date) -> StatisticDataObject? {
        let currentDate = date.formattedString()
        let realm = RealmService.realm
        let result = realm.objects(StatisticDataObject.self).filter("id = %@", currentDate).first
       return result
    }
    
    func saveStatistic(type: Statistic, value: Double, date: Date = Date()) {
        
        if let existingData = RealmService.shared.getStatisticForDate(date:date) {
            RealmService.write {
                switch type {
                case .weight: existingData.weight = value
                case .steps: existingData.steps = value
                case .calories: existingData.calories = value
                }
            }
        } else {
            let newData = StatisticDataObject()
            newData.id = date.formattedString()
            switch type {
            case .weight: newData.weight = value
            case .steps: newData.steps = value
            case .calories: newData.calories = value
            }
            RealmService.write {
                RealmService.realm.add(newData)
            }
        }
    }
    
    func saveStatisticData(data: StatisticData) {
        guard let date = data.date else { return }
        
        let id = date.formattedString()
        if let existingData = RealmService.shared.getObjectById(id, StatisticDataObject.self) {
            RealmService.write {
                existingData.weight = Double(data.weight) ?? 0
                existingData.steps = Double(data.steps.replacingOccurrences(of: ",", with: "")) ?? 0
                existingData.calories = Double(data.calories.replacingOccurrences(of: ",", with: "")) ?? 0
            }
        } else {
            let newData = StatisticDataObject()
            newData.id = id
            newData.weight = Double(data.weight) ?? 0
            newData.steps = Double(data.steps.replacingOccurrences(of: ",", with: "")) ?? 0
            newData.calories = Double(data.calories.replacingOccurrences(of: ",", with: "")) ?? 0
            
            RealmService.write {
                RealmService.realm.add(newData)
            }
        }
    }
    
    func clearStatisticData(id: String) {
        if let updatedData = RealmService.shared.getObjectById(id, StatisticDataObject.self) {
            RealmService.write {
                updatedData.calories = 0
                updatedData.steps = 0
                updatedData.weight = 0
            }
        }
    }
    
    func getStatistic(filter: StatisticFilter) -> [StatisticDataObject] {
        let allData = Array(RealmService.realm.objects(StatisticDataObject.self))
        
        switch filter {
        case .thisWeek:
            return allData.filter { $0.date.isInThisWeek }
        case .previousWeek:
            return allData.filter { $0.date.isInPreviousWeek }
        case .thisMonth:
            return allData.filter { $0.date.isInThisMonth }
        case .lastMonth:
            return  allData.filter { $0.date.isInLastMonth }
        case .all:
            return allData
        }
    }
    
    func getStatisticGrouped() -> [String: [StatisticDataObject]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        
        return Dictionary(grouping: RealmService.shared.getAllStatistic(), by: { entry in
            return dateFormatter.string(from: entry.date)
        })
    }
}
