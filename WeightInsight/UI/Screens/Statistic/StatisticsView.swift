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
 
    var body: some View {
        let data =  viewModel.sortedKeys()
        NavigationView {
            List {
                ForEach(data, id: \.self) { monthYear in
                    Section(header: Text(monthYear).font(.headline).padding()) {
                        ForEach(viewModel.statisticDataGrouped[monthYear]!, id: \.date) { entry in
                            HStack {
                                // Date
                                Text(entry.date.formattedString(format: "dd MMM yyyy"))
                                    .font(.headline)
                                    .bold()
                                // Show missing data if needed
                                MissingDataView(data: entry)
                                Spacer()
                                VStack {
                                    StatisticCell(imageName: "scalemass", color: Color.blue, value: entry.weight.decimalFormatter)
                                    StatisticCell(imageName: "figure.walk", color: Color.green, value:  entry.steps.intFormatter  )
                                    StatisticCell(imageName: "flame", color: Color.orange, value:  entry.calories.intFormatter )
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                            }
                            .swipeActions(edge: .trailing) {
                                Button(action: {
                                    viewModel.editingEntry = StatisticData (
                                        weight:   entry.weight.decimalFormatter,
                                        steps: entry.steps.intFormatter,
                                        calories: entry.calories.intFormatter,
                                        date: entry.date
                                    )
                                    viewModel.showEditPopup = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                        .foregroundColor(.white)
                                        .padding(.top, 5)
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                }
                                .tint(.orange)
                                Button(action: {
                                    viewModel.editingEntry = StatisticData (
                                        weight: entry.weight.decimalFormatter,
                                        steps:  entry.steps.intFormatter,
                                        calories:  entry.calories.intFormatter,
                                        date: entry.date
                                    )
                                    viewModel.showDeletePopup = true
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
            .environment(\.editMode, $viewModel.editMode)
            .overlay(
                Group {
                    if viewModel.showEditPopup {
                        EditStatisticPopupView(entry: $viewModel.editingEntry, showEditPopup: $viewModel.showEditPopup) { statisticData in
                            // Save action for the popup
                            viewModel.editStatisticData(data: statisticData)
                            viewModel.showEditPopup = false
                        }
                    } else if viewModel.showDeletePopup, let id = viewModel.editingEntry.date?.formattedString() {
                        ClearStatisticPopupView(entryId: id) { entryId in
                            // On Delete Action
                            viewModel.clearStatisticData(id: entryId)
                            viewModel.showDeletePopup = false
                        } onCancel: {
                            // On Cancel Action
                            viewModel.showDeletePopup = false
                        }
                    }
                }
            )
        } .onAppear() {
            // Update data 
            viewModel.getGroupedStatisticData()
        }
    }
}


#if DEBUG
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environmentObject(StatisticsView.ViewModel(dataService: RealmService(), mainViewModel: MainView.ViewModel(dataService: RealmService())))
    }
}
#endif
