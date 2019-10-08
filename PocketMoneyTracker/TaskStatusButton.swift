//
//  TaskStatusButotn.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 09/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct TaskStatusButton: View {
    
    @Binding var isComplete: Bool
    var backgroundColor : Color {
        get {
            switch isComplete {
            case true:
                return Color.gray
            case false:
                return .green
            }
        }
    }

    var body: some View {
        Text(isComplete ? "Complete" : "Pending")
            .font(.subheadline)
            .padding(5)
            .frame(width: 80.0)
            .background(self.backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .onTapGesture {
                self.isComplete.toggle()
                print (self.isComplete)
            }
    }
    
    
}

struct TaskStatusButton_Previews: PreviewProvider {
    
    static var previews: some View {
        return TaskStatusButton(isComplete: .constant(true))
    }
}
