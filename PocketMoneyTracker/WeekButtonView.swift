//
//  WeekButtonView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 18/02/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import SwiftUI


struct WeekStatusButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 10)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ButtonWeekView: View {
   
    enum ButtonState: Int, Codable {
           case open, closed, paid
           
           func nextState()->Self {
               switch self {
               case .closed:
                   return .paid
               case .open:
                   return .closed
               case .paid:
                   return .open
               }
           }
       }
    
    let week: Week?
    let buttonPressed: (ButtonState)->Void
    
    var body: some View {

        Button(action: {self.buttonPressed(self.state.nextState())}, label: {getbuttonText(state: state)})
    }
    
    //not sure this should be here but returns a button state given a week
     private var state: ButtonWeekView.ButtonState {
         if let week = week {
             return week.isPaid ? .paid : .closed
         } else {
             return .open
         }
     }
    

    func getbuttonText(state: ButtonState) -> some View {
        switch state.nextState() {
        case .closed:
            return Text("Close")
        case .open:
            return Text("Open")
        case .paid:
            return Text("Paid")
        }
    }
}



//struct WeekButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekButtonView(weekState: .constant(.open))
//    }
//}
