import SwiftUI

enum CalculationMode: Int {
    case ausnutzung = 0
    case baumasse
}

struct detailInformation {
    let title: String
    let description: String
    let image: String
}

struct costView: View {
    
    // Common inputs
    @AppStorage("parzelle") var parzelle: String = ""         // Plot size (m²)
    @AppStorage("vollgeschosse") var vollgeschosse: String = "" // Number of stories
    @AppStorage("gebaeudehoehe") var gebaeudehoehe: String = "" // Total building height (m)
    @AppStorage("dgProzent") var dgProzent: Double = 0         // Roof (attic) percentage
    @AppStorage("ugProzent") var ugProzent: Double = 0         // Basement (underground) percentage
    @AppStorage("m3kosten") var m3kosten: Double = 1200        // Cost per cubic meter
    @AppStorage("buildingCost") var buildingCost: String = ""
    
    // Mode selection: 0 = Ausnützungsziffer, 1 = Baumassenziffer
    @AppStorage("calcMode") var calcMode: Int = 0
    // Input specific to the chosen mode:
    @AppStorage("ausnuetzung") var ausnuetzung: String = ""         // For Ausnützungsziffer mode (in %)
    @AppStorage("baumassenziffer") var baumassenziffer: String = ""   // For Baumassenziffer mode
    
    @FocusState var isFocused: Bool // to dismiss the keyboard
    
    // Reset all fields to defaults
    func resetToDefaults() {
        parzelle = ""
        ausnuetzung = ""
        vollgeschosse = ""
        gebaeudehoehe = ""
        dgProzent = 0
        ugProzent = 0
        m3kosten = 1200
        baumassenziffer = ""
    }
    
    // Computed property: Maximum utilization area (only used in Ausnützungsziffer mode)
    var ausnuetzungMax: Double {
        if calcMode == CalculationMode.ausnutzung.rawValue {
            let parzelleTemp = Double(parzelle) ?? 0
            let ausnutzungTemp = Double(ausnuetzung) ?? 0
            return parzelleTemp / 100 * ausnutzungTemp
        } else {
            return 0
        }
    }
    
    // Computed property: Floor height (m) (same for both modes)
    var geschosshoeheMax: Double {
        let gebaeudehoeheTemp = Double(gebaeudehoehe) ?? 0
        let vollgeschosseTemp = Double(vollgeschosse) ?? 1
        return gebaeudehoeheTemp / vollgeschosseTemp
    }
    
    // Computed property: Allowed above-ground volume (m³)
    var bauvolumenOI: Double {
        if calcMode == CalculationMode.ausnutzung.rawValue {
            // Using ausnützungsziffer mode: use usable area * floor height
            return ausnuetzungMax * geschosshoeheMax
        } else {
            // Baumassenziffer mode: directly calculate allowed above-ground volume
            let parzelleVal = Double(parzelle) ?? 0
            let baumassenzifferVal = Double(baumassenziffer) ?? 0
            return parzelleVal * baumassenzifferVal
        }
    }
    
    // Computed property: Average floor area (m²) based on the above-ground volume.
    var gebaeudegrundflaeche: Double {
        let numFloors = Double(vollgeschosse) ?? 1
        let floorHeight = geschosshoeheMax
        
        if calcMode == CalculationMode.ausnutzung.rawValue {
            return ausnuetzungMax / numFloors
        } else {
            // In Baumassenziffer mode, derive average area from the allowed volume:
            return bauvolumenOI / (numFloors * floorHeight)
        }
    }
    
    // Computed property: Roof area (only used in Ausnützungsziffer mode)
    var GFDG: Double {
        if calcMode == CalculationMode.ausnutzung.rawValue {
            return gebaeudegrundflaeche / 100.0 * dgProzent
        } else {
            return 0
        }
    }
    
    // Computed property: Underground area based on a percentage of average floor area
    var GFUG: Double {
        return gebaeudegrundflaeche / 100.0 * ugProzent
    }
    
    // Computed property: Underground volume (m³) using the average story height
    var bauvolumenUI: Double {
        return GFUG * geschosshoeheMax
    }
    
    // Computed property: Total building volume (above + below ground)
    var bauvolumenMax: Double {
        return bauvolumenOI + bauvolumenUI
    }
    
    // Computed property: Estimated construction cost
    var erstellungskosten: Double {
        let cost = m3kosten * bauvolumenMax
        buildingCost = String(cost)  // This updates the AppStorage value as string.
        return cost
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main scrollable content fills available space
            ScrollView {
                VStack {
                    // Image section (unchanged)
                    VStack {
                        Image("erstellungskosten")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                    VStack(alignment: .leading) {
                        
                    Group{
                        Text("Erstellungskosten")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                            .frame(height: 5)
                        
                        Text("Dieses Werkzeugt rechnet anhand der wichtigsten Parameter des Baurechts das mögliche Bauvolumen und daraus die zu erwartenden Baukosten.")
                    }
                    
                    dashSpaceDiv()
                        
                        // Picker for Calculation Mode
                        Picker("Berechnungsart", selection: $calcMode) {
                            Text("Ausnützungsziffer").tag(CalculationMode.ausnutzung.rawValue)
                            Text("Baumassenziffer").tag(CalculationMode.baumasse.rawValue)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        Spacer()
                            .frame(height: 15)
                        
                        // Mode-specific input fields:
                        if calcMode == CalculationMode.ausnutzung.rawValue {
                            Group {
                                Text("Ausnützungsziffer (%)")
                                    .fontWeight(.bold)
                                Text("Geben Sie die Ausnützungsziffer gemäß Zonenplan ein.")
                                TextField("Ausnützungsziffer", text: $ausnuetzung)
                                    .focused($isFocused)
                                    .keyboardType(.decimalPad)
                                    .padding(5)
                                    .background(Color("textField"))
                            }
                        } else {
                            Group {
                                Text("Baumassenziffer (m3/m2)")
                                    .fontWeight(.bold)
                                Text("Baumassenziffer des Grundstücks.")
                                TextField("Baumassenziffer", text: $baumassenziffer)
                                    .focused($isFocused)
                                    .keyboardType(.decimalPad)
                                    .padding(5)
                                    .background(Color("textField"))
                            }
                        }
                        
                        dashSpaceDiv()
                        
                        Group { // Allgemeine Eingaben
                            Text("Baurecht")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer().frame(height: 10)
                            
                            Text("Grösse Parzelle (m²)")
                                .fontWeight(.bold)
                            Text("Grösse der zu bebauenden Parzelle.")
                            TextField("Grösse Parzelle", text: $parzelle)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .padding(5)
                                .background(Color("textField"))
                            
                            Spacer().frame(height: 10)
                            
                            Text("mögliche Vollgeschosse (#)")
                                .fontWeight(.bold)
                            Text("Anzahl der möglichen Vollgeschosse (ohne Attika-/Dachgeschoss und Untergeschoss).")
                            TextField("mögliche Vollgeschosse", text: $vollgeschosse)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .padding(5)
                                .background(Color("textField"))
                            
                            Spacer().frame(height: 10)
                            
                            Text("max. Gebäudehöhe (m)")
                                .fontWeight(.bold)
                            Text("Maximale Gebäudehöhe (Boden bis Traufkante).")
                            TextField("max. Gebäudehöhe", text: $gebaeudehoehe)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .padding(5)
                                .background(Color("textField"))
                        }
                        
                        dashSpaceDiv()
                        
                        Text("Untergeschoss")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer().frame(height: 10)
                        
                        // Show roof percentage only in Ausnützungsziffer mode
                        if calcMode == CalculationMode.ausnutzung.rawValue {
                            Group {
                                Text("Anteil GGF Dachgeschoss (%)")
                                    .fontWeight(.bold)
                                Text("Prozentualer Anteil des Dachgeschosses gegenüber der durchschnittlichen Geschossfläche.")
                                Spacer()
                                Text("\(formatNumber2(dgProzent)) % ≈ \(formatNumber2(GFDG)) m²")
                                    .foregroundColor(Color("resultTextColor"))
                                Slider(value: $dgProzent, in: 0...100, step: 5)
                                Spacer().frame(height: 10)
                            }
                        }
                        
                        // Underground percentage input remains in both modes.
                        Group {
                            Text("Anteil GGF Untergeschoss (%)")
                                .fontWeight(.bold)
                            Text("Prozentualer Anteil des Untergeschosses gegenüber der durchschnittlichen Geschossfläche.")
                            Spacer()
                            Text("\(formatNumber2(ugProzent)) % ≈ \(formatNumber2(GFUG)) m²")
                                .foregroundColor(Color("resultTextColor"))
                            Slider(value: $ugProzent, in: 0...100, step: 5)
                        }
                        
                        dashSpaceDiv()
                        
                        Text("Zusammenfassung")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer().frame(height: 10)
                        
                        Group {
                            Text("Maximale Geschosshöhe (m)")
                                .fontWeight(.bold)
                            Text(formatNumber2(geschosshoeheMax))
                                .foregroundColor(Color("resultTextColor"))
                            Spacer().frame(height: 10)
                            
                            Text("Durchschnittliche Geschossfläche (m²)")
                                .fontWeight(.bold)
                            Text(formatNumber2(gebaeudegrundflaeche))
                                .foregroundColor(Color("resultTextColor"))
                            Spacer().frame(height: 10)
                            
                            Text("Bauvolumen oberirdisch (m³)")
                                .fontWeight(.bold)
                            Text(formatNumber2(bauvolumenOI))
                                .foregroundColor(Color("resultTextColor"))
                            Spacer().frame(height: 10)
                            
                            Text("Bauvolumen unterirdisch (m³)")
                                .fontWeight(.bold)
                            Text(formatNumber2(bauvolumenUI))
                                .foregroundColor(Color("resultTextColor"))
                            Spacer().frame(height: 10)
                            
                            Text("Bauvolumen total (m³)")
                                .fontWeight(.bold)
                            Text(formatNumber2(bauvolumenMax))
                                .foregroundColor(Color("resultTextColor"))
                        }
                        
                        dashSpaceDiv()
                        
                        Group {
                            Text("Baukosten pro m³ (chf)")
                                .fontWeight(.bold)
                            Text(formatNumber2(m3kosten))
                                .foregroundColor(Color("resultTextColor"))
                            Slider(value: $m3kosten, in: 900...1800, step: 50)
                        }
                        
                    }
                    .padding(25.0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Add bottom padding so last fields are not obscured by floating result box
                    Spacer(minLength: 0)
                        .frame(height: 150)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onTapGesture {
                if isFocused { isFocused = false }
            }
            
            // Floating result panel overlayed at the bottom
            VStack(spacing: 12) {
                GroupBox {
                    VStack(alignment: .leading) {
                        Text("Erstellungskosten (chf)")
                            .fontWeight(.bold)
                        HStack {
                            Text(formatNumber2(erstellungskosten))
                            Button {
                                UIPasteboard.general.string = formatNumber2(erstellungskosten)
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .groupBoxStyle(resultGroupBox())
                
                Button {
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

struct costView_Previews: PreviewProvider {
    static var previews: some View {
        costView()
    }
}
