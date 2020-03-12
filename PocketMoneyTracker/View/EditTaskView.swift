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
    let deletable: Bool
    let archivable: Bool
    let onSave: (UserTask)->Void
    let onDelete: ((UserTask)->Void)?
    
    var body: some View {

           VStack {
                HStack {
                    Button("Cancel") {self.presentationMode.wrappedValue.dismiss()}
                    Spacer()
                    Text("Edit Task").fontWeight(.bold)
                    Spacer()
                    Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onSave(self.editTask)
                    }.disabled(!taskIsValid)
                    
                }.padding(.top).padding(.horizontal)
            
                NavigationView {
                    Form {
                        Section(header: Text("")) {
                            HStack {
                                Text("Name")
                                Spacer()
                                TextField("Description", text: $editTask.description).multilineTextAlignment(.trailing)
                            }.disabled(!editable)
                            
                            Picker(selection: $editTask.image, label: Text("Image")) {
                                ForEach(UserTask.TaskImage.allCases) { image in
                                    Image(systemName: image.rawValue)
                                }
                            }
                            //.pickerStyle(
                            .disabled(!editable)
                            
                            //These fields should always be disabled as a task's value / mandatory state cannot change after creation
                            //To remove a task it should be archived instead unless it has no completions
                            if (editTask.mandatory) {
                                Toggle("Mandatory", isOn: .constant(true)).disabled(true)
                            } else {
                                HStack {
                                    Text("Value")
                                    Spacer()
                                    Text(editTask.value.displayCurrency()).disabled(true)
                                }                    }
                                                                            
                            //If deletable then show delete button
                             if (deletable) {
                                HStack()  {
                                    Spacer()
                                    Button(action: {
                                        self.onDelete!(self.editTask)
                                        self.presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Delete Task")
                                    }
                                        .buttonStyle(BorderlessButtonStyle())
                                        .frame(minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                                   Spacer()
                                }
                            }
                            
                            
                            
                        }
                        .navigationBarHidden(true)
                        .navigationBarTitle("")
                        .onDisappear {print ("Gone")}
                        //.padding(.top)
                    }
                }

            }
    }
    
    private var taskIsValid: Bool {
        editTask.isValid
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
