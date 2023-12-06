//
//  yieldView.swift
//  metrique
//
//  Created by Yves Seiler on 19.06.23.
//

import SwiftUI

struct returnView: View {
    
    @State private var buildingCost: String = ""
    @State private var landCost: String = ""
    @State private var NGF: String = ""
    @State private var chfm2a: String = ""
    @State private var selectedOption: String = " "
    
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    var totalReturn: String {
        let NGFtemp = Double(NGF) ?? 0
        let chfm2atemp = Double(chfm2a) ?? 0
        let totalReturntemp = NGFtemp * chfm2atemp
        
        
        return String(totalReturntemp)
        
    }
    
    var totalCost: String {
        
        let buildingCostTemp = Double(buildingCost) ?? 0
        let landCostTemp = Double(landCost) ?? 0
        
        return String(buildingCostTemp + landCostTemp)
        
    }
    
    private var bruttoReturn: String {
        
        let totalCostTemp = Double(totalCost) ?? 0
        let totalReturnTemp = Double(totalReturn) ?? 0
        
        guard totalReturnTemp != 0 else {
            return "0"
        }
        
        return String(totalReturnTemp/totalCostTemp*100)
    }
    
    
    var body: some View {
        
        ScrollView{
            
            VStack(){
                
                Image("return")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            }
            .frame(maxWidth: .infinity)
      
            
            VStack(alignment: .leading) {
                
                Group {
                    
                    Spacer()
                        .frame(height: groupSpacer)
                    
                    Text("Bruttorendite Mietobjekt")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text("Dieses Werkzeugt errechnet die zu erwartende Brutto-Rendite eines Bauprojekts bei einer Vermietung der gebauten Flächen.")
                }

                dashSpaceDiv()
                
                Group{
                    Text("HNF Hauptnutzfläche vermietbar")
                        .fontWeight(.bold)
                    
                    TextField("HNF", text: $NGF)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .padding(5)
                        .background(Color("textField"))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{
                    Text("Mietzins pro m2 und Jahr")
                        .fontWeight(.bold)
                    
                    TextField("chf/m2a", text: $chfm2a)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .padding(5)
                        .background(Color("textField"))
                    
                    
                    HStack{
                        
                        Text("kantonaler Durchschnitt 2021:")
                        
                        Picker("Kanton auswählen", selection: $selectedOption) {
                            ForEach(Array(kantoneMietzins.keys), id: \.self) { canton in
                                Text(canton)
                            }
                        }
                        .onChange(of: selectedOption) { newValue in
                            chfm2a = kantoneMietzins[newValue] ?? ""
                        }
                    }
                    
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{
                    Text("Ertrag Brutto (chf)")
                        .fontWeight(.bold)
                    
                    Text(formatNumber(Double(totalReturn)!))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{
                    Text("Erstellungskosten (chf)")
                        .fontWeight(.bold)
                    
                    TextField("Erstellungskosten", text: $buildingCost)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .padding(5)
                        .background(Color("textField"))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{
                    Text("Landwert (chf)")
                        .fontWeight(.bold)
                    
                    TextField("Landwert", text: $landCost)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .padding(5)
                        .background(Color("textField"))
                }
                
                dashSpaceDiv()
                
                GroupBox{
                    
                    VStack(alignment: .leading){
                        Text("Anlagekosten (chf)")
                            .fontWeight(.bold)
                            .font(.title2)
                        
                        HStack{
                            
                            Text(formatNumber(Double(totalCost)!))
                                .font(.title2)
                            
                            Button{
                                UIPasteboard.general.string = formatNumber(Double(totalCost)!)
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .groupBoxStyle(subResultGroupBox())
              
                        Spacer()
                            .frame(height: groupSpacer)
                        
                     
                    GroupBox{
                        VStack(alignment: .leading){
                            Text("Bruttorendite (%)")
                                .fontWeight(.bold)
                                .font(.title2)
                            
                            HStack{
                                Text(formatNumber(Double(bruttoReturn) ?? 0))
                                    .font(.title2)
                                
                                Button{
                                    UIPasteboard.general.string = formatNumber(Double(bruttoReturn)!)
                                } label: {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(Color("textColor"))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .groupBoxStyle(resultGroupBox())
                
              //  dashSpaceDiv()
               // Button("share fee", systemImage: "square.and.arrow.up"){
             //   }
                
            }//end VStack
            .padding(25)
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        
        .onTapGesture {
            if (isFocused == true) {
                isFocused = false
            }
        }
        
        
        
    }
}

struct returnView_Previews: PreviewProvider {
    static var previews: some View {
        returnView()
    }
}

func updatechfm2a(){
    
}
