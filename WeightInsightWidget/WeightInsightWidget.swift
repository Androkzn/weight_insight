//
//  WeightInsightWidget.swift
//  WeightInsightWidget
//
//  Created by Andrei Tekhtelev on 2023-08-19.
//

import WidgetKit
import SwiftUI
import Intents
import RealmSwift

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), datesWithData: [], configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), datesWithData: [], configuration: configuration)
        completion(entry)
    }
    
    func getRealm() -> Realm? {
           let config = Realm.Configuration(
               fileURL: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.weight_insight")?.appendingPathComponent("default.realm")
           )
           return try? Realm(configuration: config)
       }

       func datesWithData() -> [Date] {
           let allData = getAllStatistic()
           return allData.map { $0.date }
       }

       func getAllStatistic() -> [StatisticDataObject] {
           guard let realm = getRealm() else { return [] }
           return Array(realm.objects(StatisticDataObject.self).sorted(by: { $0.date > $1.date }))
       }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let allDatesWithData = datesWithData()

        let entry = SimpleEntry(date: currentDate, datesWithData: allDatesWithData, configuration: configuration)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let datesWithData: [Date]
    let configuration: ConfigurationIntent
}

struct WeightInsightWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        CalendarView(entry: entry)
    }
}

struct CalendarView: View {
    var entry: Provider.Entry
    var currentMonth: Date {
        return Date() // assuming current month
    }

    var body: some View {
        VStack {
            // Display month and year, e.g., "July 2023"
            Text("\(currentMonth, formatter: monthYearFormatter)")
            
            // Display days
            ForEach(1..<32) { day in
                let date = getDate(for: day)
                if entry.datesWithData.contains(date) {
                    Text("\(day)")
                        .background(Color.blue) // Highlighted
                } else {
                    Text("\(day)")
                }
            }
        }
    }

    func getDate(for day: Int) -> Date {
        // Convert day into Date for the current month
        // Add your logic here
    }

    var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}


struct WeightInsightWidget: Widget {
    let kind: String = "WeightInsightWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeightInsightWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeightInsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeightInsightWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
