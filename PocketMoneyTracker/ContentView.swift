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
                HStack(alignment: .top, spacing: nil) {
                    VStack(alignment: .center, spacing: 20) {
                            
                            DayPicker(selectedDate: self.$selectedDate)
                            //TestLayout()
                            Dashboard(date: self.selectedDate)
                            
                            VStack {
                                ForEach(self.user.userTasks) {task in
                                    TaskRow(task: task, date: self.selectedDate)
                                }
                            }
                            Spacer()
                    }
                    .padding(5)
                    .navigationBarTitle(Text(self.user.userDetails!.firstName))
                                       //}

                }
            }
        }

    }
    
}


struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
//        let dm = DataManager()
//        let user = User(dataManager: DataManager())
//        user.userDetails = dm.userDetails
//        user.userTasks = dm.tasks
//        user.userWeeks = dm.weeks
        
        let user = User(dataManager: DataManager())
        user.loadData()

        //let contentView = ContentView().environmentObject(user)
        return ContentView().environmentObject(user).previewDevice("iPhone SE")
    }
}
