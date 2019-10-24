//
//  UserDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

typealias UserSetup = (firstname: String, familyName: String, base: String, email: String)

struct UserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    //@Binding var userDetails: UserDetails
    @Binding var userSetup: UserSetup
    @Binding var save: Bool
    
    var saveDetails: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("First Name").font(.caption)
                    Spacer()
                    TextField("First Name", text: $userSetup.firstname)
                        .background(Color(UIColor.systemGray4))
                        
                }
                HStack {
                    Text("Family Name").font(.caption)
                    Spacer()
                    TextField("Family Name", text: $userSetup.familyName).background(Color(UIColor.systemGray4))
                }
                HStack {
                   Text("Pocket Money").font(.caption)
                   Spacer()
                   TextField("Pocket Money", text: $userSetup.base).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Text("Email").font(.caption)
                    Spacer()
                    TextField("Email", text: $userSetup.email).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Button(action: {
                        self.save = false
                        self.presentationMode.wrappedValue.dismiss() }
                        , label: {Text("Cancel")}
                    )
                    .disabled(!validFirstName)
                    
                    Button(action: {
                        self.save = true
                        self.presentationMode.wrappedValue.dismiss() }
                        , label: {Text("Done")}
                    )
                    .disabled(!validFirstName)
                    
                }
                
            }.padding()
        }
        
    }
    
    //Save details
//    private func updateUserDetails() {
//        userDetails.firstName = firstName
//        userDetails.familyName = familyName
//        userDetails.base = base
//        userDetails.email = email
//    }
    
    private var validFirstName: Bool {
        userSetup.firstname.count > 0
    }
    
    private var validFamilyName: Bool {
        userSetup.firstname.count > 0
    }
    
}

struct NewUserView: View {
    //@EnvironmentObject var user: User
    @State var showUserDetails: Bool = false
    @State var userDetails = UserSetup("Will", familyName: "Macfarlane", base: "3.0", email: "w@mac.com")
    @State var saveDetails = false
    
    var body: some View {
        
        HStack {
            Text(userDetails.0)
            Button(action: {self.showUserDetails = true}, label: {Text("Done")})
        }
        .sheet(isPresented: $showUserDetails) {
            UserDetailsView(userSetup: self.$userDetails, save: self.$saveDetails)
        }.onDisappear(perform:
            {print(self.saveDetails)})
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //var userDetails = UserDetails(firstName: "Will", familyName: "Macfarlane", base: 3.0, email: "w@mac.com")
        return Group {
            NewUserView().environment(\.colorScheme, .dark)
            //NewUserView().environment(\.colorScheme, .light)
        }
    }
}
