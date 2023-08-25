//
//  WeightInsightTests.swift
//  WeightInsightTests
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import XCTest
@testable import WeightInsight

final class StatisticViewModelTests: XCTestCase {

    var viewModel: StatisticsView.ViewModel!

    override func setUpWithError() throws {
        viewModel = StatisticsView.ViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testEditStatisticData() throws {
        // Your test case for editStatisticData method
        let dataToEdit = StatisticData(weight: "150", steps: "5000", calories: "200")
        viewModel.editStatisticData(data: dataToEdit)
        
        XCTAssertTrue(viewModel.statisticDataSaved)
        // You might add more assertions to check expected behavior after editing data
    }

    func testClearStatisticData() throws {
        // Your test case for clearStatisticData method
        let dataId = "123" // Replace with a valid data ID
        viewModel.clearStatisticData(id: dataId)
        
        XCTAssertTrue(viewModel.statisticDataSaved)
        // You might add more assertions to check expected behavior after clearing data
    }

    // Add more test cases for other methods as needed

    func testSortedKeys() throws {
        // Your test case for sortedKeys method
        // Create a mock statisticDataGrouped dictionary and set it in the viewModel
        viewModel.statisticDataGrouped = [
            "January 2023": [], // Replace with your data
            "December 2022": [],
            // Add more entries as needed
        ]
        
        let sortedKeys = viewModel.sortedKeys()
        
        // Add assertions to validate the sorted keys
        XCTAssertEqual(sortedKeys, ["January 2023", "December 2022"])
    }
    
    func testGetGroupedStatisticData() throws {
            viewModel.getGroupedStatisticData()
            
            // Assert that the statisticDataGrouped dictionary contains the expected keys
            XCTAssertEqual(viewModel.statisticDataGrouped.keys.sorted(),
                           ["August 2023", "September 2023"]) // Update with expected keys
             
            // Assert that the statisticDataGrouped dictionary contains the expected data for each key
            XCTAssertEqual(viewModel.statisticDataGrouped["August 2023"]?.count, 1)
            XCTAssertEqual(viewModel.statisticDataGrouped["September 2023"]?.count, 1)
            
            // You can add more assertions based on your specific data
        }
    

}
