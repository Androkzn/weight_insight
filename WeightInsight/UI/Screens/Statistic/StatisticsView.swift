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
    @State private var showEditPopup: Bool = false
    @State private var showDeletePopup: Bool = false
    @State private var editingEntry: StatisticData = StatisticData(weight: "",steps: "", calories: "")
    
 
    var body: some View {
        let data =  viewModel.sortedKeys()
        NavigationView {
            List {
                ForEach(data, id: \.self) { monthYear in
                    Section(header: Text(monthYear).font(.headline).padding()) {
                        ForEach(viewModel.dataStore.statisticDataGrouped[monthYear]!, id: \.date) { entry in
                            HStack {
                                // Date
                                Text(entry.date.formattedString(format: "dd MMM yyyy"))
                                    .font(.headline)
                                    .bold()
                                Spacer()
                                VStack {
                                    statisticEntryRow(imageName: "scalemass", color: Color.blue, value: entry.weight.decimalFormatter)
                                    statisticEntryRow(imageName: "figure.walk", color: Color.green, value:  entry.steps.intFormatter  )
                                    statisticEntryRow(imageName: "flame", color: Color.orange, value:  entry.calories.intFormatter )
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    editingEntry = StatisticData (
                                        weight:   entry.weight.decimalFormatter,
                                        steps: entry.steps.intFormatter,
                                        calories: entry.calories.intFormatter,
                                        date: entry.date
                                    )
                                    showEditPopup = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                }
                                .tint(.orange)
                                Button(action: {
                                    editingEntry = StatisticData (
                                        weight: entry.weight.decimalFormatter,
                                        steps:  entry.steps.intFormatter,
                                        calories:  entry.calories.intFormatter,
                                        date: entry.date
                                    )
                                    showDeletePopup = true
                                }) {
                                    Label("Clear", systemImage: "trash")
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                 
            }
            .padding(10)
            .environment(\.editMode, $editMode)
            .overlay(
                Group {
                    if showEditPopup {
                        EditStatisticPopupView(entry: $editingEntry, showEditPopup: $showEditPopup) { statisticData in
                            // Save action for the popup
                            viewModel.editStatisticData(data: statisticData)
                            showEditPopup = false
                        }
                    } else if showDeletePopup, let id = editingEntry.date?.formattedString() {
                        ClearStatisticPopupView(entryId: id) { entryId in
                            // On Delete Action
                            viewModel.clearStatisticData(id: entryId)
                            showDeletePopup = false
                        } onCancel: {
                            // On Cancel Action
                            showDeletePopup = false
                        }
                    }
                }
            )
        } .onAppear() {
            
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


#if DEBUG
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
#endif
