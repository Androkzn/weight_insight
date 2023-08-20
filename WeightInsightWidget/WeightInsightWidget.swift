//
//  WeightInsightWidget.swift
//  WeightInsightWidget
//
//  Created by Andrei Tekhtelev on 2023-08-19.
//

import WidgetKit
import SwiftUI
import Intents
 

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WeightInsightWidgetEntryView : View {
    var body: some View {
        AverageStatisticWidgetView()
    }
}

struct AverageStatisticWidgetView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(Date().formattedString(format: "dd MMM yyyy"))
                    .font(.headline)
                    .bold()
                    .padding(EdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7))
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            
                Spacer()
                statisticEntryRowWidget(imageName: "scalemass", color: Color.blue, value: String(format: "%.2f", 58.8))
                statisticEntryRowWidget(imageName: "figure.walk", color: Color.green, value: "\(Int(11547))")
                statisticEntryRowWidget(imageName: "flame", color: Color.orange, value: "\(Int(1258))")
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            Spacer()
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

func statisticEntryRowWidget(imageName: String, color: Color, value: String) -> some View {
    return HStack {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(6)
            .frame(width: 30, height: 30)
            .foregroundColor(color)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 2)
            )
        Text(value)
        Image(systemName: 1 >= 0 ? "arrow.up" : "arrow.down")
                    .foregroundColor(1 >= 0 ? Color.green : Color.red)
        Spacer()
    }
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
}

struct WeightInsightWidget: Widget {
    let kind: String = "WeightInsightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { _ in
            WeightInsightWidgetEntryView()
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeightInsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeightInsightWidgetEntryView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
