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
                        
                        DayPicker(selectedDate: self.$selectedDate)
                        .modifier(ShadowPanel())
                        
                        Text("Day")
                        DaySummary(date: self.selectedDate, completions: user.completions)
                        
                        Text("Week")
                        WeekSummary(date: self.selectedDate,  weekComplete: self.user.weekEditable(for: self.selectedDate) )
        
                        HStack {
                            Text("Tasks").font(.headline)
                        }
                        .sheet(isPresented: $showNewTask) {
                            AddTaskView(onAdd: {
                                task in self.user.userTasks.append(task)})
                        }
                        
                        ZStack(alignment: .bottom) {
                            
                            TaskList(date: selectedDate)
                                .modifier(ShadowPanel())
                        
                            HStack {
                                Spacer()
                                Button("Add Task") {self.showNewTask = true}
                                    .disabled(self.user.weekEditable(for: selectedDate))
                            }
                            .padding(15)
                            .background(Color(UIColor.systemBackground))
                            .opacity(0.9)
                            
                            
                        }
                    }.padding(5)
                }
                .navigationBarTitle(Text(self.user.userDetails!.firstName), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showEditUser = true
                    }, label: {Image(systemName: "person.circle")}))
                .navigationBarHidden(false)
                    .background(Color(UIColor.quaternarySystemFill))
               
            }
        }

        .sheet(isPresented: $showEditUser) { EditUserView(editUser: self.user.userDetails!.editableUser, editable: true)
            { newUser in
                let userDetails = UserDetails(firstName: newUser.firstName, familyName: newUser.familyName, base: Double(newUser.base) ?? 0, email: newUser.email)
                self.user.userDetails = userDetails
                print(userDetails)
            }
        }
        
    }
    

    
}


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
