//
//  String+Extensions.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-26.
//

import Foundation

extension String {
    var withThousandsSeparator: String {
        if let number = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: number)) ?? self
        }
        return self
    }
    
    var withoutThousandsSeparator: String {
        return self.replacingOccurrences(of: ",", with: "")
    }

}
