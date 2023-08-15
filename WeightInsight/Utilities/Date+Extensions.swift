//
//  DateHelper.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation

extension Date {
    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Date {
    var isInThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isInPreviousWeek: Bool {
        guard let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else { return false }
        return Calendar.current.isDate(self, equalTo: lastWeek, toGranularity: .weekOfYear)
    }
    
    var isInThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    var isInLastMonth: Bool {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return false }
        return Calendar.current.isDate(self, equalTo: lastMonth, toGranularity: .month)
    }
}
 



