//
//  menuView.swift
//  metrique
//
//  Created by Yves Seiler on 08.07.23.
//

import SwiftUI

struct menuView: View {
  
    @StateObject var buildingProject = BuildingProject()

    var body: some View {
        
        NavigationView{
            
            ScrollView{
                
                Image("metrique_icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(25)
                
                
                VStack{
           
                    
                    NavigationLink(destination: costView()){
                        HStack(alignment: .center, spacing: 25.0){
                            
                            Image("erstellungskosten")
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: 100, height: 100)
                            VStack(alignment: .leading){
                                
                                
                                Text("Erstellungskosten")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor"))
                                    
                                Text("Berechnung mögliche Volumetrie und Erstellungskosten.")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor"))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    
                    NavigationLink(destination: feeView(buildingProject: buildingProject)){
                        HStack(spacing: 25.0){
                            Image("honorar")
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading){
                                Text("Architekten-Honorar")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor"))
                                Text("Berechnung Honorar anhand der Baukosten.")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor"))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 25.0)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                       
                    
                    
                    NavigationLink(destination: returnView()){
                        HStack(spacing: 25.0){
                            Image("return")
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading){
                                Text("Brutto-Rendite")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor"))
                                Text("Berechnung zu erwartende Brutto-Rendite bei Vermietung.")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor"))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 25.0)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    
                    NavigationLink(destination: costRentView()){
                        HStack(spacing: 25.0){
                            Image("kostenmiete")
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading){
                                Text("Kostenmiete")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor"))
                                Text("Berechnung des kostendeckenden Mietzins ohne Gewinnanteil.")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor"))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 25.0)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    
                    NavigationLink(destination: settingsView()){
                        HStack(spacing: 25.0){
                            Image("settings")
                                .resizable()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment: .leading){
                                Text("Über uns")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textColor"))
                                Text("Über uns & Kontakt")
                                    .font(.subheadline)
                                    .foregroundColor(Color("textColor"))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
               
            }
        }
    }
}





struct menuView_Previews: PreviewProvider {
        
    static var previews: some View {
        menuView()
    }
}
