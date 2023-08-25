//
//  SettingsViewModelTests.swift
//  WeightInsightTests
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import XCTest
@testable import WeightInsight

final class SettingsViewModelTests: XCTestCase {

    var viewModel: SettingsView.ViewModel!

    override func setUpWithError() throws {
        viewModel = SettingsView.ViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testSaveSettingValue() {
         viewModel.saveSettingValue("70", for: .weight)
         XCTAssertEqual(viewModel.goals.weightGoal, "70")

         viewModel.saveSettingValue("12000", for: .steps)
         XCTAssertEqual(viewModel.goals.stepsGoal, "12000")

         viewModel.saveSettingValue("2000", for: .calories)
         XCTAssertEqual(viewModel.goals.caloriesGoal, "2000")
     }

     func testGetGoals() {
         UserDefaults.standard.setValue("75", forKey: SettingsType.weight.rawValue)
         UserDefaults.standard.setValue("10000", forKey: SettingsType.steps.rawValue)
         UserDefaults.standard.setValue("1500", forKey: SettingsType.calories.rawValue)

         viewModel.getGoals()

         XCTAssertEqual(viewModel.goals.weightGoal, "75")
         XCTAssertEqual(viewModel.goals.stepsGoal, "10000")
         XCTAssertEqual(viewModel.goals.caloriesGoal, "1500")
     }
}

