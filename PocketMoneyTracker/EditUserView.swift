//
//  UserDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

typealias EditableUser = (firstName: String, familyName: String, base: String, email: String)
    
struct EditUserView: View {

    //@EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @State var editUser: EditableUser
    let onSave: (EditableUser)->Void
    
    var body: some View {

           VStack {
                HStack {
                    Button("Cancel") {self.presentationMode.wrappedValue.dismiss()}
                    Spacer()
                    Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onSave(self.editUser)

                    }.disabled(!userIsValid)
                    
                }.padding(.all)
                Form {
                    TextField("First Name", text: $editUser.firstName)
                    TextField("Family Name", text: $editUser.familyName)
                    TextField("Email", text: $editUser.email)
                    TextField("Weekly Money", text: $editUser.base).keyboardType(.decimalPad)
                }

            }
    }
    
    private var validFirstName: Bool {
        editUser.firstName.count > 0
    }
    
    private var validFamilyName: Bool {
        editUser.firstName.count > 0
    }
    
    private var validBase: Bool {
        Double(editUser.base) != nil
    }
    
    private var userIsValid: Bool {
        validBase && validFirstName && validFamilyName
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    
    @State static var showUserDetails: Bool = false
    static var previews: some View {
        
        let user = User(dataManager: LocalDataManager())
        user.loadData()
        
        return EditUserView(editUser: EditableUser("", familyName: "", base: "", email: "")) {u in print(u.firstName)}
    }
}
