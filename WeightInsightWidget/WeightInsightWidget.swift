//
//  WeightInsightWidget.swift
//  WeightInsightWidget
//
//  Created by Andrei Tekhtelev on 2023-08-19.
//

import WidgetKit
import SwiftUI
import Intents
import Charts

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

struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
    let data: SharedData
}

struct WeightInsightWidgetEntryView: View {
    var data: SharedData
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemMedium:
            AverageStatisticWidgetView(data: data)
        default:
            LatestStatisticWidgetView(data: data) 
        }
    }
}

struct LatestStatisticWidgetView: View {
    var data: SharedData
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
                statisticRowWidget(imageName: "scalemass", color: Color.blue, value: String(format: "%.2f", data.todayWeight))
                statisticRowWidget(imageName: "figure.walk", color: Color.green, value: String(format: "%.0f", data.todaySteps))
                statisticRowWidget(imageName: "flame", color: Color.orange, value:  String(format: "%.0f", data.todayCalories))
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            Spacer()
        }
        .background(Color.white.opacity(0.1))
    }
}

func statisticRowWidget(imageName: String, color: Color, value: String) -> some View {
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
        Spacer()
    }
    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
}

struct AverageStatisticWidgetView: View {
    var data: SharedData
    
    var body: some View {
        VStack {
            HStack {
                extendedStatisticRowWidget(imageName: "scalemass", color: Color.blue, value: "Weight", todayValue: data.todayWeight, avgValue: data.avgWeight, targetValue: data.targetWeight, format:  "%.2f")
                Spacer()
                extendedStatisticRowWidget(imageName: "figure.walk", color: Color.green, value: "Steps", todayValue: data.todaySteps, avgValue: data.avgSteps, targetValue: data.targetSteps, format:  "%.0f")
                Spacer()
                extendedStatisticRowWidget(imageName: "flame", color: Color.orange, value: "Calories",  todayValue: data.todayCalories, avgValue: data.avgCalories, targetValue: data.targetCalories, format:  "%.0f")
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 2, trailing: 10))
            legendView(period: data.selectedPeriod)
            Spacer()
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(Color.blue.opacity(0.2))
    }
    
}

func legendView(period: String = "This Week") -> some View {
       HStack {
           Spacer()
           legendItem(color: Color.blue.opacity(0.5), text: "Today")
           Spacer()
           legendItem(color: Color.orange.opacity(0.5), text: "Avg \(period)")
           Spacer()
           legendItem(color: Color.green.opacity(0.5), text: "Your goal")
           Spacer()
       }
   }
   
func legendItem(color: Color, text: String) -> some View {
    HStack(spacing: 5) {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
        Text(text)
            .font(.system(size: 11))
    }
}

func extendedStatisticRowWidget(imageName: String, color: Color, value: String, todayValue: Double, avgValue: Double, targetValue: Double, format: String) -> some View {
    return VStack() {
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
        BarChartView(
            todayValue: todayValue,
            avgValue: avgValue,
            targetValue: targetValue,
            format:  format
        )
        Spacer()
    }
    .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    .background(Color.white.opacity(1.0))
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue.opacity(0.6), lineWidth: 1)
    )
}

struct RightRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addArc(center: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct BarChartView: View {
    var todayValue: CGFloat
    var avgValue: CGFloat
    var targetValue: CGFloat
    var format: String
    var maxBarHeight: CGFloat = 70
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                RightRoundedRectangle(cornerRadius: 8)  // Today Value
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: self.barWidth(for: todayValue), height: 20)
                    .overlay(
                        Text(String(format: format, todayValue))
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )

                RightRoundedRectangle(cornerRadius: 8)  // Average this Week Value
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: self.barWidth(for: avgValue), height: 20)
                    .overlay(
                        Text(String(format: format, avgValue))
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )

                RightRoundedRectangle(cornerRadius: 8)  // Target Value
                    .fill(Color.green.opacity(0.3))
                    .frame(width: self.barWidth(for: targetValue), height: 20)
                    .overlay(
                        Text(String(format: format, targetValue))
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    )
            }
            .animation(SwiftUI.Animation.default, value: 0.5)
        }

    }
    
    func barWidth(for value: CGFloat) -> CGFloat {
        return (value / max(targetValue, avgValue, todayValue)) * maxBarHeight
    }
}

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

struct WeightInsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeightInsightWidgetEntryView(data: SharedData.defaultInstance())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        WeightInsightWidgetEntryView(data: SharedData.defaultInstance())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
