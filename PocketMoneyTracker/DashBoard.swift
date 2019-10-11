//
//  DashBoard.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 09/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var user: User
    let date: Date
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "\(date.day).square").font(.headline)
                    Text("Today").font(.caption).lineLimit(0)

                }
                Spacer()
                Text(String(user.completions.filterBy(date: date).count))
                    .multilineTextAlignment(.trailing)
                    .font(.title)
            }
            .modifier(ShadowPanel())
            
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
        }
    }
}

struct ShadowPanel: ViewModifier {
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

struct DashBoard_Previews: PreviewProvider {

    static var previews: some View {
//        let dm = DataManager()
//        let user = User(dataManager: DataManager())
//        user.userDetails = dm.userDetails
//        user.userTasks = dm.tasks
//        user.userWeeks = dm.weeks
        let user = User(dataManager: DataManager())
        user.loadData()
        return Dashboard(date: Date()).environmentObject(user).previewDevice("iPhone SE")
    }
    
}
