//
//  TaskRow.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 09/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
    
    @EnvironmentObject var user: User
    let task: UserTask
    let date: Date
    let disabled: Bool
    
    var body: some View {
    
        return
            VStack {
                HStack {
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        
                        if task.mandatory {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.yellow)
                        }
                        Text(task.description)
                    }
                    if !task.mandatory {
                        Text(task.value.displayCurrency()).font(.caption)
                    }
                }.layoutPriority(1)
                
                Spacer()
                
                HStack {
                    
                    if !disabled {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                self.user.completions.removeLast(taskId: self.task.id, date: self.date)
                        }
                    }
                       
                    
                    Text(String(self.user.completions.filterBy(taskId: task.id, date: self.date).count))
                   
                    if !disabled {
                        Image(systemName: "checkmark.circle")
                            .onTapGesture {
                               let completion = TaskCompletion(on: self.date, taskId: self.task.id)
                               self.user.completions.append(completion: completion)
                            }
                    }
                    //NavigationLink(destination: Text("Hello")) {
                        Image(systemName: "chevron.right")
                    //
                    
                    }
            }
        }
            //.modifier(TaskPanel())
    }
}



struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(dataManager: TestDataManager())
        var task = UserTask()
        task.description = "wash car"
        return TaskRow(task: task, date: Date(), disabled: false).environmentObject(user).previewDevice("iPhone SE")
    }
}
