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
    return SharedData.get()
}
