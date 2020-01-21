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
    @State var showEditTask = false
    
    var body: some View {
    
        return
            //VStack {
                HStack {
                
                    Image(systemName: task.image.rawValue)
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                                                    
                            Text(task.description).font(.callout)
                        }
                            if !task.mandatory {
                                Text(task.value.displayCurrency()).foregroundColor(.secondary).font(.caption)
                            } else {
                                if (taskCompleteForWeek) {
                                    
                                    Text("Done For Week").font(.caption)
                                        .padding(.horizontal, 3)
                                        .foregroundColor(.white)
                                        .background(Color.secondary )
                                        .cornerRadius(5)
                                } else {
                                    Text("To Be Done").font(.caption)
                                        .padding(.horizontal, 3)
                                        .foregroundColor(.white)
                                        .background(Color.yellow)
                                        .cornerRadius(5)
                                }
                                
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

                }
                
                HStack {
                    Image(systemName: "chevron.right").font(.headline).padding(5)
                }
                
            //}
        }.sheet(isPresented: self.$showEditTask) {
            EditTaskView(editTask: self.task, editable: true, archivable: self.canArchive,
                            onSave: { saveTask in
                                self.user.userTasks[saveTask.id] = saveTask
                            }, onDelete: { deleteTask in
                                print(deleteTask)
                            })
        }
        .onTapGesture {
            self.showEditTask = true
        }
        
    }
    
    var canArchive: Bool {
        user.completions.filterBy(weekOfYear: date.weekOfYear).filter({$0.id == self.task.id}).count == 0
    }
    
    var taskCompleteForWeek: Bool {
        self.user.completions.filterBy(taskId: task.id, weekOfYear: self.date.weekOfYear).count > 0
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
