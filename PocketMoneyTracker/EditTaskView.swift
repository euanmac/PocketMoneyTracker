//
//  TaskDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

typealias EditableTask = (description: String, mandatory: Bool, value: String, image: String, archived: Bool)

struct EditTaskView: View {

    @Environment(\.presentationMode) var presentationMode
    @State var editTask: UserTask
    let editable: Bool
    let onSave: (UserTask)->Void
    let onDelete: ((UserTask)->Void)?
    
    var body: some View {

           VStack {
                HStack {
                    Button("Cancel") {self.presentationMode.wrappedValue.dismiss()}
                    Spacer()
                    Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onSave(self.editTask)
                    }.disabled(!taskIsValid)
                    
                }.padding(.all)
                Form {
                    TextField("Description", text: $editTask.description)
//                    Toggle(isOn: $editTask.mandatory, label: {Text("Mandatory")})
//                    TextField("Value", text: $editTask.value).keyboardType(.decimalPad)
                    Image(systemName: editTask.image.rawValue)
//                    if (onDelete != nil) {
//                        Button("Delete") {
//                            self.presentationMode.wrappedValue.dismiss()
//                            self.onDelete?()
//                        }
//                    }

                }

            }
    }
            
//    private var validValue: Bool {
//        Double(editTask.value) != nil
//    }
    
    private var taskIsValid: Bool {
        editTask.isValid //validValue &&
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    
     static var previews: some View {
        
//        let user = User(dataManager: LocalDataManager())
//        user.loadData()
//
        return Text("Hello")
    
    }
}
