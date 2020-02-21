//
//  StatsView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/02/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct StatsView: View {
    let date: Date
    @EnvironmentObject var user: User
    
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
                Text(String(user.earnedForWeek(date: date).displayCurrency())).font(.body).lineLimit(0)
            }.modifier(ShadowPanel())
            

        }
        
        
        
        
        
    }
}

