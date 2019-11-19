//
//  PocketMoneySummaryView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 05/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var user: User
    @State var selectedDate = Date()
    @State var showEditUser: Bool = false
    @State var showNewTask: Bool = false
    
    var body: some View {
        
        print("Drawing  \(user.loadState)")
        return ZStack {
            
            Color(UIColor.green).edgesIgnoringSafeArea(.all)
        
            NavigationView {
                
                HStack(alignment: .top, spacing: nil) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(self.selectedDate.full)
                            .font(.headline)
                        
                        DayPicker(selectedDate: self.selectedDate, dateChanged: {newDate in self.selectedDate = newDate})
                        .modifier(ShadowPanel())
                        
                        Text("Summary").font(.headline)
                        
                        Dashboard(date: self.selectedDate)
        
                        HStack {
                            Text("Tasks").font(.headline)
                            Spacer()
                            Button(action: { self.showNewTask = true
                            }, label: {Image(systemName: "square.and.pencil")})
                                
                            }
                        VStack {
                            ForEach(self.user.userTasks) {task in
                                NavigationLink(destination: Text("Hello")) {
                                    TaskRow(task: task, date: self.selectedDate).navigationBarHidden(false)
                                }
                            }
                        }
                        .modifier(ShadowPanel())
                        .sheet(isPresented: $showNewTask) { EditTaskView(editTask: EditableTask("",false,""), onSave:
                            { editedTask in
                                let task = UserTask(id: UUID(), description: editedTask.description, mandatory: editedTask.mandatory,  value: Double(editedTask.value) ?? 0)
                                self.user.userTasks.append(task)
                        }, onDelete: nil, canDelete: true)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button("Add Task") {self.showNewTask = true}
                        }.padding(10)
                    }.padding(5)
                }
                .navigationBarTitle(Text(self.user.userDetails!.firstName), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showEditUser = true
                    }, label: {Image(systemName: "person.circle")}))
                .navigationBarHidden(false)
                    .background(Color(UIColor.quaternarySystemFill))
                //.edgesIgnoringSafeArea([.top, .bottom])

            }
                

            .background(Color(UIColor.blue))
        }
        //.accentColor(Color.)
        .sheet(isPresented: $showEditUser) { EditUserView(editUser: self.user.userDetails!.editableUser)
            { newUser in
                let userDetails = UserDetails(firstName: newUser.firstName, familyName: newUser.familyName, base: Double(newUser.base) ?? 0, email: newUser.email)
                self.user.userDetails = userDetails
                print(userDetails)
            }
        }.background(Color(UIColor.yellow))

        
    }
    
}


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
