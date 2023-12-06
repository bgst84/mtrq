//
//  settingsView.swift
//  metrique
//
//  Created by Yves Seiler on 19.06.23.
//

import SwiftUI

struct settingsView: View {
    
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    var body: some View {
        
        ScrollView{
            
            VStack(){
                
                Image("settings")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                
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
