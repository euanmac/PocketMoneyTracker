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
    
    var body: some View {
        
        
        return HStack {
            
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
                
                Image(systemName: "xmark.circle")
                    .onTapGesture {
                        self.user.completions.removeLast(taskId: self.task.id, date: self.date)
                    }
                    
                Text(String(self.user.completions.filterBy(taskId: task.id, date: self.date).count))
               
                Image(systemName: "checkmark.circle")
                    .onTapGesture {
                       let completion = TaskCompletion(on: self.date, taskId: self.task.id)
                       self.user.completions.append(completion: completion)
                    }
                

                //NavigationLink(destination: Text("Hello")) {
                    Image(systemName: "chevron.right")
                //}
            }
            
        }
            .modifier(TaskPanel())
    }
}

struct TaskPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
            .foregroundColor(.primary)
            .padding(5)
            .background(Color.primary.colorInvert())
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(dataManager: TestDataManager())
        return TaskRow(task: user.userTasks[0], date: Date()).environmentObject(user).previewDevice("iPhone SE")
    }
}
