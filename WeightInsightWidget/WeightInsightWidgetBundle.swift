//
//  WeightInsightWidgetBundle.swift
//  WeightInsightWidget
//
//  Created by Andrei Tekhtelev on 2023-08-19.
//

import WidgetKit
import SwiftUI

@main
struct WeightInsightWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeightInsightWidget()
        WeightInsightWidgetLiveActivity()
    }
}
