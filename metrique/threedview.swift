//
//  threeDview.swift
//  metrique
//
//  Created by Yves Seiler on 23.08.23.
//

import SwiftUI
import SceneKit

struct threeDview: View {
    
    let lampView = SCNScene(named: "art.scnassets/lampview.scn")

    
    var body: some View {
        
            SceneView(scene: lampView)
        
    
    VStack{
        Text("Test")
    }
    }
    }


#Preview {
    threeDview()
}
