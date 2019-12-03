//
//  TodayDashBoard.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 20/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct DaySummary: View {
    let date: Date
    let completions: Completions
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Image(systemName: "\(date.day).square").font(.headline)
                    Text("Today").font(.caption).lineLimit(0)

                }
                Spacer()
                Text(String(completions.filterBy(date: date).count))
                    .multilineTextAlignment(.trailing)
                    .font(.title)
            }
            .modifier(ShadowPanel())
        }
            
    }
}

struct DaySummary_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(dataManager: TestDataManager())
        user.loadData()
        return DaySummary(date: Date(), completions: user.completions)
    }
}
