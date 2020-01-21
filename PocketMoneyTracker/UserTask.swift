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
    var description: String
    let mandatory: Bool
    let value: Double
    var image: TaskImage
    var archived: Bool = false
    
    init(id: UUID = UUID(), description: String = "", mandatory: Bool = false, value: Double = 0.0, image: TaskImage = .star) {
        self.id = id
        self.description = description
        self.mandatory = mandatory
        self.value = value
        self.image = image
    }
    
    enum TaskImage: String, Codable, CaseIterable, Identifiable  {
        case car = "car.fill"
        case bed = "bed.double"
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
        case bag = "bag.fill"
        
        var id: TaskImage {self}
    }
    
    private var validDescription: Bool {
        description.count > 0
    }
        
    private var validValue: Bool {
        (!mandatory && value >= 0) || mandatory
    }
    
    public var isValid: Bool {
        validValue && validDescription
    }
}

extension UserTask {
    var editableTask: EditableTask {
        EditableTask(description: self.description, mandatory: self.mandatory, value: String(self.value), image: self.image.rawValue, archived: self.archived)
    }
}

extension Array where Element: Identifiable & Hashable {
    func filter(ids: [Element.ID]) -> [Element] {
        return self.filter {ids.contains($0.id)}
    }
}

extension Array where Element: Identifiable & Hashable {
    subscript(id: Element.ID) -> Element? {
        get {
            return self.first {$0.id == id}
        }
        set {
            if let index = self.firstIndex(where: {$0.id == id}) {
                self[index] = newValue!
            }
        }
    }
}
