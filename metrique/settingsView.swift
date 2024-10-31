//
//  settingsView.swift
//  metrique
//
//  Created by Yves Seiler on 19.06.23.
//

import SwiftUI
import SceneKit



struct settingsView: View {
    @State private var lastRotation: Float = 90.0
    @State private var rotation: Float = 0.0
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    var body: some View {
        
        ScrollView{
            
            VStack(){
                
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
                .frame(height: 300)
               
//                Image("settings")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 300)
//                    .clipped()
                
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading) {
                
                Group {
                    
                    Text("Über uns")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text("Diese App wird laufend weiterentwickelt und um Funktionen ergänzt.")
                    
                    Spacer()
                    
                    Text("Für Fragen, Anmerkungen und Feedback stehen wir per Mail zur Verfügung:")
                    
                    Spacer()
                    
                    Link("mail@metrique.app", destination: URL(string: "mailto:metrique.app")!)
                    
                }
                
                VStack{
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text("Version: " + UIApplication.version)
                    }
                }
                
                
            }//end VStack
            .padding(25.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onTapGesture {
            if (isFocused == true) {
                isFocused = false
            }
        }
    }
}

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView()
    }
}
