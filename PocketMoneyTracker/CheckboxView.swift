//
//  CheckboxView.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 03/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct CheckboxView: View {
    
    @Binding var checked: Bool
    var body: some View {
        if checked {
            return Image(systemName: "checkmark.square").onTapGesture {
                self.checked.toggle()
            }
            
        } else {
            return Image(systemName: "square").onTapGesture {
                self.checked.toggle() }
        }
    }
}

struct CheckboxView_Previews: PreviewProvider {
    @State static var checked = true
   
    static var previews: some View {
        return CheckboxView(checked: $checked)
    }
}
