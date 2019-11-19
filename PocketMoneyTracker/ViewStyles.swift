//
//  ViewStyles.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 14/11/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation
import SwiftUI

struct TextDay: ViewModifier {
    let selected: Bool
    
    func body(content: Content) -> some View {
        let modified = content
            .font(.caption)
            .padding(5)
            .foregroundColor(Color.primary)
            .background(Color.primary.colorInvert())
            .cornerRadius(20)
            //.shadow(radius: 5)

        return selected ? AnyView(modified.colorInvert()) : AnyView(modified)
    }
}

struct ShadowPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
            .foregroundColor(.primary)
            .padding(5)
            .background(Color.primary.colorInvert())
            .cornerRadius(10)
            //.shadow(radius: 2)
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

struct TaskPanel: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.frame(minWidth: 0, idealWidth: nil, maxWidth: .infinity, minHeight: 0, idealHeight: nil, maxHeight: nil)
            .foregroundColor(.primary)
            .padding(5)
            .background(Color.primary.colorInvert())
            .cornerRadius(10)
            //.shadow(radius: 2)
    }
}
