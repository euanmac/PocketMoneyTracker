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
                //GeometryReader () { geometry in
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Image(systemName: "\(self.date.day).square").font(.headline)
                        Text("Today").font(.caption).lineLimit(0)

                    }
                    Spacer()
                    Text(String(self.user.completions.filterBy(date: self.date).count))
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
                    Text(String(self.user.completions.filterBy(weekOfYear: self.date.weekOfYear).count)).font(.title)
                        .multilineTextAlignment(.trailing)
                }
                .modifier(ShadowPanel())
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Image(systemName: "sterlingsign.square").font(.headline)
                        Text("Week").font(.caption)
                    }
                    Spacer()
                    Text(String(self.user.earnedForWeek(date: self.date).displayCurrency())).font(.body).lineLimit(0)    
                }
            
                .modifier(ShadowPanel())
                
                    
                   //§ }// .fixedSize()
        }

        
        
        
    }
}

