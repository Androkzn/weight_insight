//
//  MainView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import RealmSwift

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var selectedFilter: StatisticFilter = .thisWeek
    @State private var selectedDate: Date = Date()
    @State private var selectedChartStatistic: [Statistic] = [.weight]
    @State private var selectedWeight: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isEditingTodayStatistic: Bool = false
    @State private var statisticData: [StatisticDataObject] = []
    @State private var statisticCurrent: StatisticData = StatisticData(weight: "0", steps: "0", calories: "0")
    
    var body: some View {
        VStack {
            //Average Statistic View 
            AverageStatisticView(
                selectedFilter: $selectedFilter,
                avgWeight: viewModel.getStatisticFor(filter: selectedFilter).weight,
                avgSteps: viewModel.getStatisticFor(filter: selectedFilter).steps,
                avgCalories: viewModel.getStatisticFor(filter: selectedFilter).calories,
                goalWeight: viewModel.loadSettingValue(for: .weight),
                goalSteps: viewModel.loadSettingValue(for: .steps),
                goalCalories: viewModel.loadSettingValue(for: .calories)
            ) {
                self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
            }
            
            //MultiLineChartView
            ChartView(
                selectedChartStatistic: $selectedChartStatistic,
                statisticData: $statisticData,
                isEditingTodayStatistic: $isEditingTodayStatistic
            )
            
            GeometryReader { geometry in
                HStack(spacing: 10) {
                    ForEach(Statistic.allCases, id: \.self) { statistic in
                        Button(action: {
                            if selectedChartStatistic.contains(statistic) {
                                // Ensure that at least one item remains selected
                                if selectedChartStatistic.count > 1 {
                                    selectedChartStatistic.removeAll { $0 == statistic }
                                }
                            } else {
                                selectedChartStatistic.append(statistic)
                            }
                        }) {
                            Text(statistic.rawValue.capitalized)
                                .frame(width: (geometry.size.width - 40) / 3, height: 25) // 40 accounts for total leading and trailing padding and spaces between buttons
                                .background(
                                    selectedChartStatistic.contains(statistic) ?
                                    getColorForStatistic(statistic) : Color.gray
                                )
                                .foregroundColor(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }.frame(height: 20)
            
            
            
            HStack() {
                Text("Your data for")
                    .font(.headline)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                
                Spacer()
                
                DatePicker("", selection: $selectedDate,  in: ...Date(), displayedComponents: .date)
                    .onChange(of: selectedDate) { newDate in
                        self.selectedDate = newDate
                        updateStatisticForSelectedDate(date: newDate)
                    }
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                
            }
            .background(Color.orange.opacity(0.3))
            .cornerRadius(10)
            .padding(EdgeInsets(top:10, leading: 10, bottom:0, trailing: 10))
            
            HStack(spacing: 10) {
                SingleStatisticBoxView(value: $selectedWeight, isEditingTodayStatistic: $isEditingTodayStatistic, selectedDate: $selectedDate, statisticType: Statistic.weight) {
                    isEditingTodayStatistic.toggle()
                    self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
                    
                }
                
                SingleStatisticBoxView(value: $selectedSteps, isEditingTodayStatistic: $isEditingTodayStatistic, selectedDate: $selectedDate, statisticType: Statistic.steps) {
                    isEditingTodayStatistic.toggle()
                    self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
                }
                
                SingleStatisticBoxView(value: $selectedCalories, isEditingTodayStatistic: $isEditingTodayStatistic, selectedDate: $selectedDate, statisticType: Statistic.calories) {
                    isEditingTodayStatistic.toggle()
                    self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Spacer()
            
        }.onAppear {
            // Update statistic data for chart based on current filter
            self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
            // Fill with saved statistic data
            updateStatisticForSelectedDate(date: selectedDate)
        }
    }
    
    func updateStatisticForSelectedDate(date: Date) {
        self.statisticCurrent = viewModel.getStatisticForDate(date: date)
        self.selectedWeight = Double(self.statisticCurrent.weight) ?? 0
        self.selectedSteps = Double(self.statisticCurrent.steps) ?? 0
        self.selectedCalories = Double(self.statisticCurrent.calories) ?? 0
    }
}

// Get color based on Statistic
func getColorForStatistic(_ statistic: Statistic) -> Color {
    switch statistic {
    case .weight:
        return Color.blue.opacity(0.5)
    case .steps:
        return Color.green.opacity(0.5)
    case .calories:
        return Color.orange.opacity(0.5)
    }
}

struct AverageStatisticView: View {
    @Binding  var selectedFilter: StatisticFilter
    @State var avgWeight: String
    @State var avgSteps: String
    @State var avgCalories: String
    @State var goalWeight: String
    @State var goalSteps: String
    @State var goalCalories: String
    
    var onFilterTapped: () -> Void
    
    var body: some View {
        // Filter box view
        HStack() {
            Text("Average statistic:")
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .font(.headline)
            
            Spacer()
            
            Picker("Filter period", selection: $selectedFilter) {
                ForEach(StatisticFilter.allCases, id: \.self) {
                    Text($0.title)
                }
            }.onChange(of: selectedFilter) { selectedFilter in
                onFilterTapped()
            }
            .pickerStyle(.menu)
            .tint(.black)
        }
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
        
        // Average statistic boxes view
        HStack(spacing: 0) {
            AverageStatisticBoxView(
                title: Statistic.weight.title,
                value: avgWeight,
                goalValue: goalWeight
            )
            
            Spacer()
            
            AverageStatisticBoxView(
                title: Statistic.steps.title,
                value: avgSteps,
                goalValue: goalSteps
            )
            
            Spacer()
            
            AverageStatisticBoxView(
                title: Statistic.calories.title,
                value: avgCalories,
                goalValue: goalCalories
            )
            
        }
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
            .environmentObject(MainView.ViewModel())
    }
}







