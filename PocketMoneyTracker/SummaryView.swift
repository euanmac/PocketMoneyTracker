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
        
    var body: some View {
        
        print("Drawing  \(user.loadState)")
        return ZStack {
            
            Color(UIColor.tertiarySystemBackground).edgesIgnoringSafeArea(.all)
        
            NavigationView {
                
                HStack(alignment: .top, spacing: nil) {
                    
                    VStack(alignment: .leading, spacing: 10) {

                        DayPicker(selectedDate: self.selectedDate, dateChanged: {newDate in self.selectedDate = newDate})
        
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

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
