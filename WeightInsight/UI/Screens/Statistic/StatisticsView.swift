//
//  StatisticsView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct StatisticsView: View {
    @EnvironmentObject var viewModel: ViewModel

    @State private var editMode: EditMode = .inactive
    @State private var showPopup: Bool = false
    @State private var editingEntry: StatisticData = StatisticData(weight: "",steps: "", calories: "")
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.groupedByMonth().keys.sorted(by: >), id: \.self) { monthYear in
                    Section(header: Text(monthYear).font(.headline).padding()) {
                        ForEach(viewModel.groupedByMonth()[monthYear]!, id: \.date) { entry in
                            HStack {
                                // Date
                                Text(entry.date.formattedString(format: "dd MMM yyyy"))
                                    .font(.headline)
                                    .bold()
                                Spacer()
                                VStack {
                                    statisticEntryRow(imageName: "scalemass", color: Color.blue, value: String(format: "%.2f", entry.weight))
                                    statisticEntryRow(imageName: "figure.walk", color: Color.green, value: "\(Int(entry.steps))")
                                    statisticEntryRow(imageName: "flame", color: Color.orange, value: "\(Int(entry.calories))")
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    editingEntry = StatisticData(weight: String(format: "%.2f", entry.weight),steps: String(entry.steps), calories: String(entry.calories), date: entry.date)
                                    showPopup = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }
                 
            }
            .padding(10)
            .environment(\.editMode, $editMode)
            .overlay(
                Group {
                    if showPopup {
                        EditStatisticPopupView(entry: $editingEntry) { statisticData in
                            // Save action for the popup
                            viewModel.editStatisticData(data: statisticData)
                            showPopup = false
                        }
                    }
                }
            )
        }
    }
    
    func statisticEntryRow(imageName: String, color: Color, value: String) -> some View {
        return HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
            Text(value)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
    }
}



struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(StatisticsView.ViewModel())
    }
}
