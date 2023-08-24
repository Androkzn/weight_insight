//
//  NumberFormatter+Extensions.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 
        return formatter
    }()
    
    static let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
