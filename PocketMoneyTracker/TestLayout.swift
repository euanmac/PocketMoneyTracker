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
    let arr = Array([11,12,13,14,15,16,17])
    let arr2 = Array(["M","T","W","T","F","S","S"])
    
    var body: some View {
        ZStack {
            Color.black
            if (user.userDetails == nil) {
                HStack {
                    Text("Loading")
                }
            } else {

                NavigationView {
                    
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "arrowtriangle.left.circle.fill")
                        GeometryReader {geometry in
                            HStack() {
                                
                                ForEach(0...6 ,id: \.self) {i in
                                    VStack{
                                        Text(String(self.arr[i]))
                                        Text(self.arr2[i])
                                    }.frame(width: (geometry.size.width / CGFloat(self.arr.count+1)), height: geometry.size.height)
                                }
                                
                            }//.frame(width: geometry.size.width, height: nil, alignment: .top)
                                
                        }
                        Image(systemName: "arrowtriangle.right.circle.fill")
                    }
                    //.frame(width: nil, height: nil, alignment: .top)
                        .padding(.all)
                    //GeometryReader { geometry in
//                    HStack(alignment: .top, spacing: 10) {
//
////                            Text("Text1")
////                                .frame(width: geometry.size.width, height: nil, alignment: .topLeading).background(Color.red)
//
////                            Text("Text2")
////                                .padding(5)
////                                .background(Color.gray).opacity(25)
////                                .cornerRadius(10)
////                            Text("Text2")
////                                .padding(5)
////                                .background(Color.gray).opacity(25)
////                                .cornerRadius(10)
//
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
                        
                    }
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
        return TestLayout().environmentObject(user).previewDevice("iPhone SE")
    }
}
