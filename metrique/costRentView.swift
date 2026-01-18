//
//  costRentView.swift
//  metrique
//
//  Created by Yves Seiler on 09.07.23.
//

import SwiftUI

struct costRentView: View {
    
    @AppStorage("landPrice") var landpreis: String = ""
    @AppStorage("buildingCost") var baukosten: String = ""
    @AppStorage("kapitalanteilProzent") var kapitalanteilProzent: Double = 0.0
    @AppStorage("verzinsungEigenkapitalProzent") var verzinsungEigenkapitalProzent: Double = 0.0
    @AppStorage("verzinsungFremdkapitalProzent") var verzinsungFremdkapitalProzent: Double = 0.0
    @AppStorage("laufendeKostenProzent") var laufendeKostenProzent: Double = 0.25
    @AppStorage("unterhaltsKostenProzent") var unterhaltsKostenProzent: Double = 0.5
    @AppStorage("abschreibungenProzent") var abschreibungenProzent: Double = 0.75
    @AppStorage("risikoprämieProzent") var risikoprämieProzent: Double = 0.25
    @AppStorage("bewirtschaftungProzent") var bewirtschaftungProzent: Double = 3.0
    
    func resetToDefaults() {
        landpreis = ""
        baukosten = ""
        kapitalanteilProzent = 0.0
        verzinsungEigenkapitalProzent = 0.0
        verzinsungFremdkapitalProzent = 0.0
        laufendeKostenProzent = 0.25
        unterhaltsKostenProzent = 0.5
        abschreibungenProzent = 0.75
        risikoprämieProzent = 0.25
        bewirtschaftungProzent = 3.0
    }
    
    var anlagekosten: String {
        
        let landpreisTemp = Double(landpreis) ?? 0
        let baukostenTemp = Double(baukosten) ?? 0
        let anlagekostenTemp = landpreisTemp + baukostenTemp
        
        return String(anlagekostenTemp)
        
    }
    
    var fremdkapital: String {
        
        let anlagekostenTemp = Double(anlagekosten) ?? 0
        let kapitalanteilProzentTemp = kapitalanteilProzent
        let fremdkapitalTemp = anlagekostenTemp/100*kapitalanteilProzentTemp
        
        return String(fremdkapitalTemp)
        
    }
    
    var verzinsungEigenkapital: String {
        
        let anlageKostenTemp = Double(anlagekosten) ?? 0
        let kapitalanteilProzentTemp = kapitalanteilProzent
        let verzinsungEigenkapitalProzentTemp = verzinsungEigenkapitalProzent
        let eigenkapitalTemp = anlageKostenTemp/100*(100-kapitalanteilProzentTemp)
        let verzinsungEigenkapitalTemp = eigenkapitalTemp/100*verzinsungEigenkapitalProzentTemp
        
        return String(verzinsungEigenkapitalTemp)
    }
    
    var verzinsungFremdkapital: String {
        
        let anlageKostenTemp = Double(anlagekosten) ?? 0
        let kapitalanteilProzentTemp = kapitalanteilProzent
        let verzinsungFremdkapitalProzentTemp = verzinsungFremdkapitalProzent
        let fremdkapitalTemp = anlageKostenTemp/100*kapitalanteilProzentTemp
        let verzinsungfremdkapitalTemp = fremdkapitalTemp/100*verzinsungFremdkapitalProzentTemp
        
        return String(verzinsungfremdkapitalTemp)
    }
    
    var laufendeKosten: String {
        
        let laufendeKostenProzentTemp = laufendeKostenProzent
        let anlagekostenTemp = Double(anlagekosten) ?? 0
        let laufendeKostenTemp = anlagekostenTemp/100*laufendeKostenProzentTemp
        
        return String(laufendeKostenTemp)
    }
    
    var unterhaltsKosten: String {
        
        let unterhaltsKostenProzentTemp = unterhaltsKostenProzent
        let baukostenTemp = Double(baukosten) ?? 0
        let unterhaltsKostenTemp = baukostenTemp/100*unterhaltsKostenProzentTemp
        
        return String(unterhaltsKostenTemp)
        
    }
    
    var abschreibungen: String {
        
        let abschreibungenProzentTemp = abschreibungenProzent
        let baukostenTemp = Double(baukosten) ?? 0
        let abschreibungenTemp = baukostenTemp/100*abschreibungenProzentTemp
        return String(abschreibungenTemp)
    }
    
    var risikoprämie: String {
        
        let anlagekostenTemp = Double(anlagekosten) ?? 0
        let risikoprämieProzentTemp = risikoprämieProzent
        let risikoprämieTemp = anlagekostenTemp/100*risikoprämieProzentTemp
        
        return String(risikoprämieTemp)
    }
    
    var bewirtschaftung: String {
        
        let kostenmieteTemp = Double(kostenmiete) ?? 0
        let bewirtschaftungProzentTemp = bewirtschaftungProzent
        let bewirtschaftungTemp = kostenmieteTemp/100*bewirtschaftungProzentTemp
        
        return String(bewirtschaftungTemp)
        
    }
    
    var kostenmiete: String {
        
        let verzinsungEigenkapitalTemp = Double(verzinsungEigenkapital) ?? 0
        let verzinsungFremdkapitalTemp = Double(verzinsungFremdkapital) ?? 0
        let laufendeKostenTemp = Double(laufendeKosten) ?? 0
        let unterhaltsKostenTemp = Double(unterhaltsKosten) ?? 0
        let abschreibungenTemp = Double(abschreibungen) ?? 0
        let risikoprämieTemp = Double(risikoprämie) ?? 0
        
        let kostenmieteTemp = verzinsungEigenkapitalTemp + verzinsungFremdkapitalTemp + laufendeKostenTemp + unterhaltsKostenTemp + abschreibungenTemp + risikoprämieTemp
        return String(kostenmieteTemp)
    }
    
    var kostenmieteMitBewirtschaftung: String {
        
        let kostenmieteTemp = Double(kostenmiete) ?? 0
        let bewirtschaftungTemp = Double(bewirtschaftung) ?? 0
        let kostenmieteMitBewirtschaftungTemp = kostenmieteTemp + bewirtschaftungTemp
        
        return String(kostenmieteMitBewirtschaftungTemp)
    }
    
    
    
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            // Main scrollable content fills available space
            ScrollView{
                VStack {
                    VStack(){
                        
                        Image("kostenmiete")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    VStack(alignment: .leading) {
                        
                        Group {
                            
                            Text("Kostenmiete")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: 5)
                            
                            Text("Kalkulierter Mietzins anhand der anfallenden Kosten (Investitionen & Betrieb), ohne Gewinnanteil.")
                            
                            dashSpaceDiv()
                            
                        }
                        
                        Group { //Anlagekosten
                            
                            Text("Anlage")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Landpreis (chf)")
                                .fontWeight(.bold)
                            TextField("Landpreis", text: $landpreis)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .padding(5)
                                .background(Color("textField"))
                            
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Baukosten (chf)")
                                .fontWeight(.bold)
                            
                            TextField("Baukosten", text: $baukosten)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .padding(5)
                                .background(Color("textField"))
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Anlagekosten (chf)")
                                .fontWeight(.bold)
                            
                            Text(formatNumber(Double(anlagekosten)!))
                                .foregroundColor(Color("resultTextColor"))
                            
                        }
                        
                        dashSpaceDiv()
                        
                        Group { //Kapital
                            
                            Text("Kapital")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Anteil Fremdkapital (%)")
                                .fontWeight(.bold)
                            
                            Text(formatNumber(kapitalanteilProzent) + " % ≈ \(formatNumber(Double(fremdkapital)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $kapitalanteilProzent, in: 0...100, step: 5)
                            
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Verzinsung Eigenkapital (%)")
                                .fontWeight(.bold)
                            
                            Text(formatNumber2(verzinsungEigenkapitalProzent) + " % ≈ \(formatNumber(Double(verzinsungEigenkapital)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $verzinsungEigenkapitalProzent, in: 0...5, step: 0.05)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            Text("Verzinsung Fremdkapital (%)")
                                .fontWeight(.bold)
                            
                            Text(formatNumber2(verzinsungFremdkapitalProzent) + " % ≈ \(formatNumber(Double(verzinsungFremdkapital)!))")
                                .foregroundColor(Color("resultTextColor"))
                            Slider(value: $verzinsungFremdkapitalProzent, in: 0...5, step: 0.05)
                            
                            
                        }
                        
                        dashSpaceDiv()
                        
                        Group { //Kosten
                            
                            Text("Kosten")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            
                            //laufende Kosten
                            Text("laufende Kosten (%)")
                                .fontWeight(.bold)
                            Text("Abgaben, Betrieb, Steuern, Versicherungen (0.25 – 0.50% der Anlagekosten)")
                            
                            Text(formatNumber2(laufendeKostenProzent) + "% ≈ \(formatNumber(Double(laufendeKosten)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $laufendeKostenProzent, in: 0.25...0.5, step: 0.05)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            //Unterhaltskosten
                            Text("Unterhaltskosten (%)")
                                .fontWeight(.bold)
                            Text("Reparaturen und Unterhalt (0.50 – 1.50% der Baukosten)")
                            
                            Text(formatNumber2(unterhaltsKostenProzent) + "% ≈ \(formatNumber(Double(unterhaltsKosten)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $unterhaltsKostenProzent, in: 0.5...1.5, step: 0.05)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            //Abschreibungen
                            Text("Abschreibungen (%)")
                                .fontWeight(.bold)
                            Text("nur über Baukosten (0.75 – 1.50% der Baukosten)")
                            
                            Text(formatNumber2(abschreibungenProzent) + "% ≈ \(formatNumber(Double(abschreibungen)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $abschreibungenProzent, in: 0.75...1.5, step: 0.05)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            
                            
                            //Risikoprämie
                            Text("Risikoprämie (%)")
                                .fontWeight(.bold)
                            Text("für Kompensation Leerstände (0.25 – 0.50% der Anlagekosten)")
                            
                            Text(formatNumber2(risikoprämieProzent) + "% ≈ \(formatNumber(Double(risikoprämie)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $risikoprämieProzent, in: 0.25...0.5, step: 0.05)
                            
                            dashSpaceDiv()
                            
                            //Bewirtschaftung
                            Text("Bewirtschaftung (%)")
                                .fontWeight(.bold)
                            Text("Kosten für die Bewirtschaftung (4 – 5% der Kostenmiete)")
                            
                            Text(formatNumber2(bewirtschaftungProzent) + "% ≈ \(formatNumber(Double(bewirtschaftung)!))")
                                .foregroundColor(Color("resultTextColor"))
                            
                            Slider(value: $bewirtschaftungProzent, in: 3...5, step: 0.25)
                            
                        }
                        
                        
                    }//end VStack
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Add bottom padding so last fields are not obscured by floating result box
                    Spacer(minLength: 0)
                        .frame(height: 220)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onTapGesture {
                if (isFocused == true) {
                    isFocused = false
                }
            }
            
            // Floating result panel overlayed at the bottom
            VStack(spacing: 12) {
                GroupBox{
                    VStack(alignment: .leading){
                        Text("Kostenmiete (chf)")
                            .fontWeight(.bold)
                        
                        HStack{
                            Text(formatNumber(Double(kostenmiete)!))
                            
                            Button{
                                UIPasteboard.general.string = formatNumber(Double(kostenmiete)!)
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .groupBoxStyle(subResultGroupBox())
                
                
                GroupBox{
                    VStack(alignment: .leading){
                        Text("Kostenmiete & Bewirtschaftung (chf)")
                            .fontWeight(.bold)
                        
                        
                        HStack{
                            Text(formatNumber(Double(kostenmieteMitBewirtschaftung)!))
                            
                            Button{
                                UIPasteboard.general.string = formatNumber(Double(kostenmieteMitBewirtschaftung)!)
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .groupBoxStyle(resultGroupBox())
                
                //reset values
                Button{
                    resetToDefaults()
                } label: {
                    Image(systemName: "return")
                    Text("alle Eingaben zurücksetzen")
                }
            }
            .padding(.horizontal, 20)
            
        }
            
        
    }
}

    
struct costRentView_Previews: PreviewProvider {
        static var previews: some View {
            costRentView()
        }
}
