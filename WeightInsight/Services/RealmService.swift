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

class RealmService: DataServiceProtocol {
    private let dataSubject = PassthroughSubject<Void, Never>()
    private let databaseQueue = DispatchQueue.main
    private var realm: Realm?
    var onRealmConfigured: (() -> Void)?
    var realmUpdated: (() -> Void)?

    init() {
       setupDatabase()
    }
    
    private func setupDatabase() {
        dispatchPrecondition(condition: .onQueue(databaseQueue))
            
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
            try configure(configuration: config)
            
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
    
    private func configure(configuration: Realm.Configuration) throws {
          let realmConfigured = try Realm(configuration: configuration, queue: databaseQueue)
          realm = realmConfigured
          print(Realm.Configuration.defaultConfiguration.fileURL!)
      }
 
    // Get entities
    func getObjects<Element: Object>(_ type: Element.Type, filter: NSPredicate? = nil) async -> Results<Element>? {
         if let realm = realm {
             let objects = (filter == nil) ? realm.objects(type) : realm.objects(type).filter(filter ?? NSPredicate(format: ""))
             return objects
         }
         return nil
     }
    
    // Get entity by ID
    func getObjectById<Element: Object>(_ id: String, _ type: Element.Type) -> Element? {
        if let realm = realm {
            return realm.object(ofType: type, forPrimaryKey: id)
        }
        return nil
    }
    
    // Save entity
    func saveObject(entity: Object) {
        write {
            self.realm?.add(entity, update: .modified)
        }
    }
    
    // Save entities
    func saveObjects(entities: [Object]) {
        write {
            self.realm?.add(entities, update: .modified)
        }
    }
    
    // realm write function that catches global errors to prevent an app crashing
    private func write(writeClosure: @escaping () -> Void) {
        guard let realm = realm else {
            return
        }
        databaseQueue.async {
            do {
                try realm.safeWrite {
                    writeClosure()
                }
                self.realmUpdated?()
            } catch {
                // Handle error...
            }
        }
    }
    
    // Specific methods for Statistic
    func getAllStatistic() -> [StatisticDataObject] {
        guard let realm = realm else {
            return []
        }
        
        return Array(realm.objects(StatisticDataObject.self).sorted(byKeyPath: "date", ascending: false))
    }
    
    func getStatisticForDate(date: Date) -> StatisticDataObject? {
        let currentDate = date.formattedString()
        let result = realm?.objects(StatisticDataObject.self).filter("id = %@", currentDate).first
       return result
    }
    
    func saveStatistic(type: Statistic, value: Double, date: Date = Date()) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            if let existingData = self?.getStatisticForDate(date:date) {
                self?.write {
                    switch type {
                    case .weight: existingData.weight = value
                    case .steps: existingData.steps = value
                    case .calories: existingData.calories = value
                    }
                    promise(.success(()))
                }
            } else {
                let newData = StatisticDataObject()
                newData.id = date.formattedString()
                switch type {
                case .weight: newData.weight = value
                case .steps: newData.steps = value
                case .calories: newData.calories = value
                }
                self?.write {
                    self?.realm?.add(newData)
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func saveStatisticData(data: StatisticData) -> AnyPublisher<Void, Never> {
            return Future<Void, Never> { [weak self] promise in
                guard let date = data.date else { return }
                let id = date.formattedString()
                if let existingData = self?.getObjectById(id, StatisticDataObject.self) {
                    self?.write {
                        existingData.weight = Double(data.weight) ?? 0
                        existingData.steps = Double(data.steps) ?? 0
                        existingData.calories = Double(data.calories) ?? 0
                        promise(.success(()))
                    }
                } else {
                    _ = self?.saveNewStatisticData(data: data)
                    promise(.success(()))
                }
            }
            .eraseToAnyPublisher()
        }
    
 
    
    func saveNewStatisticData(data: StatisticData) -> StatisticDataObject {
        let date = data.date ?? Date()
        let id = date.formattedString()
        let newData = StatisticDataObject()
        newData.id = id
        newData.weight = Double(data.weight) ?? 0
        newData.steps = Double(data.steps.replacingOccurrences(of: ",", with: "")) ?? 0
        newData.calories = Double(data.calories.replacingOccurrences(of: ",", with: "")) ?? 0
        
        write {
            self.realm?.add(newData)
        }
        return newData
    }
    
    func clearStatisticData(id: String) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { [weak self] promise in
            if let updatedData = self?.getObjectById(id, StatisticDataObject.self) {
                self?.write {
                    updatedData.calories = 0
                    updatedData.steps = 0
                    updatedData.weight = 0
                    promise(.success(()))
                }
            }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func createMockedDataStatistic() {
        let startDate =  Date.date(from: "2023-01-01")
        let endDate =  Date()
        var currentDate = startDate
        
        while currentDate <= endDate {
            let newData = StatisticDataObject()
            newData.id = currentDate.formattedString()
            newData.weight = Double.random(in: 75...85)  // Random weight between 79 and 85
            newData.steps = Double.random(in: 5000...20000) // Random steps between 5000 and 15000
            newData.calories = Double.random(in: 1200...2500)  // Random calories between 1200 and 2000
            newData.date = currentDate
            
            // Add only once per installation
            guard  getObjectById(newData.id, StatisticDataObject.self) == nil else {
                return
            }
            
            saveObject(entity: newData)
            
            // Move to the next day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
}
