//
//  MainViewModelTests.swift
//  WeightInsightTests
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import XCTest
@testable import WeightInsight

final class MainViewModelTests: XCTestCase {
    var viewModel: MainView.ViewModel!
    var mockDataService: MockDataService!
    
    override func setUpWithError() throws {
        mockDataService = MockDataService()
        viewModel = MainView.ViewModel(dataService: mockDataService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockDataService = nil
    }

    func testSelectedDateUpdatesSelectedStatistic() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let thisWeekDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let lastWeekDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!)!
        let futureDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .weekOfYear, value: +10, to: Date())!)!

        // Test this week
        viewModel.selectedDate = thisWeekDate
        XCTAssertEqual(viewModel.selectedStatistic.weight, "70")
        XCTAssertEqual(viewModel.selectedStatistic.steps, "5000")
        XCTAssertEqual(viewModel.selectedStatistic.calories, "1000")
        
        // Test previous week
        viewModel.selectedDate = lastWeekDate
        XCTAssertEqual(viewModel.selectedStatistic.weight, "80")
        XCTAssertEqual(viewModel.selectedStatistic.steps, "15000")
        XCTAssertEqual(viewModel.selectedStatistic.calories, "2000")
        
        // Test date without available data
        viewModel.selectedDate = futureDate
        XCTAssertEqual(viewModel.selectedStatistic.weight, "0")
        XCTAssertEqual(viewModel.selectedStatistic.steps, "0")
        XCTAssertEqual(viewModel.selectedStatistic.calories, "0")
    }

    func testSelectedFilterUpdatesAverageStatistic() {
        // Test previous week
        viewModel.selectedFilter = .previousWeek
        XCTAssertEqual(viewModel.averageStatistic.weight, "80.0")
        XCTAssertEqual(viewModel.averageStatistic.steps, "15000")
        XCTAssertEqual(viewModel.averageStatistic.calories, "2000")
        
        // Test this week
        viewModel.selectedFilter = .thisWeek
        XCTAssertEqual(viewModel.averageStatistic.weight, "70.0")
        XCTAssertEqual(viewModel.averageStatistic.steps, "5000")
        XCTAssertEqual(viewModel.averageStatistic.calories, "1000")
    }
    
    func testSelectedFilterUpdatesFilteredStatistic() {
        // Test previous week
        viewModel.selectedFilter = .previousWeek
    
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.weight, 80)
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.steps, 15000)
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.calories, 2000)
        
        // Test this week
        viewModel.selectedFilter = .thisWeek
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.weight, 70)
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.steps, 5000)
        XCTAssertEqual(viewModel.statisticDataFiltered.first?.calories, 1000)
        
    }
    
    func testSelectedFilterUpdatesShowCustomPopup() {
        viewModel.selectedFilter = .custom

        XCTAssertTrue(viewModel.showCustomFilterPopup)
    }
    
    func testSelectedFilterSavesPreviousFilterValue() {
        viewModel.selectedFilter = .lastMonth
        viewModel.selectedFilter = .custom
        XCTAssertEqual(viewModel.previousFiler, .lastMonth)
    }
    
    func testSelectedFilterSavesSharedData() {
        viewModel.selectedFilter = .thisWeek
        viewModel.selectedFilter = .previousWeek
        let avgData = viewModel.averageStatistic
        let sharedData = SharedData.get()
        
        XCTAssertEqual(sharedData.avgWeight, Double(avgData.weight) ?? 0)
        XCTAssertEqual(sharedData.avgSteps.intFormatter, avgData.steps)
        XCTAssertEqual(sharedData.avgCalories.intFormatter, avgData.calories)
    }
    
    func testSavingStatisticDataUpdatesFilteredStatistic() {
        viewModel.selectedFilter = .thisWeek
        let updatedStatistic = viewModel.statisticDataFiltered[0]
        let oldData = updatedStatistic
        let index = mockDataService.mockStatisticData.firstIndex(of: updatedStatistic) ?? 0
        
        // Test weight value was changed
        updatedStatistic.weight = 100
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.statisticDataFiltered[0].weight, 100)
        XCTAssertEqual(viewModel.statisticDataFiltered[0].steps, 5000)
        XCTAssertEqual(viewModel.statisticDataFiltered[0].calories, 1000)
        
        // Test steps value was changed
        updatedStatistic.steps = 12000
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.statisticDataFiltered[0].weight, 100)
        XCTAssertEqual(viewModel.statisticDataFiltered[0].steps, 12000)
        XCTAssertEqual(viewModel.statisticDataFiltered[0].calories, 1000)
        
        // Test calories value was changed
        updatedStatistic.calories = 1300
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.statisticDataFiltered[0].weight, 100)
        
        XCTAssertEqual(viewModel.statisticDataFiltered[0].calories, 1300)
        
        // Reset data after the test
        mockDataService.mockStatisticData[index] = oldData
    }
    
    func testSavingStatisticDataUpdatesAverageStatistic() {
        viewModel.selectedFilter = .thisWeek
        let updatedStatistic = viewModel.statisticDataFiltered[0]
        let oldData = updatedStatistic
        let index = mockDataService.mockStatisticData.firstIndex(of: updatedStatistic) ?? 0
        
        // Test weight value was changed
        updatedStatistic.weight = 100
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.averageStatistic.weight, "74.29")
        
        // Test steps value was changed
        updatedStatistic.steps = 12000
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.averageStatistic.steps, "6000")
        
        // Test calories value was changed
        updatedStatistic.calories = 1300
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.averageStatistic.calories, "1042")
        
        // Reset data after the test
        mockDataService.mockStatisticData[index] = oldData
    }
    
    func testSavingStatisticDataUpdatesSelectedStatistic() {
        guard let updatedStatistic = mockDataService.getStatisticForDate(date: viewModel.selectedDate) else {
            XCTFail("Failed to retrieve updated statistic for date \(viewModel.selectedDate)")
            return
        }
        
        let oldData = updatedStatistic
        let index = mockDataService.mockStatisticData.firstIndex(of: updatedStatistic) ?? 0
        
        // Test weight value was changed
        updatedStatistic.weight = 100
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.selectedStatistic.weight, "100")
        
        // Test steps value was changed
        updatedStatistic.steps = 12000
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.selectedStatistic.steps, "12000")
        
        // Test calories value was changed
        updatedStatistic.calories = 1300
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(viewModel.selectedStatistic.calories, "1300")
        
        // Reset data after the test
        mockDataService.mockStatisticData[index] = oldData
    }
    
    func testSavingStatisticDataUpdatesSharedData() {
        guard let updatedStatistic = mockDataService.getStatisticForDate(date: viewModel.selectedDate) else {
            XCTFail("Failed to retrieve updated statistic for date \(viewModel.selectedDate)")
            return
        }
        
        let oldData = updatedStatistic
        let index = mockDataService.mockStatisticData.firstIndex(of: updatedStatistic) ?? 0
       
        // Test weight value was changed
        updatedStatistic.weight = 100
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(SharedData.get().todayWeight, 100)
        
        // Test steps value was changed
        updatedStatistic.steps = 12000
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(SharedData.get().todaySteps , 12000)
        
        // Test calories value was changed
        updatedStatistic.calories = 1300
        mockDataService.mockStatisticData[index] = updatedStatistic
        viewModel.statisticDataSaved = true
        XCTAssertEqual(SharedData.get().todayCalories, 1300)
        
        // Reset data after the test
        mockDataService.mockStatisticData[index] = oldData
    }
}

