//
//  mortgageAffordability.swift
//  metrique
//
//  Created by Yves Seiler on 13.05.2024.
//

import SwiftUI

struct mortgageAffordability: View {
    
    @AppStorage("buyingPrice") var buyingPrice: String = "1000000"
    @AppStorage("additionalInvestment") var additioalInvestment: String = "250000"
    @AppStorage("ownFundsPercentage") var ownFundsPercentage: Double = 0.2
    @AppStorage("interestRatePercentage") var interestRatePercentage: Double = 0.015
    @AppStorage("additionalCostPercentage") var additionalCostPercentage: Double = 0.01
    @AppStorage("amortizationPercentage") var amortizationPercentage: Double = 0.01


    //@State var minimumIncome: String = "" //Mindesteinkommen
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
    func resetToDefaults() {
        buyingPrice = "1000000"
        additioalInvestment = "250000"
        ownFundsPercentage = 0.2
        interestRatePercentage = 0.015
        additionalCostPercentage = 0.01
        amortizationPercentage = 0.01
        }
    
    var mortgagePercentage: Double {
        
        let ownFundsPercentageTemp = ownFundsPercentage
        let mortagePercentageTemp = 1-ownFundsPercentageTemp
        
        return mortagePercentageTemp
    }
    
    var yearlyInterest: String {
        
        let buyingPriceTemp = Double(buyingPrice) ?? 0
        let mortgagePercentageTemp = mortgagePercentage
        let interestRateTemp = interestRatePercentage
        let yearlyInterestTemp = buyingPriceTemp * mortgagePercentageTemp * interestRateTemp
        
        return String(yearlyInterestTemp)
    }
    
    var totalInvestment: String {
        
        let buyingPriceTemp = Double(buyingPrice) ?? 0
        let additionalInvestmentTemp = Double(additioalInvestment) ?? 0
        let totalInvestmentTemp = buyingPriceTemp + additionalInvestmentTemp
        
        return String(totalInvestmentTemp)
    }
    
    var ownFunds: String {
        
        let totalInvestementTemp = Double(totalInvestment) ?? 0
        let ownFundsPercentageTemp = ownFundsPercentage
        let ownFundsTemp = totalInvestementTemp * ownFundsPercentageTemp
        
        return String(ownFundsTemp)
    }
    
    var mortgageSize: String {
        
        let totalInvestementTemp = Double(totalInvestment) ?? 0
        let ownFundsTemp = Double(ownFunds) ?? 0
        let mortgageTemp = totalInvestementTemp - ownFundsTemp
        
        return String(mortgageTemp)
        
    }
    
    var interestRate: String {
        
        let mortgageSizeTemp = Double(mortgageSize) ?? 0
        let interestRatePercentageTemp = interestRatePercentage
        let interestRateTemp = mortgageSizeTemp * interestRatePercentageTemp
        
        return String(interestRateTemp)
        
    }
    
    var amortization: String {
        
        let mortgageSizeTemp = Double(mortgageSize) ?? 0
        let amortizationPercentageTemp = amortizationPercentage
        let amortizationTemp = mortgageSizeTemp * amortizationPercentageTemp
        
        return String(amortizationTemp)
        
    }
    
    var additionalCost: String {
        
        let totalInvestmentTemp = Double(totalInvestment) ?? 0
        let additionalCostPercentageTemp = additionalCostPercentage
        let additionalCostTemp = totalInvestmentTemp * additionalCostPercentageTemp
        
        return String(additionalCostTemp)
        
    }
    
    var totalInvestmentCost: String {
        
        let interestRateTemp = Double(interestRate) ?? 0
        let amortizationTemp = Double(amortization) ?? 0
        let additionalCostTemp = Double(additionalCost) ?? 0
        let totalInvestmentCostTemp = interestRateTemp + amortizationTemp + additionalCostTemp
        
        return String(totalInvestmentCostTemp)
    }
    
    var minimumIncome: String {
        
        let totalInvestmentCostTemp = Double(totalInvestmentCost) ?? 0
        let minimumIncomeTemp = totalInvestmentCostTemp/(1/3)
        
        return String(minimumIncomeTemp)
        
    }
    
    //------------------------------------------------------------------------------------
    var body: some View {
        
        ZStack(alignment: .bottom) {
            // Main scrollable content fills available space
            ScrollView{
                VStack {
                    //------------------------------------------------------------------------------------
                    VStack{ //Titelbild
                        
                        Image("hypothek2") //Platzhalter
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    }
                    .frame(maxWidth: .infinity)
                    //------------------------------------------------------------------------------------
                    VStack(alignment:.leading){
                        //------------------------------------------------------------------------------------
                        Group {
                            
                            Text("Tragbarkeit Hypothek")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            
                            Spacer()
                                .frame(height: 5)
                            
                            Text("Dieses Werkzeug berechnet die Finanzierungskosten für den Kauf oder Bau eines Eigenheims sowie das Mindesteinkommen, das für die Hypothek erforderlich ist.")
                        }
                        dashSpaceDiv()
                        //------------------------------------------------------------------------------------
                        
                        Group{ //Investition
                            
                            Text("Investition")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Kaufpreis")
                                    .fontWeight(.bold)
                                
                                Text("Kaufpreis der Immobilie (chf)")
                                
                                TextField("Kaufpreis", text: $buyingPrice)
                                    .focused($isFocused)
                                    .keyboardType(.decimalPad)
                                    .padding(5)
                                    .background(Color("textField"))
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Investitionen")
                                    .fontWeight(.bold)
                                
                                Text("zusätzliche Investitionen, Umbau, etc. (chf)")
                                
                                TextField("Investitionen", text: $additioalInvestment)
                                    .focused($isFocused)
                                    .keyboardType(.decimalPad)
                                    .padding(5)
                                    .background(Color("textField"))
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Total")
                                    .fontWeight(.bold)
                                
                                Text("Total Investitionen (chf)")
                                
                                Spacer()
                                
                                Text(formatNumber(Double(totalInvestment)!))
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            //------------------------------------------------------------------------------------
                            dashSpaceDiv()
                            
                        }
                        
                        
                        Group{ //Hypothek
                            
                            Text("Hypothek")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Eigenmittel")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("Anteil Eigenmittel (%)")
                                
                                Spacer()
                                
                                Text("\(formatNumber(ownFundsPercentage*100)) % ergibt \(formatNumber(Double(ownFunds)!))")
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Slider(value: $ownFundsPercentage, in: 0...1, step: 0.05)
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            //------------------------------------------------------------------------------------
                            Group{
                                Text("Hypothek")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("Höhe Hypothek (chf)")
                                
                                Spacer()
                                
                                Text(formatNumber(Double(mortgageSize)!))
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            //------------------------------------------------------------------------------------
                            dashSpaceDiv()
                            
                        }
                        
                        //------------------------------------------------------------------------------------
                        
                        Group{ //Gesamtkosten
                            
                            Text("Gesamtkosten")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                                .frame(height: groupSpacer)
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Zinsen")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("Jährliche Zinsen auf Hypothek (chf)")
                                
                                Spacer()
                                
                                Text("\(formatNumber2(interestRatePercentage*100)) % ergibt \(formatNumber(Double(interestRate)!))")
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Slider(value: $interestRatePercentage, in: 0...0.1, step: 0.0025)
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Amortisation")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("Amortisation auf Hypothek (chf)")
                                
                                Spacer()
                                
                                Text("\(formatNumber2(amortizationPercentage*100)) % ergibt \(formatNumber(Double(amortization)!))")
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Slider(value: $amortizationPercentage, in: 0...0.1, step: 0.0025)
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            
                            //------------------------------------------------------------------------------------
                            
                            Group{
                                Text("Nebenkosten")
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("Nebenkosten auf Investition (chf)")
                                
                                Spacer()
                                
                                Text("\(formatNumber2(additionalCostPercentage*100)) % ergibt \(formatNumber(Double(additionalCost)!))")
                                    .foregroundColor(Color("resultTextColor"))
                                
                                Slider(value: $additionalCostPercentage, in: 0...0.1, step: 0.0025)
                                
                                Spacer()
                                    .frame(height: groupSpacer)
                            }
                            
                            //------------------------------------------------------------------------------------
                                                    
                        }
                        
                    }
                    //------------------------------------------------------------------------------------
                    
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Add bottom padding so last fields are not obscured by floating result box
                    Spacer(minLength: 0)
                        .frame(height: 220)
                }
            }//ScrollView End
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onTapGesture {
                if (isFocused == true) {
                    isFocused = false
                }
            }
            //------------------------------------------------------------------------------------
            
            // Floating result panel overlayed at the bottom
            VStack(spacing: 12) {
                GroupBox{
                    VStack(alignment: .leading){
                        Text("Gesamtkosten pro Jahr (chf)")
                            .fontWeight(.bold)
                        
                        HStack{
                            Text(formatNumber(Double(totalInvestmentCost)!))
                            
                            Button{
                                UIPasteboard.general.string = formatNumber(Double(totalInvestmentCost)!)
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
                        Text("Tragbarkeit Mindesteinkommen (chf)")
                            .fontWeight(.bold)
                        
                        HStack{
                            Text(formatNumber(Double(minimumIncome)!))
                            
                            Button{
                                UIPasteboard.general.string = formatNumber(Double(minimumIncome)!)
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
            
        }//ZStack End
    }
}

#Preview {
    mortgageAffordability()
}
