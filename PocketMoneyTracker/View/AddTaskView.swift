//
//  TaskDetails.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 17/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine


struct AddTaskView: View {

    private typealias NewTask = (description: String, mandatory: Bool, value: String, image: UserTask.TaskImage)
    
    @Environment(\.presentationMode) var presentationMode
    let onAdd: (UserTask)->Void
    @State var newTask = NewTask(description: "", mandatory: false, value: "0.0", image: .star)
    
    var body: some View {

           VStack {
                HStack {
                    Button("Cancel") {self.presentationMode.wrappedValue.dismiss()}
                    Spacer()
                    Text("Add Task").fontWeight(.bold)
                    Spacer()
                    Button("Add") {
                        self.presentationMode.wrappedValue.dismiss()
                        self.onAdd(self.newUserTask)
                    
                    }.disabled(!taskIsValid)
                }.padding(.top).padding(.horizontal)
            
                NavigationView {
                    Form {
                        Section(header: Text("")) {
                            HStack {
                                Text("Name")
                                Spacer()
                                TextField("Description", text: $newTask.description).multilineTextAlignment(.trailing)
                            }
                            
                            Picker(selection: $newTask.image, label: Text("Image")) {
                                ForEach(UserTask.TaskImage.allCases) { image in
                                    Image(systemName: image.rawValue)
                                }
                            }
                            
                            Toggle("Mandatory", isOn: $newTask.mandatory.animation())
                            
                            if (!newTask.mandatory) {
                                HStack {
                                    Text("Value")
                                    Spacer()
                                    TextField("Value", text: $newTask.value).multilineTextAlignment(.trailing).keyboardType(.decimalPad)
                                }
                            }
                        }
                        .navigationBarHidden(true)
                        .navigationBarTitle("")
                        .onDisappear {print ("Gone")}
   
                    }
                }

            }
    }
    
    private var newUserTask: UserTask {
        UserTask(
            description: newTask.description,
            mandatory: newTask.mandatory,
            value: Double(newTask.value) ?? 0,
            image: newTask.image
        )
    }
    
    private var taskIsValid: Bool {
        newUserTask.isValid && (Double(newTask.value) != nil)
    }

}

