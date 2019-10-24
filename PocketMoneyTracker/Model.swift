//
//  Model.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 01/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation
import Combine


struct UserDetails: Codable {
    let firstName: String
    let familyName: String
    let base: Double
    let email: String
}

struct UserTask: Identifiable, Codable {
    let id: UUID
    let description: String
    let mandatory: Bool
    let value: Double
}

struct TaskCompletion: Identifiable, Codable {
    let id: UUID
    let taskId: UUID
    var approverId: String? = nil
    let date: Date
    
    init(on date: Date, taskId: UUID) {
        self.date = date
        self.taskId = taskId
        self.id = UUID()
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
        
    func filterBy(taskId: UUID) -> [TaskCompletion] {
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
    
    func filterBy(weekOfYear: Int) -> [TaskCompletion] {
        
         return completions.filter() {
            Calendar.current.component(.weekOfYear, from: $0.date) == weekOfYear
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

struct ScheduledTask: Identifiable {
    
    let id: UUID
    var completed: Bool
    let description: String
    let mandatory: Bool
    let value: Double

    init(id: UUID, task: UserTask, completed: Bool) {
        self.id = id
        self.description = task.description
        self.mandatory = task.mandatory
        self.value = task.value
        self.completed = completed
    }
    
}

struct Week : Identifiable, Codable {

    let number: Int
    let year: Int
    let base: Double
    let id: Int
    var isComplete: Bool

    enum CodingKeys: String, CodingKey {
        case number, year, base, id, isComplete
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number = try values.decode(Int.self, forKey: .number)
        year = try values.decode(Int.self, forKey: .year)
        id  = try values.decode(Int.self, forKey: .base)
        base  = try values.decode(Double.self, forKey: .base)
        isComplete = try values.decode(Bool.self, forKey: .isComplete)

    }
    
    init (number: Int, year: Int, base: Double, isComplete: Bool) {
        self.number = number
        self.year = year
        self.base = base
        self.isComplete = isComplete
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


enum DataManagerError: Error {
    case userNotFoundError
    case loadError
    case saveError
}

protocol DataManager {
    var userDetailsPub: PassthroughSubject<UserDetails, DataManagerError> {get}
    var userTasksPub: PassthroughSubject<[UserTask], DataManagerError> {get}
    var userWeeksPub: PassthroughSubject<[Week], DataManagerError> {get}
    var completionsPub: PassthroughSubject<Completions, DataManagerError> {get}
    
    func loadUserDetails()
    func loadTasks()
    func loadWeeks()
    func loadCompletions()
    func saveUser(userDetails: UserDetails)
    func saveTasks(userTasks: [UserTask])
    func saveWeeks(weeks: [Week])
    func saveCompletions(completions: Completions)
}

class User : ObservableObject {
    
    private let dm: DataManager
    private var userDataSub: AnyCancellable?
    private var userWeeksSub: AnyCancellable?
    
    public enum LoadState {
        case notLoaded, userNotFound, userDetailsLoaded, allLoaded
    }
    
    @Published var loadState: LoadState = LoadState.notLoaded
    @Published var userWeeks = [Week]()
    @Published var userDetails: UserDetails? {
        didSet {
            if userDetails != nil {
                dm.saveUser(userDetails: userDetails!)
                loadState = .userDetailsLoaded
            }
        }
    }
    
    @Published var userTasks = [UserTask]() {
        didSet {
            dm.saveTasks(userTasks: userTasks)
        }
    }
    
    @Published var completions = Completions() {
        didSet {
            print(completions.count)
            dm.saveCompletions(completions: completions)
        }
    }
    
    init(dataManager: DataManager) {
        self.dm = dataManager
    }
    
    func loadData() {
        dm.loadUserDetails()
        dm.loadTasks()
        dm.loadCompletions()
        
        userDataSub = dm.userDetailsPub.combineLatest(dm.userTasksPub, dm.completionsPub).sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.loadState = .userNotFound
                case .finished:
                    print("finished")
                }
                
            }
            ,receiveValue: { userData in
                self.userDetails = userData.0
                self.userTasks = userData.1
                self.completions = userData.2
                print("User Details: \(self.userDetails!.firstName)")
                print("User Tasks: \(self.userTasks.count)")
                print("Completions: \(self.completions.count)")
                self.dm.loadWeeks()
            }
        )
        
        //userWeeksSub = dm.userWeeksPub.assign(to: \.userWeeks, on: self)
    }
    
    func getWeek(for date: Date) -> Week? {
        return userWeeks.first() { week in
            return (date >= week.startDate &&
                    date <= week.endDate)
        }
    }
    
    func earnedForWeek(date: Date) -> Double{
        guard let userDetails = self.userDetails else {
            return 0
        }
       
        var total: Double = 0.0
        var mandatoryCompleted = true
        
        //Get total of completions with values
        let weekCompletions = completions.filterBy(weekOfYear: date.weekOfYear)
        weekCompletions.forEach() {completion in
            
            if let task = userTasks.first(where: {$0.id == completion.taskId} ) {
                if  !task.mandatory {
                    total += task.value
                }
            }
        }
        
        //Check that mandatory tasks have at least one completion
        userTasks.forEach() {task in
            if task.mandatory {
                let count = completions.filterBy(taskId: task.id, date: date).count
                mandatoryCompleted = mandatoryCompleted && count > 0
            }
        }
        
        return total + (mandatoryCompleted ? userDetails.base : 0)
            
    }
}

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
}
