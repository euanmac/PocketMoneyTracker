//
//  Week.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 19/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation

struct Week : Identifiable, Codable {

    let number: Int
    let year: Int
    let base: Double
    let id: Int
    let isPaid: Bool
    let taskIds: [UUID]

//    enum CodingKeys: String, CodingKey {
//        case number, year, base, id, isComplete
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        number = try values.decode(Int.self, forKey: .number)
//        year = try values.decode(Int.self, forKey: .year)
//        id  = try values.decode(Int.self, forKey: .base)
//        base  = try values.decode(Double.self, forKey: .base)
//        isComplete = try values.decode(Bool.self, forKey: .isComplete)
//
//    }
//
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

//struct Weeks: Codable {
//    private var weeks = [Int: Week]()
//
//    subscript (id: Int) -> Week? {
//        get {
//            return weeks[id]
//        }
//        set(newValue) {
//            if let newValue = newValue {
//                weeks[newValue.id] = newValue
//            }
//        }
//    }
//}

//Extend dictionary to provide a subscript lookup for a given date
extension Dictionary where Key == Int, Value == Week {
    subscript (for date: Date) -> Week? {
        get {
            return self[Week.weekId(for: date)]
        }

    }
}
