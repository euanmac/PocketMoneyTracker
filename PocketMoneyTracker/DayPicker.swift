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
                                
                HStack() {
                    Image(systemName: "arrowtriangle.left.circle.fill")
                        .font(.title)
                        .shadow(radius: 5)
                        .onTapGesture {
                            self.selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: self.selectedDate)!

                    }
                    
                    
                        ForEach(self.selectedDate.weekOfDates, id: \.self) { weekDate in
                            
                            VStack(alignment: .center, spacing:15) {
                                
                                Text(weekDate.dayInitial).font(.caption)
                                Text(weekDate.day)
                                    .modifier(TextDay(selected: weekDate.dateEqual(to: self.selectedDate)))
                                    .onTapGesture {
                                        self.selectedDate = weekDate
                                        //self.dateChanged(weekDate)
                                }.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
                               
                            }.transition(.scale)
                        }
                        
                    
                    
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.title)
                        .shadow(radius: 5)
                        .onTapGesture {
                            self.selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: self.selectedDate)!
                        }
                   
                }
            }
                
    }
}

struct TextDaySelected: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(TextDay(selected: false))
            .colorInvert()
    }
}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {

        DayPicker(selectedDate: .constant(Date()))
    }
}
