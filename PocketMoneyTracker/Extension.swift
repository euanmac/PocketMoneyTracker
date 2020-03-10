//
//  Extension.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 10/03/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import Foundation

public extension Decimal {
    func displayCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "EN-gb")
        return formatter.string(for: self)!
    }
}

public extension Double {
    func displayCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "EN-gb")
        return formatter.string(for: self)!
    }
}

public extension Date {
    var day: String {
        let df = DateFormatter()
        df.dateFormat = "dd"
        return df.string(from: self)
    }
    
    var full: String {
        let df = DateFormatter()
        df.dateFormat = "dd MMMM YYYY"
        return df.string(from: self)
    }
    
    var dayInitial: String {
        let df = DateFormatter()
        df.dateFormat = "E"
        return String(df.string(from: self).prefix(1))
    }
    
    var weekOfDates: [Date] {
        
        var weekOfDates = [self.startOfWeek]
        for i in (0...5) {
            weekOfDates.append(Calendar.current.date(byAdding: .day, value: 1, to: weekOfDates[i])!)
        }
        return weekOfDates
    }
    
    var startOfWeek: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: self)!.start
    }
    
    var endOfWeek: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: self)!.end
    }
    
    func dateEqual(to date: Date) -> Bool {
        let order = Calendar.current.compare(self, to: date, toGranularity: .day)
        return order == .orderedSame
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}
