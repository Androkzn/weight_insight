//
//  Provider.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(data: SharedData.defaultInstance())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(data: fetchSharedData()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(data: fetchSharedData())], policy: .atEnd)
        completion(timeline)
    }
}

func fetchSharedData() -> SharedData {
    guard let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weight_insight")?.appendingPathComponent("data.json") else { return SharedData.defaultInstance() }
    
    if let data = try? Data(contentsOf: sharedContainerURL) {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(SharedData.self, from: data) {
            return decodedData
        }
    }
    return SharedData.defaultInstance()
}
