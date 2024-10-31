//
//  costView.swift
//  metrique
//
//  Created by Yves Seiler on 19.06.23.
//

import SwiftUI

struct defaultLayout: View {
    
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    
    var body: some View {
        
        VStack{
            ScrollView{
                VStack(){
                    
                    Image("erstellungskosten")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                }
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .leading) {
                    
                    Text("This is a test")
                    
                }
                .padding(25)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                .onTapGesture {
                    if (isFocused == true) {
                        isFocused = false
                    }
                }
            }//ScrollView End
               
            GroupBox{ //Resultate
                
                VStack(alignment: .leading){
                    Text("Erstellungskosten (chf)")
                        .fontWeight(.bold)
                    
                    HStack{
                        
                        Button{
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(Color("textColor"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .groupBoxStyle(resultGroupBox())
            .padding([.leading, .trailing], 20)
            
            
            
            
            
            
        }//VStack End
    }
}

struct defaultLayout_Previews: PreviewProvider {
    static var previews: some View {
        defaultLayout()
    }
}

