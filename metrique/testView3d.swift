//
//  testView3d.swift
//  metrique
//
//  Created by Yves Seiler on 24.05.2024.
//

import SwiftUI
import SceneKit

var scene = SCNScene(named: "metrique_logo.scn")
var cameraNode: SCNNode? {
    scene?.rootNode.childNode(withName: "camera", recursively: false)
}

struct testView3d: View {
    @State private var lastRotation: Float = 90.0
    @State private var rotation: Float = 0.0
    
    var body: some View {
        
        SceneView(
            scene: scene,
            pointOfView: cameraNode,
            options: []
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    let translation = value.translation
                    let newRotation = -Float(translation.width) * .pi / 180
                    rotation = lastRotation + newRotation
                    rotateCameraAroundOrigin(rotation: rotation)
                }
                .onEnded { value in
                    let translation = value.translation
                    let newRotation = -Float(translation.width) * .pi / 180
                    lastRotation += newRotation
                }
        )
        .clipShape(Circle())
        .frame(width: 300, height: 300)
    }
    
    func rotateCameraAroundOrigin(rotation: Float) {
        guard let cameraNode = cameraNode else { return }
        
        // Distance of the camera from the origin
        let radius: Float = 120.0
        
        // New position of the camera
        let x = radius * cos(rotation)
        let z = radius * sin(rotation)
        
        // Update the camera position
        cameraNode.position = SCNVector3(x, 0, z)
        
        // Make the camera look at the origin
        cameraNode.look(at: SCNVector3(0, 0, 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        testView3d()
    }
}

