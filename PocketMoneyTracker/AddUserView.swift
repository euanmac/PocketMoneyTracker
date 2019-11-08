//
//  AddUserView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 04/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct AddUserView: View {
    @State var showAddUser = false
    @EnvironmentObject var user: User
    
    var body: some View {
        HStack {
            Button("Setup...") {
                self.showAddUser = true
                //self.user.userDetails = UserDetails(firstName: "Will", familyName: "Mac", base: 3, email: "w@mac.com")
            }
        }.sheet(isPresented: $showAddUser) { NewUserHost()
            { newUser in
                let userDetails = UserDetails(firstName: newUser.firstname, familyName: newUser.familyName, base: Double(newUser.base) ?? 0, email: newUser.email)
                self.user.userDetails = userDetails
            }//.environmentObject(self.user)
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
