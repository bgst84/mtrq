//
//  costView.swift
//  metrique
//
//  Created by Yves Seiler on 19.06.23.
//

import SwiftUI

struct detailInformation {
    let title: String
    let description: String
    let image: String
}

struct costView: View {
    
    @State var parzelle: String = ""
    @State var ausnuetzung: String = ""
    @State var vollgeschosse: String = ""
    @State var gebaeudehoehe: String = ""
    @State var dgProzent: Double = 0
    @State var ugProzent: Double = 0
    @State var m3kosten: Double = 1200
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    var gebaeudegrundflaeche: String {
        
        let ausnuetzungMaxTemp = Double(ausnuetzungMax) ?? 0
        let vollgeschosseTemp = Double(vollgeschosse) ?? 0
        let ggfTemp = ausnuetzungMaxTemp/vollgeschosseTemp
        
        return String(ggfTemp)
    }
    
    
    var GFDG: String {
        let dgProzentTemp = dgProzent
        let ggfTemp = Double(gebaeudegrundflaeche) ?? 0
        let GFDGTemp: Double = ggfTemp/100.0*dgProzentTemp
        
        if !GFDGTemp.isNaN{
            return String(GFDGTemp)
        }else{
            return "0"
        }
        
    }
    
    var GFUG: String {
        let ugProzentTemp = ugProzent
        let ggfTemp = Double(gebaeudegrundflaeche) ?? 0
        let GFUGTemp: Double = ggfTemp/100.0*ugProzentTemp
        
        if !GFUGTemp.isNaN{
            return String(GFUGTemp)
        }else{
            return "0"
        }
        
    }
    
    
    var bauvolumenOI: String {
        
        let GFDGtemp = Double(GFDG) ?? 0
        let ausnuetzungMaxTemp = Double(ausnuetzungMax) ?? 0
        let geschosshoeheTemp = Double(geschosshoeheMax) ?? 0
        let bauvolumenOITemp = ausnuetzungMaxTemp * geschosshoeheTemp + GFDGtemp*geschosshoeheTemp * geschosshoeheTemp
        
        if !bauvolumenOITemp.isNaN {
            return String(bauvolumenOITemp)
        } else {
            return "0"
        }
        
        
    }
    
    var bauvolumenUI: String {
        
        let GFUGtemp = Double(GFUG) ?? 0
        let geschosshoeheTemp = Double(geschosshoeheMax) ?? 0
        let bauvolumenUITemp = GFUGtemp * geschosshoeheTemp
        
        if !bauvolumenUITemp.isNaN {
            return String(bauvolumenUITemp)
        } else {
            return "0"
        }
        
    }
    
    
    var ausnuetzungMax: String {
        let parzelleTemp = Double(parzelle) ?? 0
        let ausnuetzungTemp = Double(ausnuetzung) ?? 0
        let ausnuetzungMaxTemp = parzelleTemp/100*ausnuetzungTemp
        
        if !ausnuetzungMaxTemp.isNaN{
            return String(ausnuetzungMaxTemp)
        }else{
            return "0"
        }
    }
    
    var bauvolumenMax: String {
        
        let bauvolumenOITemp = Double(bauvolumenOI) ?? 0
        let bauvolumenUITemp = Double(bauvolumenUI) ?? 0
        let bauvolumenMaxTemp = bauvolumenOITemp + bauvolumenUITemp
        
        if !bauvolumenMaxTemp.isNaN {
            return String(bauvolumenMaxTemp)
        } else {
            
            return "0"
            
        }
    }
    
    var geschosshoeheMax: String {
        
        let gebaeudehoeheTemp = Double(gebaeudehoehe) ?? 0
        let vollgeschosseTemp = Double(vollgeschosse) ?? 0
        let geschosshoeheMaxTemp = gebaeudehoeheTemp/vollgeschosseTemp
        
        if !geschosshoeheMaxTemp.isNaN{
            return String(geschosshoeheMaxTemp)
        }else{
            return "0"
        }
    }
    
    var erstellungskosten: String {
        
        let m3kostenTemp = Double(m3kosten)
        let bauvolumenMaxTemp = Double(bauvolumenMax) ?? 0
        
        let erstellungskostenTemp = m3kostenTemp * bauvolumenMaxTemp
        
        if !erstellungskostenTemp.isNaN {
            return String(erstellungskostenTemp)
        } else {
            return "0"
        }
        
    }
    
    
    
    
    
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
                
                Group{ // Baurecht
                    Group {
                        
                      Text("Erstellungskosten")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                            .frame(height: 5)
                        
                        Text("Dieses Werkzeugt rechnet anhand der wichtigsten Parameter des Baurechts das mögliche Bauvolumen und daraus die zu erwartenden Baukosten.")
                    }
                    
                    dashSpaceDiv()
                    
                    Group{ //Parzellengrösse
                        
                        Text("Baurecht")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                            .frame(height: groupSpacer)
                        
                        Text("Grösse Parzelle (m2)")
                                .fontWeight(.bold)
                        
                        Text("Grösse der zu bebauenden Parzelle.")
                        
                        TextField("Grösse Parzelle", text: $parzelle)
                            .focused($isFocused)
                            .keyboardType(.decimalPad)
                            .padding(5)
                            .background(Color("textField"))
                        
                        Spacer()
                            .frame(height: groupSpacer)
                    }
                    
                    Group{ //Ausnützung
                        Text("Ausnützungsziffer (%)")
                            .fontWeight(.bold)
                        
                        Text("Ausnützungsziffer gemäss Zonenplan.")
                    
                        
                        TextField("Ausnützungsziffer", text: $ausnuetzung)
                            .focused($isFocused)
                            .keyboardType(.decimalPad)
                            .padding(5)
                            .background(Color("textField"))
                        
                        Spacer()
                            .frame(height: groupSpacer)
                    }
                    
                    Group{ //Vollgeschosse
                        Text("mögliche Vollgeschosse (#)")
                            .fontWeight(.bold)
                        
                        Text("Anzahl der möglichen Vollgeschosse (ohne Attika- bzw. Dachgeschoss und Untergeschoss.)")
                        
                        TextField("mögliche Vollgeschosse", text: $vollgeschosse)
                            .focused($isFocused)
                            .keyboardType(.decimalPad)
                            .padding(5)
                            .background(Color("textField"))
                        
                        Spacer()
                            .frame(height: groupSpacer)
                    }
                    
                    Group{ //mögliche Gebäudehöhe
                        Text("max. Gebäudehöhe (m)")
                            .fontWeight(.bold)
                        
                        Text("maximale Gebäudehöhe (gewachsener Boden bis Traufkante)")
                        
                        TextField("max. Gebäudehöhe", text: $gebaeudehoehe)
                            .focused($isFocused)
                            .keyboardType(.decimalPad)
                            .padding(5)
                            .background(Color("textField"))
                    }
                }
                
                dashSpaceDiv()
                
                Text("Dach- und Untergeschoss")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: groupSpacer)
                
                Group{ //Prozent Dachgeschoss
                    
                    Text("Anteil GGF Dachgeschoss (%)")
                        .fontWeight(.bold)
                    
                    Text("prozentualer Anteil des Dachgeschoss gegenüber der Gebäudegrundfläche")
                    
                    Spacer()
                    
                    Text("\(formatNumber(dgProzent)) % ergibt \(formatNumber(Double(GFDG)!)) m2")
                        .foregroundColor(Color("resultTextColor"))
                    
                    Slider(value: $dgProzent, in: 0...100, step: 5)
                    
                    Spacer()
                        .frame(height: groupSpacer)
                    
                }
                
                
                Group{ //Prozent Untergeschoss
                    
                    Text("Anteil GGF Untergeschoss (%)")
                        .fontWeight(.bold)
                    
                    Text("prozentualer Anteil des Untergeschoss gegenüber der Gebäudegrundfläche")
                    
                    Spacer()
                    
                    Text("\(formatNumber(ugProzent)) % ergibt \(formatNumber(Double(GFUG)!)) m2")
                        .foregroundColor(Color("resultTextColor"))
                    
                    Slider(value: $ugProzent, in: 0...100, step: 5)
                    
                }
                
                dashSpaceDiv()
                
                Text("Zusammenfassung")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: groupSpacer)
                
                Group{ //max. Ausnützung
                    Text("maximale Geschosshöhe (m)")
                        .fontWeight(.bold)
                    Text(formatNumber(Double(geschosshoeheMax)!))
                        .foregroundColor(Color("resultTextColor"))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{ //max. Ausnützung
                    Text("maximale Ausnützung (m2)")
                        .fontWeight(.bold)
                    Text(formatNumber(Double(ausnuetzungMax)!))
                        .foregroundColor(Color("resultTextColor"))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{ //mögliches Bauvolumen oberirdisch
                    Text("Bauvolumen oberirdisch (m3)")
                        .fontWeight(.bold)
                    
                    Text(formatNumber(Double(bauvolumenOI)!))
                        .foregroundColor(Color("resultTextColor")) //zahl erst hier formatieren? test
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{ //mögliches Bauvolumen unterirdisch
                    Text("Bauvolumen unterirdisch (m3)")
                        .fontWeight(.bold)
                    Text(formatNumber(Double(bauvolumenUI)!))
                        .foregroundColor(Color("resultTextColor"))
                    
                    Spacer()
                        .frame(height: groupSpacer)
                }
                
                Group{ //mögliches Bauvolumen unterirdisch
                    Text("Bauvolumen total (m3)")
                        .fontWeight(.bold)
                    Text(formatNumber(Double(bauvolumenMax)!))
                        .foregroundColor(Color("resultTextColor"))
                    
                }
                
                dashSpaceDiv()
                
                Group{ //Kosten pro m3
                    
                    Text("Baukosten pro m3 (chf)")
                        .fontWeight(.bold)
                    
                        Text(formatNumber(m3kosten))
                            .foregroundColor(Color("resultTextColor"))
                        
                        Slider(value: $m3kosten, in: 900...1800, step: 50)
                }
                
                
                
               
                
            }
            .padding(25.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            
        }
        .onTapGesture {
            if (isFocused == true) {
                isFocused = false
            }
        }
            
            GroupBox{ //Erstellungskosten
                
                VStack(alignment: .leading){
                    Text("Erstellungskosten (chf)")
                        .fontWeight(.bold)
                    
                    HStack{
                        Text(formatNumber(Double(erstellungskosten)!))
                        
                        Button{
                            UIPasteboard.general.string = formatNumber(Double(erstellungskosten)!)
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

            
        }
        
        
        
    }
}

struct costView_Previews: PreviewProvider {
    static var previews: some View {
        costView()
    }
}
