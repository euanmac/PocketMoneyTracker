//
//  LockButtonView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 20/02/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct ToggleButton: View {
    @Binding var isOn: Bool
    let onSystemImage: String
    let offSystemImage: String
    private(set) var disabled = false
    
    var body: some View {
        //GeometryReader() {geo in
            Button (action: {
                self.isOn.toggle()
            }) {
                Image(systemName: self.imageName)
                    .frame(width: 18, height: 18)
                }.disabled(disabled)
         //   }
                .buttonStyle(DarkButtonStyle(disabled: disabled))
    }
    
    
    var imageName: String {
        isOn ? onSystemImage : offSystemImage
    }
    
    func disabled(_ disabled: Bool) -> some View
    {
        var v = self
        v.disabled = disabled
        return v
    }
}

struct DarkButtonStyle: ButtonStyle {
    let disabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.frame(minWidth: 0, maxWidth: .infinity)
            .padding(10)
            .background(disabled ? Color.gray : Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: configuration.isPressed ? 0 : 4.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        
    }
}

struct LightButtonStyle: ButtonStyle {
    let disabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.frame(minWidth: 0, maxWidth: .infinity)
            //.padding(2)
            //.background(Color.primary.colorInvert())
            .foregroundColor(disabled ? Color.gray : Color.black)
            //.cornerRadius(10)
            //.shadow(radius: configuration.isPressed ? 0 : 2.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        
    }
}

struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton(isOn: .constant(true), onSystemImage: "lock.fill", offSystemImage: "lock.open.fill")
    }
}
