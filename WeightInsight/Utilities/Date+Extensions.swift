//
//  DateHelper.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import Foundation

extension Date {
    func formattedString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string) ?? Date()
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
    
    var yesterday: Date {
       return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    }
    
    var isFirstDayOfMonth: Bool {
        let calendar = Calendar.current
        return calendar.component(.day, from: self) == 1
    }
}
 



