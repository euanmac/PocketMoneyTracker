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
         
        GeometryReader() {outer in
        
            ZStack {
                Color(UIColor.green).edgesIgnoringSafeArea(.all)
                NavigationView {
                    
                    HStack(alignment: .top, spacing: nil) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text(self.selectedDate.full)
                                .font(.headline)
                            
                            DayPicker(selectedDate: self.$selectedDate)
                            .modifier(ShadowPanel())
                            
                            HStack {
                                StatsView(date: self.selectedDate)
                                
                                //Complete week button
                                ToggleButton(isOn: self.currentWeekComplete, onSystemImage: "lock.fill", offSystemImage: "lock.open.fill", action: self.completeWeek)
                                    .disabled(self.currentWeekPaid)
                                
                                //Mark as paid
                                ToggleButton(isOn: self.currentWeekPaid, onSystemImage: "checkmark.seal.fill", offSystemImage: "sterlingsign.square", action: self.markWeekAsPaid)
                                    .disabled(!self.currentWeekComplete)
                                            
                            }
                        
                    
                            HStack {
                                Text("Tasks").font(.headline)
                            }
                            .sheet(isPresented: self.$showNewTask) {
                                AddTaskView(onAdd: {
                                    task in self.user.userTasks.append(task)})
                            }
                            
                            ZStack(alignment: .bottom) {
                                
                                TaskList(date: self.selectedDate)
                                    .modifier(ShadowPanel())
                            
                                HStack {
                                    Spacer()
                                    Button("Add Task") {self.showNewTask = true}
                                        .disabled(self.user.weekEditable(for: self.selectedDate))
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

            .sheet(isPresented: self.$showEditUser) { EditUserView(editUser: self.user.userDetails!.editableUser, editable: true)
                { newUser in
                    let userDetails = UserDetails(firstName: newUser.firstName, familyName: newUser.familyName, base: Double(newUser.base) ?? 0, email: newUser.email)
                    self.user.userDetails = userDetails
                    print(userDetails)
                }
            }
        }
    }

    private var currentWeekComplete: Bool {
        user.userWeeks[for: selectedDate] != nil
    }

    private var currentWeekPaid: Bool {
       user.userWeeks[for: selectedDate]?.isPaid ?? false
    }

    private func completeWeek(isComplete: Bool) {

        if !isComplete {
           //Clear out week
           let id = Week.weekId(for: selectedDate)
           self.user.userWeeks[id] = nil

        } else {
           //Add new week in
           let week = Week(date: selectedDate, base: user.userDetails!.base, isPaid: false, taskIds: user.userTasks.map{$0.id})
           user.userWeeks[week.id] = week
        }
    }
    
    private func markWeekAsPaid(isPaid: Bool) {
        user.userWeeks[for: selectedDate]?.isPaid = isPaid
    }
    
    
}
    

    


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

