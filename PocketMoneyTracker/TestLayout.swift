//
//  TestLayout.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 08/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

//
//  ContentView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 23/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct TestLayout: View {
    
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
               
                HStack {
                    VStack(alignment: .leading, spacing: nil)  {
                            Image(systemName: "calendar").font(.headline)
                            Text("Week").font(.caption)
                            
                        }
                        Spacer()
                        
                        .background(Color.blue)
                        Text(String(user.completions.filterBy(weekOfYear: Date().weekOfYear).count)).font(.title)
                         
                    }
                    .modifier(ShadowPanel())
                    
                    
                    
                
                    //ExtractedView()
                    
                
 //               NavigationView {
//                VStack {
//                    HStack(alignment: .center, spacing: 20) {
//
//                        Image(systemName: "arrowtriangle.left.circle.fill")
//                        GeometryReader {geometry in
//                            HStack() {
//
//                                ForEach(0...6 ,id: \.self) {i in
//                                    VStack{
//                                        Text(String(self.arr[i]))
//                                        Text(self.arr2[i])
//                                    }.frame(width: (geometry.size.width / CGFloat(self.arr.count+1)), height:50)
//
//                                }
//
//                            }//.frame(width: geometry.size.width, height: nil, alignment: .top)
//
//                        }
//                        Image(systemName: "arrowtriangle.right.circle.fill")
//
//                    }
//                        .background(Color.blue)
//                        .padding(.all)
//
//
//                HStack(alignment: .center, spacing: 20) {
//
//                    Image(systemName: "arrowtriangle.left.circle.fill")
//                    GeometryReader {geometry in
//                        HStack() {
//
//                            ForEach(0...6 ,id: \.self) {i in
//                                VStack{
//                                    Text(String(self.arr[i]))
//                                    Text(self.arr2[i])
//                                }.frame(width: (geometry.size.width / CGFloat(self.arr.count+1)), height:50)
//
//                            }
//
//                        }//.frame(width: geometry.size.width, height: nil, alignment: .top)
//
//                    }
//                    Image(systemName: "arrowtriangle.right.circle.fill")
//
//                }
//                    .background(Color.blue)
//                    .padding(.all)
//                }
//                            VStack {
//
//                                DayPicker(selectedDate: self.$selectedDate)
//
//                                Dashboard(date: self.selectedDate)
//                                ForEach(self.user.userTasks) {task in
//                                    TaskRow(task: task, date: self.selectedDate)
//                                }
//
//                            }
//                            .navigationBarTitle(Text(self.user.userDetails!.firstName))
//                        }
                        
//                    }
                }
            }
        }
            //.frame(width: .infinity, height: .infinity, alignment: .center)
            //.background(Color.black)
    
    
}





struct TestRow: View {
    
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

struct TestLayout_Previews: PreviewProvider {

    static var previews: some View {
        let dm = DataManager()
        let user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
        return
            Group {
                TestLayout().environmentObject(user).environment(\.colorScheme, .light)
                //TestLayout().environmentObject(user).environment(\.colorScheme, .dark)
        }
    }
}

struct ExtractedView: View {
    let arr = Array([21,22,23,24,25,26,27])
    let arr2 = Array(["M","T","W","T","F","S","S"])

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: "arrowtriangle.left.circle.fill").font(.headline)
            
            HStack {
                ForEach(0...6 ,id: \.self) {i in
                    VStack{
                        Text(String(self.arr[i]))
                        Text(self.arr2[i])
                    }.frame(maxWidth: .infinity)
                }
            }
            .frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
            Image(systemName: "arrowtriangle.right.circle.fill").font(.headline)
        }
        .padding(10)
        .background(Color.primary.colorInvert())
        .cornerRadius(10)
        .padding(.all)
        .shadow(radius: 5)
    }
}
