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
    @EnvironmentObject var mainViewModel: MainView.ViewModel
    
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
                                missingDataView(data: entry)
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
                            mainViewModel.statisticDataSaved = true
                        }
                    } else if viewModel.showDeletePopup, let id = viewModel.editingEntry.date?.formattedString() {
                        ClearStatisticPopupView(entryId: id) { entryId in
                            // On Delete Action
                            viewModel.clearStatisticData(id: entryId)
                            viewModel.showDeletePopup = false
                            mainViewModel.statisticDataSaved = true
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
    
    func missingDataView(data: StatisticDataObject) -> some View {
        Group {
            if data.weight == 0 || data.steps == 0 || data.calories == 0 {
                VStack(alignment: .center) {
                    Image("missing_data")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    Text("Missing data")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .padding(5)
                .frame(width: 60)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(8)
            } else {
                EmptyView()
            }
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
            .environmentObject(StatisticsView.ViewModel(dataService: RealmService()))
            .environmentObject(MainView.ViewModel(dataService: RealmService()))
    }
}
#endif
