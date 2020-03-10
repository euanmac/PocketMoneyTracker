//
//  DashBoard.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 09/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct WeekSummary: View {
    
    @EnvironmentObject var user: User
    let date: Date
    let weekComplete: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {

            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "calendar").font(.headline)
                    Text("Week").font(.caption)
                    
                }
                Spacer()
                Text(String(user.completions.filterBy(weekOfYear: date.weekOfYear).count)).font(.title)
                    .multilineTextAlignment(.trailing)
            }
            .modifier(ShadowPanel())
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "sterlingsign.square").font(.headline)
                    Text("Week").font(.caption)
                }
                Spacer()
                Text(String(user.earnedForWeek(date: date).displayCurrency())).font(.subheadline).lineLimit(0)
            }.modifier(ShadowPanel())
            
//            if weekComplete {
//                Button("Open") {
//                     let id = Week.weekId(for: self.date)
//                     self.user.userWeeks[id] = nil
//                }
//            } else {
//                Button("Complete") {
//                    let week = Week(number: self.date.weekOfYear, year: self.date.year, base: self.user.userDetails!.base, isPaid: false, taskIds: self.user.userTasks.map{$0.id})
//                    self.user.userWeeks[week.id] = week
//                }
//            }
        }
    }

}



struct DashBoard_Previews: PreviewProvider {

    static var previews: some View {

        let user = User(dataManager: TestDataManager())
        user.loadData()
        return WeekSummary(date: Date(), weekComplete: false).environmentObject(user).previewDevice("iPhone SE")
    }
    
}
