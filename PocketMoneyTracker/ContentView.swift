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
            Color(UIColor.tertiarySystemBackground).edgesIgnoringSafeArea(.all)
            
            if (user.userDetails == nil) {
                HStack {
                    Text("Loading")
                }
            } else {

                NavigationView {
                    HStack(alignment: .top, spacing: nil) {
                        VStack(alignment: .leading, spacing: 10) {
                                
                                DayPicker(selectedDate: self.$selectedDate)
                                
                                Text("Summary").font(.headline)
                                Dashboard(date: self.selectedDate)
                                
                                Text("Tasks").font(.headline)
                                VStack {
                                        ForEach(self.user.userTasks) {task in
                                            NavigationLink(destination: Text("Hello")) {
                                                    TaskRow(task: task, date: self.selectedDate).navigationBarHidden(false)
                                            }
                                            
                                        }
                                }
                                Spacer()
                        }.padding(5)
                    }
                    .navigationBarTitle(Text(self.user.userDetails!.firstName))
                    .navigationBarItems(trailing: Button(action: {print("button pressed")}, label: {Image(systemName: "person.circle")}))
                
                    
                }
                .background(Color(UIColor.tertiarySystemFill))
                    
                
            }
        }

    }
    
}


struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        
        let user = User(dataManager: LocalDataManager())
        user.loadData()
        
        //let contentView = ContentView().environmentObject(user)
        return ContentView().environmentObject(user).previewDevice("iPhone SE")
    }
}
