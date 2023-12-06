//
//  testView.swift
//  metrique
//
//  Created by Yves Seiler on 02.08.23.
//

import SwiftUI

struct testView: View {
    var body: some View {
        
        VStack(spacing: 0) {
         
            dashDivider()
            Text("test")
                .padding(20.0)
                .frame(maxWidth: .infinity, alignment:.leading)
                .background(Color("resultField"))
            dashDivider()
        }
        
     
        
    }
}

#Preview {
    testView()
}
