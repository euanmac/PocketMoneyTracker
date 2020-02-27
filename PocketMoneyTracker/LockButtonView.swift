//
//  LockButtonView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 20/02/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct LockButtonView: View {
    @State var isLocked: Bool
    let action: (Bool) -> Void
    
    var body: some View {
        //GeometryReader() {geo in
            Button (action: {self.isLocked.toggle()}) {
                Image(systemName: self.imageName)
                }
         //   }
        .buttonStyle(LockButtonStyle())
            
    }
    
    var imageName: String {
        isLocked ? "lock.open.fill" : "lock.fill"
    }
}

struct LockButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.frame(minWidth: 0, maxWidth: .infinity)
            .padding(10)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct LockButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LockButtonView(isLocked: true, action: {print($0)})
    }
}
