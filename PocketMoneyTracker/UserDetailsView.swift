//
//  UserDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct UserDetailsView: View {
    @Binding var userDetails: UserDetails

    var body: some View {
        ZStack {
            Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("First Name").font(.caption)
                    Spacer()
                    TextField("First Name", text: $userDetails.firstName).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Text("First Name").font(.caption)
                    Spacer()
                    TextField("Last Name", text: $userDetails.familyName).background(Color(UIColor.systemGray4))
                }
                HStack {
                   Text("First Name").font(.caption)
                   Spacer()
                   TextField("Last Name", text: $userDetails.familyName).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Text("First Name").font(.caption)
                    Spacer()
                    TextField("Email", text: $userDetails.email).background(Color(UIColor.systemGray4))
                }
                
                
            }.padding()
        }
        
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        var userDetails = UserDetails(firstName: "Will", familyName: "Macfarlane", base: 3.0, email: "w@mac.com")
        return Group {
            UserDetailsView(userDetails: .constant(userDetails)).environment(\.colorScheme, .dark)
            UserDetailsView(userDetails: .constant(userDetails)).environment(\.colorScheme, .light)
        }
    }
}
