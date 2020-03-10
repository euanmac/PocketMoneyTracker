//
//  Model.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 01/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation
import Combine

struct UserDetails: Codable, Equatable {
    let firstName: String
    let familyName: String
    let base: Double
    let email: String
}

extension UserDetails {
    var editableUser: EditableUser {
        get {
            return EditableUser(
                firstName: self.firstName, familyName: self.familyName, base: String(self.base), email: self.email)
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
    
    var objectWillChange = PassthroughSubject<Void,Never>()
    
    public enum LoadState {
        case notLoaded, loadingUser, userNotFound, userDetailsLoaded, allLoaded
    }
   
    var loadState: LoadState = LoadState.notLoaded {
        willSet {
            objectWillChange.send()
        }
    }
    
    var userTasks = [UserTask]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var completions = Completions() {
        willSet {
             objectWillChange.send()
         }
    }
    
    var userWeeks = Weeks() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var userDetails: UserDetails? {
        willSet(newValue) {
            if userDetails != newValue {
                DispatchQueue.main.async {
                    self.loadState = .userDetailsLoaded
                }
            }
        }
    }

//
//    @Published var userTasks = [UserTask]() {
//        didSet {
//            dm.saveTasks(userTasks: userTasks)
//        }
//    }
//
//    @Published var completions = Completions() {
//        didSet {
//            print(completions.count)
//            dm.saveCompletions(completions: completions)
//        }
//    }
//
    init(dataManager: DataManager) {
        self.dm = dataManager
    }
    
    func loadData() {
        
        self.loadState = .loadingUser
        
        dm.loadUserDetails()
        dm.loadTasks()
        dm.loadCompletions()
        
        userDataSub = dm.userDetailsPub.combineLatest(dm.userTasksPub, dm.completionsPub).receive(on: RunLoop.main).sink(
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
                self.loadState = .allLoaded
                self.dm.loadWeeks()
            }
        )
        
        //userWeeksSub = dm.userWeeksPub.assign(to: \.userWeeks, on: self)
    }
        
    //Returns a list of tasks for a given date. First checks for a week being complete and if so gets those tasks
    //otherwise it returns the generic user tasks (with archived tasks filtered out)
    func tasks(for date: Date) -> [UserTask] {
        
        if let week = userWeeks[for: date] {
            return userTasks.filter(ids: week.taskIds)
        } else {
            return userTasks.filter({$0.archived == false || completions.filterBy(taskId: $0.id, weekOfYear: date.weekOfYear).count > 0})
        }
        
    }
    
    //Determines whether a task can be deleted. If no completions then it can
    func taskDeletable(taskId: UUID) -> Bool {
        return (completions.filterBy(taskId: taskId).count > 0)
    }
    
//    //Checks whether there is a week completed for current date
//    func weekEditable(for date: Date) -> Bool {
//        return userWeeks[for: date] != nil
//    }
    
    func earnedForWeek(date: Date) -> Double{
        guard let userDetails = self.userDetails else {
            return 0
        }
       
        var total: Double = 0.0
        var mandatoryCompleted = true
        
        //Check whether week completed - if so take the tasks and base from there rather than user
        let base = userWeeks[for: date].flatMap {$0.base} ?? userDetails.base
        
        //If week completed then filter the tasks based on the task ids saved for the week, otherwise just use the user tasks
        let tasks = userWeeks[for: date].flatMap {userTasks.filter(ids: $0.taskIds)} ?? userTasks
        
        //Get total of completions with values
        let weekCompletions = completions.filterBy(weekOfYear: date.weekOfYear)
        weekCompletions.forEach() {completion in
            
            if let task = tasks.first(where: {$0.id == completion.taskId} ) {
                if  !task.mandatory {
                    total += task.value
                }
            }
        }
        
        //Check that mandatory tasks have at least one completion.
        //Need to use tasks stored against weeks if the week is completed.
        //This is in case any tasks have changed since that point in time
        tasks.forEach() {task in
            if task.mandatory {
                let count = completions.filterBy(taskId: task.id, date: date).count
                mandatoryCompleted = mandatoryCompleted && count > 0
            }
        }
        
        return total + (mandatoryCompleted ? base : 0)
            
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
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}


//struct ScheduledTask: Identifiable {
//
//    let id: UUID
//    var completed: Bool
//    let description: String
//    let mandatory: Bool
//    let value: Double
//
//    init(id: UUID, task: UserTask, completed: Bool) {
//        self.id = id
//        self.description = task.description
//        self.mandatory = task.mandatory
//        self.value = task.value
//        self.completed = completed
//    }
//
//}
