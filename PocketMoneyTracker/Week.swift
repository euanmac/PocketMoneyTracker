//
//  Week.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 19/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation

//Instead of defining a wrapper around dictionary, try using type alias instead along with extension
typealias Weeks = [Int : Week]

//Extend dictionary to provide a subscript lookup for a given date
//extension Dictionary where Key == Int, Value == Week {
extension Weeks {

    subscript (for date: Date) -> Week? {
        get {
            return self[Week.weekId(for: date)]
        }
        set {
            self[Week.weekId(for: date)] = newValue
        }
    }
}

extension Weeks {
    
    public func weekIsComplete(for date: Date) -> Bool {
        self[for: date] != nil
    }

    public func weekIsPaid(for date: Date) -> Bool {
       self[for: date]?.isPaid ?? false
    }

}


struct Week : Identifiable, Codable {
    
    let number: Int
    let year: Int
    let base: Double
    let id: Int
    var isPaid: Bool
    let taskIds: [UUID]

    static func weekId(for date: Date) -> Int {
        return Int(String(date.year) + String(date.weekOfYear))!
    }
    
    init (number: Int, year: Int, base: Double, isPaid: Bool, taskIds: [UUID]) {
        self.number = number
        self.year = year
        self.base = base
        self.isPaid = isPaid
        self.taskIds = taskIds
        self.id = Int(String(self.year) + String(self.number))!
    }
    
    init (date: Date, base: Double, isPaid: Bool, taskIds: [UUID]) {
        self.init(number: date.weekOfYear, year: date.year, base: base, isPaid: isPaid, taskIds: taskIds)
    }
        
    var startDate: Date {
        get {
            let dc = DateComponents(calendar: Calendar.current, weekOfYear: number, yearForWeekOfYear: self.year)
            return Calendar.current.date(from: dc)!
        }
    }
    
    var endDate: Date {
        get {
            return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        }
    }
    
}

extension Week : CustomStringConvertible {
    var description: String {
        get {
            let output = "ID: \(String(self.id))"
            return output
        }
    }
}



