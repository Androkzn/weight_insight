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

    func testSelectedDateDidChange() {
        let currentDate = Date()
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        
        viewModel.selectedDate = newDate
        
        XCTAssertEqual(viewModel.selectedDate, newDate)
        // Write additional assertions based on how selectedDate affects other properties or methods
    }

    func testSelectedFilterDidChange() {
        viewModel.selectedFilter = .thisMonth
        
        XCTAssertEqual(viewModel.selectedFilter, .thisMonth)
        // Write additional assertions based on how selectedFilter affects other properties or methods
    }

    func testIsEditingTodayStatisticDidChange() {
        viewModel.isEditingTodayStatistic = true
        
        XCTAssertTrue(viewModel.isEditingTodayStatistic)
        // Write additional assertions based on how isEditingTodayStatistic affects other properties or methods
    }

    func testStatisticDataSavedDidChange() {
        viewModel.statisticDataSaved = true
        
        XCTAssertTrue(viewModel.statisticDataSaved)
        // Write additional assertions based on how statisticDataSaved affects other properties or methods
    }
    
}

