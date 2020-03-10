//
//  DayPIcker.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 07/10/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct DayPicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 5)  {
                                
                HStack {
                    
                    Button(action: {self.selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: self.selectedDate)!}) {
                        Image(systemName: "arrowtriangle.left.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(LightButtonStyle(disabled: false))
                    
                    
                    ForEach(self.selectedDate.weekOfDates, id: \.self) { weekDate in
                        
                        VStack(alignment: .center, spacing:10) {
                            
                            Text(weekDate.dayInitial).font(.caption)
                            Text(weekDate.day)
                                .modifier(TextDay(selected: weekDate.dateEqual(to: self.selectedDate)))
                                .animation(.interactiveSpring())
                                .onTapGesture {
                                    self.selectedDate = weekDate
                                    //self.dateChanged(weekDate)
                            }.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
                           
                        }
                    }
                            
                    
                    Button(action: {self.selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: self.selectedDate)!}) {
                                           Image(systemName: "arrowtriangle.right.circle.fill")
                                               .font(.title)
                    }
                        .buttonStyle(LightButtonStyle(disabled: false))
                    
            }
        }
                
    }
}

//struct ArrowButtonStyle: ButtonStyle {
//    func makeBody(configuration: ButtonStyleConfiguration) -> ArrowButtonStyle.Body {
//        
//    }
//}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {

        DayPicker(selectedDate: .constant(Date()))
    }
}
