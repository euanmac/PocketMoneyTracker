//
//  TaskDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

typealias EditableTask = (description: String, mandatory: Bool, value: String)

struct EditTaskView: View {

    @Environment(\.presentationMode) var presentationMode
    @State var editTask: EditableTask
    let onSave: (EditableTask)->Void
    let onDelete: (()->Void)?
    let canDelete: Bool
    
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
                    Toggle(isOn: $editTask.mandatory, label: {Text("Mandatory")})
                    TextField("Value", text: $editTask.value).keyboardType(.decimalPad)
                    if (canDelete) {
                        Button("Delete") {
                            self.presentationMode.wrappedValue.dismiss()
                            self.onDelete?()
                        }
                    }

                }

            }
    }
    
    private var validDescription: Bool {
        editTask.description.count > 0
    }
        
    private var validValue: Bool {
        Double(editTask.value) != nil
    }
    
    private var taskIsValid: Bool {
        validValue && validDescription
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    
     static var previews: some View {
        
//        let user = User(dataManager: LocalDataManager())
//        user.loadData()
//
        return EditTaskView(editTask: EditableTask("", false, value: ""), onSave: {u in print(u.description)}, onDelete: nil, canDelete: true)
    
    }
}
