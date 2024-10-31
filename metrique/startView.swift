//
//  startView.swift
//  metrique
//
//  Created by Yves Seiler on 31.10.2024.
//

import SwiftUI

struct startView: View {
    
    @AppStorage("parzelle") var parzelle: String = "" //parzellen-fläche
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards

    
    var body: some View {
        TextField("Grösse Parzelle", text: $parzelle)
            .focused($isFocused)
            .keyboardType(.decimalPad)
            .padding(5)
            .background(Color("textField"))
    }
}

#Preview {
    startView()
}
