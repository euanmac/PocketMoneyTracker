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
    @State var showEditTask: Bool = false
    let date : Date
    var editTask: UserTask?
    
    var weekEditable: Bool {
        user.userWeeks.weekIsComplete(for: date)
    }
    
    var body: some View {
        List {
            ForEach(user.tasks(for: date)) {task in

                TaskRow(task: task, date: self.date, disabled: self.weekEditable)
                    
            }
        }
        .listRowInsets(.none)
        .background(Color(UIColor.quaternarySystemFill))
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
