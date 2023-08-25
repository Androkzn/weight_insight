//
//  MockedModel.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 27.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Foundation

#if DEBUG
extension SharedData {
    static var mockedData: SharedData = {
        return SharedData(todayWeight: 80.0,
                          todaySteps: 12500.0,
                          todayCalories: 1950.0,
                          avgWeight: 81.55,
                          avgSteps: 10520.0,
                          avgCalories: 1745.0,
                          targetWeight: 79.0,
                          targetSteps: 10000.0,
                          targetCalories: 1850.0,
                          selectedPeriod: "thisWeek")
    }()
}

#endif
