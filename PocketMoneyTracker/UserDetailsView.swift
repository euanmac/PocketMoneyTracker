//
//  UserDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

typealias EditableUser = (firstname: String, familyName: String, base: String, email: String)

struct UserDetailsView: View {

    @State var editUser: EditableUser
    var cancel: () -> Void
    var save: (EditableUser) -> Void
   
    var body: some View {
        ZStack {
            Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("First Name").font(.caption)
                    Spacer()
                    TextField("First Name", text: $editUser.firstname)
                        .background(Color(UIColor.systemGray4))
                        
                }
                HStack {
                    Text("Family Name").font(.caption)
                    Spacer()
                    TextField("Family Name", text: $editUser.familyName).background(Color(UIColor.systemGray4))
                }
                HStack {
                   Text("Pocket Money").font(.caption)
                   Spacer()
                   TextField("Pocket Money", text: $editUser.base).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Text("Email").font(.caption)
                    Spacer()
                    TextField("Email", text: $editUser.email).background(Color(UIColor.systemGray4))
                }
                HStack {
                    Button(action: {
                        self.cancel() }
                        , label: {Text("Cancel")}
                    )
                    
                    Button(action: {
                        self.save(self.editUser)}
                        , label: {Text("Done")}
                    )
                    .disabled(!validFirstName)
                    
                }
                
            }.padding()
        }
        
    }
    
    
    private var validFirstName: Bool {
        editUser.firstname.count > 0
    }
    
    private var validFamilyName: Bool {
        editUser.firstname.count > 0
    }
    
}

struct NewUserHost: View {

    //@EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    let newUser = EditableUser("", familyName: "", base: "", email: "")
    let onSave: (EditableUser)->Void
    
    var body: some View {
        
        HStack {
//            UserDetailsView(editUser: self.newUser,
//                            cancel: {self.presentationMode.wrappedValue.dismiss() },
//                            save: { newUser in
//                                let userDetails = UserDetails(firstName: newUser.firstname, familyName: newUser.familyName, base: Double(newUser.base) ?? 0, email: newUser.email)
//                                self.user.userDetails = userDetails
//                                self.presentationMode.wrappedValue.dismiss()
//
//            })
            Button("Done") {
                //let editableUser = UserDetails(firstName: "Will", familyName: "Mac", base: 3, email: "w@mac.com")
                let editableUser = EditableUser("Will", "Mac", "3", "w@mac.com")
                self.onSave(editableUser)
                //self.user.loadState = .userDetailsLoaded
                
            }
        }.onDisappear() {print("Hello")}
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    
    @State static var showUserDetails: Bool = false
    static var previews: some View {
        
        let user = User(dataManager: LocalDataManager())
        user.loadData()
        
        return HStack {
            Text(user.userDetails?.firstName ?? "")
            Button(action: {self.showUserDetails = true}, label: {Text("Add")})

        }
    }
}
