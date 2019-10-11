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
    var firstName: String {
        willSet(name) {
            print(name)
        }
    }
    var familyName: String
    var base: Double
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
    
    var tasks: [ScheduledTask]
    private var earnedBase: Double
    private var earnedExtra: Double
    
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
        
        tasks = [ScheduledTask]()
        earnedBase = 0
        earnedExtra = 0
    }
    
    init (number: Int, year: Int, base: Double, isComplete: Bool, tasks: [ScheduledTask]) {
        self.number = number
        self.year = year
        self.base = base
        self.tasks = tasks
        self.isComplete = isComplete
        self.id = Int(String(self.year) + String(self.number))!

        
        //Calculations - earned base is 0 unless all mandatory task are completed
        earnedBase = (tasks.reduce(true) {$0 && ($1.mandatory ? $1.completed : true)}) ? self.base : 0.0
        
        //Calcation - earned non mandatory
        earnedExtra = tasks.reduce(0) {$0 + (!$1.mandatory && $1.completed ? $1.value : 0.0)}
        print(earnedExtra)
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
    
    var earned: Double {
        return earnedBase + earnedExtra
    }
}

extension Week : CustomStringConvertible {
    var description: String {
        get {
            var output = "ID: \(String(self.id))"
            self.tasks.forEach() {
                task in
                    output += "\(task.description) : \(task.completed) \n"
            }
            return output
        }
    }
}


class TestDataManager : DataManager {
    private static let taskIds = [UUID(),UUID(),UUID(),UUID()]
    
    let userDetailsPub = PassthroughSubject<UserDetails, Never>()
    let userTasksPub = PassthroughSubject<[UserTask], Never>()
    let userWeeksPub = PassthroughSubject<[Week], Never>()
    
    var userDetails: UserDetails
    var weeks: [Week]
    var tasks: [UserTask]
    
    init() {
        userDetails = UserDetails(firstName: "Will", familyName: "Macfarlane", base: 3)
        
        tasks = [
            UserTask(id: DataManager.taskIds[0], description: "Empty dishwasher", mandatory: true, value: 0),
            UserTask(id: DataManager.taskIds[1], description: "Make bed", mandatory: false, value: 2),
            UserTask(id: DataManager.taskIds[2], description: "Clear plates", mandatory: true, value: 3),
            UserTask(id: DataManager.taskIds[3], description: "Clean car", mandatory: true, value: 4)
        ]
        
        weeks = [
            Week(number: 34, year: 2019, base: 3, isComplete: false, tasks: [
                ScheduledTask(id: UUID(), task: tasks[0], completed: true),
                ScheduledTask(id: UUID(), task: tasks[1], completed: true),
                ScheduledTask(id: UUID(), task: tasks[2], completed: true)
            ]),
            Week(number: 35, year: 2019, base: 2.5, isComplete: false, tasks: [
                ScheduledTask(id: UUID(), task: tasks[1], completed: true),
                ScheduledTask(id: UUID(), task: tasks[2], completed: true),
                ScheduledTask(id: UUID(), task: tasks[3], completed: false)
            ])
        ]
    }
    
    func loadUserDetails() {
 
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            
            DispatchQueue.main.async {
                self.userDetailsPub.send(self.userDetails)
            }
        }
    }
    
    func loadTasks() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            DispatchQueue.main.async {
                self.userTasksPub.send(self.tasks)
            }
        }
    }
    
//    func loadWeeks(tasks: [UserTask]) {
//        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
//            DispatchQueue.main.async {
//                self.userWeeksPub.send(self.weeks)
//            }
//        }
//
//    }
    
    func saveUserDetails() {
        
    }
    
    func saveTasks() {
        
    }
    
    func saveWeeks() {
        
    }
}

protocol DataManager {
    var userDetailsPub: PassthroughSubject<UserDetails, Never> {get}
    var userTasksPub: PassthroughSubject<[UserTask], Never> {get}
    var userWeeksPub: PassthroughSubject<[Week], Never> {get}
    func loadUserDetails()
    func loadTasks()
    func loadWeeks()
    func saveUserDetails()
    func saveTasks()
    func saveWeeks()
}

class User : ObservableObject, Codable {
    
    let dm: DataManager
    
    @Published var userWeeks = [Week]()
    @Published var userDetails: UserDetails?
    @Published var userTasks = [UserTask]()
    @Published var completions = Completions() {
        didSet {
            print(completions.count)
            let encoder = JSONEncoder()
            let data = try! encoder.encode(self)
            let string = String(data: data, encoding: .utf8)
            print(string)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case userWeeks, userDetails, userTasks, completions
    }
    
    var userDataSub: AnyCancellable?
    var userWeeksSub: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dm = dataManager
    }
    
    //Decode
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userDetails = try values.decode(UserDetails.self, forKey: .userDetails)
        userWeeks = try values.decode([Week].self, forKey: .userWeeks)
        userTasks = try values.decode([UserTask].self, forKey: .userTasks)
        completions = try values.decode(Completions.self, forKey: .completions)
        self.dm = DataManager()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userDetails, forKey: .userDetails)
        try container.encode(userWeeks, forKey: .userWeeks)
        try container.encode(userTasks, forKey: .userTasks)
        try container.encode(completions, forKey: .completions)
    }
    
    func loadData() {
        dm.loadUserDetails()
        dm.loadTasks()
      
        userDataSub = dm.userDetailsPub.combineLatest(dm.userTasksPub).sink() { userData in
                self.userDetails = userData.0
                self.userTasks = userData.1
                print("User Tasks: \(self.userTasks.count)")
                print("User Details: \(self.userDetails!.firstName)")
                self.dm.loadWeeks(tasks: self.userTasks)
        }
        
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
