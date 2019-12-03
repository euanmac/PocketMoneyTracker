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
    private struct UserFiles {
        static let completions = "completions.json"
        static let userDetails = "userdetails.json"
        static let weeks = "usertasks.json"
        static let userTasks = "weeks.json"
    }
    
    private let userDetails = UserDetails(
        firstName: "Will", familyName: "Macfarlane", base: 3, email: "wjjmac@mac.com")
    
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
        Week(number: 34, year: 2019, base: 3.0, isPaid: false, taskIds: [TestDataManager.taskIds[0],TestDataManager.taskIds[1],TestDataManager.taskIds[2]]),
        Week(number: 35, year: 2019, base: 2.5, isPaid: false, taskIds: [TestDataManager.taskIds[0],TestDataManager.taskIds[1],TestDataManager.taskIds[2]])
    ]
    
    let userDetailsPub = PassthroughSubject<UserDetails, DataManagerError>()
    let userTasksPub = PassthroughSubject<[UserTask], DataManagerError>()
    let userWeeksPub = PassthroughSubject<[Week], DataManagerError>()
    let completionsPub = PassthroughSubject<Completions, DataManagerError>()
    
    
    func loadUserDetails() {
 
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            
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
            //let completions = self.decodeFromFile(decodable: Completions.self, fileName: UserFiles.completions) ?? self.completions
            
            DispatchQueue.main.async {
                self.completionsPub.send(self.completions)
            }
        }
    }
    
    func saveTasks(userTasks: [UserTask]) {
        encodeToFile(anyCodable: userTasks, fileName: UserFiles.userTasks)
    }

    func saveWeeks(weeks: [Week]) {
        encodeToFile(anyCodable: weeks, fileName: UserFiles.weeks)
    }

    func saveCompletions(completions: Completions) {
        encodeToFile(anyCodable: completions, fileName: UserFiles.completions)
    }
    
    func saveUser(userDetails: UserDetails) {        
        encodeToFile(anyCodable: userDetails, fileName: UserFiles.userDetails)
    }
        
    private func encodeToFile<T: Codable> (anyCodable: T, fileName: String) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(anyCodable)
        let fileDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = fileDir.appendingPathComponent(fileName)

        do {
            try data.write(to: filePath)
        } catch {
            print(error)
        }
    }
    
    private func decodeFromFile<T: Codable> (decodable: T.Type, fileName: String) -> T? {
    
        let fileDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = fileDir.appendingPathComponent(fileName)
        
        //check file exists
        guard FileManager().fileExists(atPath: filePath.path) else {
            return nil
        }
    
        do {
            let jsonData = try Data(contentsOf: filePath)
            return try JSONDecoder().decode(T.self, from: jsonData)
            
        } catch {
            // contents could not be loaded
            print (error)
            return nil
        }
    }
}

//Stores user data on local file system by decoding and encoding to JSON
class LocalDataManager : DataManager {

    private struct UserFiles {
        static let completions = "completions.json"
        static let userDetails = "userdetails.json"
        static let userTasks = "usertasks.json"
    }
    
    let userDetailsPub = PassthroughSubject<UserDetails, DataManagerError>()
    let userTasksPub = PassthroughSubject<[UserTask], DataManagerError>()
    let userWeeksPub = PassthroughSubject<[Week], DataManagerError>()
    let completionsPub = PassthroughSubject<Completions, DataManagerError>()
    
    
    func loadUserDetails() {
 
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            //TODO - need to be able to pass back error if user cannot be loaded
            DispatchQueue.main.async {
                if let userDetails = self.decodeFromFile(decodable: UserDetails.self, fileName: UserFiles.userDetails) {
                    self.userDetailsPub.send(userDetails)
                } else {
                    self.userDetailsPub.send(completion: .failure(DataManagerError.userNotFoundError))
                }
            }
        }
    }
    
    func loadTasks() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            //If cant load then create empty array or handle error scenario
            let tasks = self.decodeFromFile(decodable: [UserTask].self, fileName: UserFiles.userTasks) ?? [UserTask]()
            DispatchQueue.main.async {
                self.userTasksPub.send(tasks)
            }
        }
    }
    
    func loadWeeks() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            //If cant load then create empty array or handle error scenario
//            let completions = self.decodeFromFile(decodable: Completions.self, fileName: UserFiles.completions) ?? Completions()
//            DispatchQueue.main.async {
//                self.userWeeksPub.send(Completions)
//            }
        }

    }
    
    func loadCompletions() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            //If cant load then create empty array or handle error scenario
            let completions = self.decodeFromFile(decodable: Completions.self, fileName: UserFiles.completions) ?? Completions()
            DispatchQueue.main.async {
                    self.completionsPub.send(completions)
            }
        }
    }
    
    func saveTasks(userTasks: [UserTask]) {
        encodeToFile(anyCodable: userTasks, fileName: UserFiles.userTasks)
    }

    func saveWeeks(weeks: [Week]) {
        //encodeToFile(anyCodable: weeks, fileName: UserFiles.weeks)
    }

    func saveCompletions(completions: Completions) {
        encodeToFile(anyCodable: completions, fileName: UserFiles.completions)
    }
    
    func saveUser(userDetails: UserDetails) {
        encodeToFile(anyCodable: userDetails, fileName: UserFiles.userDetails)
    }
        
    private func encodeToFile<T: Codable> (anyCodable: T, fileName: String) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(anyCodable)
        let fileDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = fileDir.appendingPathComponent(fileName)
        print("Encode to: " + filePath.absoluteString)
        do {
            try data.write(to: filePath)
        } catch {
            print(error)
        }
    }
    
    private func decodeFromFile<T: Codable> (decodable: T.Type, fileName: String) -> T? {
    
        let fileDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = fileDir.appendingPathComponent(fileName)
        print("Decode from: " + filePath.absoluteString)
        
        //check file exists
        guard FileManager().fileExists(atPath: filePath.path) else {
            print("Not found:" + fileName)
            return nil
        }
    
        do {
            let jsonData = try Data(contentsOf: filePath)
            return try JSONDecoder().decode(T.self, from: jsonData)
            
            
        } catch {
            // contents could not be loaded
            print (error)
            return nil
        }
    }
}

