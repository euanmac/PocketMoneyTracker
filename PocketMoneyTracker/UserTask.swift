//
//  Task.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 22/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation

struct UserTask: Identifiable, Codable, Hashable {
    let id: UUID
    let description: String
    let mandatory: Bool
    let value: Double
    
    enum taskImage: String, Codable  {
        case car = "car.fill"
        case bed = "bed.fill"
        case house = "house.fill"
        case bin = "trash.fill"
        case hammer = "hammer.fill"
        case wand = "wand.and.stars"
        case heart = "heart.fill"
        case star = "star.fill"
        case thumbsup = "hand.thumbsup.fill"
        case flag = "flag.fill"
        case document = "doc.text.fill"
        case gift = "gift.fill"
    }
}

extension Array where Element: Identifiable & Hashable {
    func filter(ids: [Element.ID]) -> [Element] {
        return self.filter {ids.contains($0.id)}
    }
}
