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
                
                Text(self.selectedDate.full)
                    .font(.headline)
                    //.foregroundColor(.secondary)
                    
                
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
                                }.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
                               
                            }
                        }
                        
                    
                    
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.title)
                        .shadow(radius: 5)
                        .onTapGesture {
                        self.selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: self.selectedDate)!
                        }
                   
                }.padding(.bottom, 20)
                .padding(5)
                .foregroundColor(Color.primary)
                .background(Color.primary.colorInvert())
                .cornerRadius(10)
                .shadow(radius: 2)
            }
//                .padding(5)
//                .foregroundColor(Color.primary)
//                .background(Color.primary.colorInvert())
//                .cornerRadius(10)
//                .shadow(radius: 5)
                
    }
}

struct TextDaySelected: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(TextDay(selected: false))
            .colorInvert()
    }
}

struct TextDayCurrent: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .padding(5)
            .foregroundColor(Color.primary)
            .background(Color.primary.colorInvert())
            .cornerRadius(20)
    }
}

struct TextDay: ViewModifier {
    let selected: Bool
    
    func body(content: Content) -> some View {
        let modified = content
            .font(.caption)
            .padding(5)
            .foregroundColor(Color.primary)
            .background(Color.primary.colorInvert())
            .cornerRadius(20)
            .shadow(radius: 5)

        return selected ? AnyView(modified.colorInvert()) : AnyView(modified)
    }
}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        //List {
            DayPicker(selectedDate: .constant(Date()))
        //}
    }
}
