//
//  Completions.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 15/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation

struct TaskCompletion: Identifiable, Codable {
    let id: UUID
    let taskId: UUID
    //var approverId: String? = nil
    let date: Date
    let paid: Bool
    
    init(on date: Date, taskId: UUID) {
        self.date = date
        self.taskId = taskId
        self.id = UUID()
        self.paid = false
    }
    
    init(taskId: UUID) {
        self.init(on: Calendar.current.startOfDay(for: Date()), taskId: taskId)
    }
}

struct Completions: Codable {
    typealias CompletionIndex = (TaskCompletion, Int)
    private var completions : [TaskCompletion]
    
    private init (completions: [TaskCompletion]) {
        self.completions = completions
    }
    
    public var count: Int {
        return completions.count
    }
    
    init() {
        completions = [TaskCompletion]()
    }
    
    mutating func append(completion: TaskCompletion) {
        completions.append(completion)
    }
    
    mutating func remove(completion: TaskCompletion) {
        if let id = completions.firstIndex(where: { $0.id == completion.id }) {
            completions.remove(at: id)
        }
    }
    
    mutating func removeLast(taskId: UUID, date: Date) {
        let dateOnly = Calendar.current.dateComponents([.day, .year, .month], from: date)
        if let id = completions.lastIndex(where: { $0.taskId == taskId && Calendar.current.dateComponents([.day, .year, .month], from: $0.date) == dateOnly }) {
            completions.remove(at: id)
        }
    }
        
    private func filterBy(taskId: UUID) -> [TaskCompletion] {
        return completions.filter() {
            $0.taskId == taskId
        }
    }
    
    func filterBy(date: Date) -> [TaskCompletion] {
        let dateOnly = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return completions.filter() {
            Calendar.current.dateComponents([.day, .year, .month], from: $0.date) == dateOnly
        }
    }
    
    func filterBy(taskId: UUID, date: Date) -> [TaskCompletion] {
        let dateOnly = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return completions.filter() {
            $0.taskId == taskId && Calendar.current.dateComponents([.day, .year, .month], from: $0.date) == dateOnly
        }
    }
    
    func filterBy(taskId: UUID? = nil, weekOfYear: Int? = nil) -> [TaskCompletion] {
        //Filter completions by task Id if provided
         let completionsToFilter = taskId.map({filterBy(taskId: $0)}) ?? completions
        //If week of year provided then filter otherwise just return completions filtered by taskid
        if weekOfYear == nil {
            return completionsToFilter
        } else {
            return completionsToFilter.filter() {
                Calendar.current.component(.weekOfYear, from: $0.date) == weekOfYear
            }
        }
    }
    
    func groupedByDate() -> [DateComponents: [TaskCompletion]] {
        return  Dictionary(grouping: completions) { (task) -> DateComponents in
            return Calendar.current.dateComponents([.day, .year, .month], from: task.date)
        }
    }
    
    func groupedByWeek() -> [Int: [TaskCompletion]] {
        return  Dictionary(grouping: completions) { (task) -> Int in
            return Calendar.current.component(.weekOfYear, from: task.date)
        }
    }
    
    func groupedByTask() -> [UUID: [TaskCompletion]] {
        return  Dictionary(grouping: completions) { (task) -> UUID in
            return task.id
        }
    }
    
    
    func groupedBy(taskId: UUID) -> [UUID: [TaskCompletion]] {
        let groupCompletions = Dictionary(grouping: completions) { (task) -> UUID in
            return task.taskId
        }
        return groupCompletions
    }
}
