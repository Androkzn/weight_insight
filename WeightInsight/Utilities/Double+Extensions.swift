//
//  Double+Extensions.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-24.
//

import Foundation

extension Double {
    var decimalFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    var intFormatter: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ""
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
