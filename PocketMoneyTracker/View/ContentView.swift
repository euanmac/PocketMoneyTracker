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

    var body: some View {
        
        switch user.loadState {
        case .loadingUser, .notLoaded:
            return AnyView(LoadingView())
        case .userDetailsLoaded, .allLoaded:
            return AnyView(SummaryView())
        case .userNotFound:
            return AnyView(AddUserView())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        
        let user = User(dataManager: TestDataManager())
        user.loadData()
        
        //let contentView = ContentView().environmentObject(user)
        return ContentView().environmentObject(user).previewDevice("iPhone SE")
    }
}
