//
//  ContentView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 23/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user: User
    @State var selectedDate = Date()
    @State var completed = false
    
    var body: some View {
        ZStack {
            Color(UIColor.quaternarySystemFill).edgesIgnoringSafeArea(.all)
            if (user.userDetails == nil) {
                HStack {
                    Text("Loading")
                }
            } else {

                //NavigationView {
                    //GeometryReader { geometry in
                        
                        //VStack {
                           
//                            Text("Text1")
//                                .frame(width: geometry.size.width, height: nil, alignment: .topLeading).background(Color.red)
////                                .padding(5)
////                                .background(Color.gray).opacity(25)
////                                .cornerRadius(10)
//                            Text("Text2")
//                                .padding(5)
//                                .background(Color.gray).opacity(25)
//                                .cornerRadius(10)
//                            Text("Text2")
//                                .padding(5)
//                                .background(Color.gray).opacity(25)
//                                .cornerRadius(10)
                            
                VStack(alignment: .center, spacing: 20) {
                                
                                DayPicker(selectedDate: self.$selectedDate)
                                TestLayout()
                                Dashboard(date: self.selectedDate)
                                
                                VStack {
                                    ForEach(self.user.userTasks) {task in
                                        TaskRow(task: task, date: self.selectedDate)
                                    }
                                }
                            }
                            .padding(.all)
                            .navigationBarTitle(Text(self.user.userDetails!.firstName))
                        //}
                    //}
                //}

            }
        }
            //.frame(width: .infinity, height: .infinity, alignment: .center)
            //.background(Color.black)
    }
    
}

struct Dashboard: View {
    
    @EnvironmentObject var user: User
    let date: Date
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "\(date.day).square").font(.headline)
                    Text("Today").font(.caption)

                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(String(user.completions.filterBy(date: date).count))
                    .multilineTextAlignment(.trailing)
                    .font(.headline)
            }
            .modifier(DashboardPanel())
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "calendar").font(.headline)
                    Text("Week").font(.caption)
                    
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(String(user.completions.filterBy(weekOfYear: date.weekOfYear).count)).font(.title)
                    .multilineTextAlignment(.trailing)
            }
            .modifier(DashboardPanel())
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "sterlingsign.square").font(.headline)
                    Text("Week").font(.caption)
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Text(String(user.earnedForWeek(date: date).displayCurrency())).font(.subheadline).lineLimit(0)
            }.modifier(DashboardPanel())
        }
    }
}

struct DashboardPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
            .foregroundColor(.primary)
            .padding(5)
            .background(Color.primary.colorInvert())
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct TaskRow: View {
    
    @EnvironmentObject var user: User
    let task: UserTask
    let date: Date
    
    var body: some View {
        
        
        return HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(task.description)
                    if task.mandatory {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.yellow)
                    }
                }
                if !task.mandatory {
                    Text(task.value.displayCurrency()).font(.caption)
                }
            }.layoutPriority(1)
            
            Spacer()
            
            HStack {
                Image(systemName: "checkmark.circle")
                    .onTapGesture {
                       let completion = TaskCompletion(on: self.date, taskId: self.task.id)
                       self.user.completions.append(completion: completion)
                    }
                    
                Text(String(self.user.completions.filterBy(taskId: task.id, date: self.date).count))
               
                Image(systemName: "xmark.circle")
                    .onTapGesture {
                        self.user.completions.removeLast(taskId: self.task.id, date: self.date)
                    }
            }
            
        }
            .padding(5)
            .background(Color.gray).opacity(90)
            .cornerRadius(10)
            .shadow(radius: 5)
            .foregroundColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        let dm = DataManager()
        let user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
        return ContentView().environmentObject(user).previewDevice("iPhone SE")
    }
}
