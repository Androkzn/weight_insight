//
//  WeightInsightWidget.swift
//  WeightInsightWidget
//
//  Created by Andrei Tekhtelev on 2023-08-19.
//

import WidgetKit
import SwiftUI
import Intents
 

struct WeightInsightWidget: Widget {
    let kind: String = "WeightInsightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeightInsightWidgetEntryView(data: entry.data)
        }
        .configurationDisplayName("Weight Insight Widget")
        .description("This is an Weight Insight widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WeightInsightWidgetEntryView: View {
    var data: SharedData
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemMedium:
            ExtendedStatisticView(data: data)
        default:
            TodayStatisticView(data: data) 
        }
    }
}
 
struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
    let data: SharedData
}


struct WeightInsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeightInsightWidgetEntryView(data: SharedData.defaultInstance())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WeightInsightWidgetEntryView(data: SharedData.defaultInstance())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
