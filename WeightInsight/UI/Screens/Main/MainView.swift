//
//  MainView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine
import Charts
import RealmSwift

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var selectedFilter: StatisticFilter = .thisWeek
    @State private var selectedDate: Date = Date()
    @State private var selectedChartStatistic: Statistic = .weight
    @State private var selectedWeight: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isEditingTodayStatistic: Bool = false
    @State private var statisticData: [StatisticDataObject] = []
    @State private var statisticCurrent: StatisticData = StatisticData(weight: "0", steps: "0", calories: "0")
    
    var body: some View {
        VStack {
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
                    self.statisticData = viewModel.getStatisticObjects(filter: selectedFilter)
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
                    value: viewModel.getStatisticFor(filter: selectedFilter).weight,
                    goalValue: "\(viewModel.loadSettingValue(for: .weight))"
                )
                
                Spacer()
                
                AverageStatisticBoxView(
                    title: Statistic.steps.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).steps,
                    goalValue: "\(viewModel.loadSettingValue(for: .steps))"
                )
                
                Spacer()
                
                AverageStatisticBoxView(
                    title: Statistic.calories.title,
                    value: viewModel.getStatisticFor(filter: selectedFilter).calories,
                    goalValue: "\(viewModel.loadSettingValue(for: .calories))"
                )
                
            }
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            Chart {
                if selectedChartStatistic == .weight {
                    ForEach(statisticData) { data in
                        LineMark(
                            x: .value("Day", data.date),
                            y: .value("Value", data.weight)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                        
                    }
                } else if selectedChartStatistic == .steps {
                    ForEach(statisticData) { data in
                        LineMark(
                            x:.value("Day", data.date),
                            y: .value("Value", data.steps)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.orange)
                    }
                } else if selectedChartStatistic == .calories {
                    ForEach(statisticData) { data in
                        LineMark(
                            x: .value("Day", data.date),
                            y: .value("Value", data.calories)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.green)
                    }
                }
            }
//            .chartXAxis {
//                AxisMarks(values: .automatic(minimumStride: 1)) { _ in
//                    AxisGridLine()
//                    AxisTick()
//                    AxisValueLabel(
//                      format: .dateTime.week(.weekOfMonth)
//                    )
//                }
//            }
            // Hide Selected period chart if keyboard is shown
            .opacity(isEditingTodayStatistic ? 0 : 1)
            .animation(SwiftUI.Animation.default, value: 0.5)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
      
            // Picker for different statistic types
            Picker("Select Chart Statistic", selection: $selectedChartStatistic) {
                ForEach(Statistic.allCases, id: \.self) { statistic in
                    Text(statistic.rawValue.capitalized).tag(statistic)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.blue.opacity(0.1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
            .environmentObject(MainView.ViewModel())
    }
}
 












