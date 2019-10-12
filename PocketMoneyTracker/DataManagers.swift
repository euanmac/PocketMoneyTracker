//
//  DataManagers.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 11/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation
import Combine

class TestDataManager : DataManager {

    private static let taskIds = [UUID(),UUID(),UUID(),UUID()]
    
    private let userDetails = UserDetails(
        firstName: "Will", familyName: "Macfarlane", base: 3)
    
    private let tasks = [
        UserTask(id: TestDataManager.taskIds[0], description: "Empty dishwasher", mandatory: true, value: 0),
        UserTask(id: TestDataManager.taskIds[1], description: "Make bed", mandatory: false, value: 2),
        UserTask(id: TestDataManager.taskIds[2], description: "Clear plates", mandatory: true, value: 3),
        UserTask(id: TestDataManager.taskIds[3], description: "Clean car", mandatory: true, value: 4)
    ]
    private var completions: Completions = {
        var completions = Completions()
        completions.append(completion:
            TaskCompletion(on: Date(), taskId: TestDataManager.taskIds[1]))
        return completions
    }()
    
    private let weeks = [
        Week(number: 34, year: 2019, base: 3, isComplete: false),
        Week(number: 35, year: 2019, base: 2.5, isComplete: false),
    ]
    
    let userDetailsPub = PassthroughSubject<UserDetails, Never>()
    let userTasksPub = PassthroughSubject<[UserTask], Never>()
    let userWeeksPub = PassthroughSubject<[Week], Never>()
    let completionsPub = PassthroughSubject<Completions, Never>()
    
    
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
    
    func loadWeeks() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            DispatchQueue.main.async {
                self.userWeeksPub.send(self.weeks)
            }
        }

    }
    
    func loadCompletions() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
                DispatchQueue.main.async {
                    self.completionsPub.send(self.completions)
            }
        }
    }
    
    func saveTasks(userTasks: [UserTask]) {
      
    }

    func saveWeeks(weeks: [Week]) {

    }

    func saveCompletions(completions: Completions) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(completions)
        let fileDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let completionsFile = fileDir.appendingPathComponent("completions.json")
        print(completionsFile.absoluteURL)
        do {
            try data.write(to: completionsFile)
        } catch {
            print(error)
        }
        
        
    }
    
    func saveUser(userDetails: UserDetails) {        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(userDetails)
        print(String(data: data, encoding: .utf8))
    }
    
    func saveTasks() {
        
    }
    
    func saveWeeks() {
        
    }
    
    func saveCompletions() {
        
    }
}
