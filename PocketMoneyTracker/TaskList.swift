//
//  TaskList.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 04/12/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct TaskList: View {
    @EnvironmentObject var user: User
    let date : Date
    
    var disableTasks: Bool {
        user.weekEditable(for: date)
    }
    
    var body: some View {
        ForEach(user.tasks(for: date)) {task in
            NavigationLink(destination: EditTaskView(editTask: task, editable: true,
                onSave: { newTask in
                    self.user.userTasks[newTask.id] = newTask
                }, onDelete: { deleteTask in
                    print(deleteTask)
            })) {
                TaskRow(
            }
            
            
        }
    }
    
    func saveTask(task: EditableTask) {
        
    }
    
    func deleteTask() {
        
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        return TaskList(date: Date())
    }
}
