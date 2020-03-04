//
//  PaidButtonView.swift
//  PocketMoneyTracker
//
//  Created by Euan Macfarlane on 22/02/2020.
//  Copyright © 2020 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct PaidButtonView: View {
    @State var isPaid: Bool
    @State var textHeight: CGFloat = 0
    let action: (Bool) -> Void
    
    var body: some View {
        Button (action: {self.isPaid.toggle()}) {
            Image(systemName: imageName)
                .frame(width: 18, height: 18)
        }
        .buttonStyle(PaidButtonStyle())
    }
    
    var imageName: String {
        isPaid ? "sterlingsign.square" : "checkmark.seal.fill"
    }
}

struct PaidButtonStyle: ButtonStyle {
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

struct ViewFrame: Equatable {

    /// A given identifier for the View to faciliate processing
    /// of frame updates
    let viewId: Int
    /// An `Anchor` representation of the View
    let frameAnchor: Anchor<CGRect>

    // Conformace to Equatable is required for supporting
    // view udpates via `PreferenceKey`
    static func == (lhs: ViewFrame, rhs: ViewFrame) -> Bool {
        // Since we can currently not compare `Anchor<CGRect>` values
        // without a Geometry reader, we return here `false` so that on
        // every change on bounds an update is issued.
        return false
    }
}

/// A `PreferenceKey` to provide View frame updates in a View tree
struct FramePreferenceKey: PreferenceKey {
    typealias Value = [ViewFrame] // The list of view frame changes in a View tree.

    static var defaultValue: [ViewFrame] = []

    /// When traversing the view tree, Swift UI will use this function to collect all view frame changes.
    static func reduce(value: inout [ViewFrame], nextValue: () -> [ViewFrame]) {
        value.append(contentsOf: nextValue())
    }
}

