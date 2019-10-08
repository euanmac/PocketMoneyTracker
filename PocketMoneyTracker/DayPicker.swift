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
        GeometryReader {geometry in
            VStack(alignment: .center, spacing: 0 )  {
                HStack {
                    Text(self.selectedDate.full)
                }
                
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "arrowtriangle.left.circle.fill")
                        .font(.title)
                        .onTapGesture {
                            self.selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: self.selectedDate)!
                    }
                            
                    ForEach(self.selectedDate.weekOfDates, id: \.self) { weekDate in
                        HStack{
                            VStack {
                                Text(weekDate.dayInitial).font(.caption)
                            
                                Text(weekDate.day)
                                    .modifier(TextDay(selected: weekDate.dateEqual(to: self.selectedDate)))
                                    .onTapGesture {
                                        self.selectedDate = weekDate
                                    }
                            }
                            
                        }
                    }
                    Image(systemName: "arrowtriangle.right.circle.fill")
                        .font(.title)
                        .onTapGesture {
                        self.selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: self.selectedDate)!
                    }
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

struct TextDayCurrent: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
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

        return selected ? AnyView(modified.colorInvert()) : AnyView(modified)
    }
}

struct DayPicker_Previews: PreviewProvider {
    static var previews: some View {
        DayPicker(selectedDate: .constant(Date()))
    }
}
