//
//  mortgageAffordability.swift
//  metrique
//
//  Created by Yves Seiler on 13.05.2024.
//

import SwiftUI

struct mortgageAffordability: View {
    
    @State var buyingPrice: String = "1000000"  //Kaufpreis ev. totales Investment? oder aufteilen...
    @State var additioalInvestment: String = "250000"
    @State var ownFundsPercentage: Double = 0.2 //Prozent Eigenkapital
    @State var interestRatePercentage: Double = 0.015 //Prozent Hypothekarzins
    @State var additionalCostPercentage: Double = 0.01 //Prozent Nebenkosten
    @State var amortizationPercentage: Double = 0.01 //Prozent Amortisation


    //@State var minimumIncome: String = "" //Mindesteinkommen
    @FocusState var isFocused : Bool // für Ausblenden des Keyboards
    
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
        
        VStack{
            ScrollView{
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
            }//ScrollView End
            .onTapGesture {
                if (isFocused == true) {
                    isFocused = false
                }
            }
            //------------------------------------------------------------------------------------
            GroupBox{ //Resultate
                
                VStack(alignment: .leading){
                    
                    Group{
                        Text("Gesamtkosten pro Jahr (chf)")
                            .fontWeight(.bold)
                        
                        HStack{
                            
                            Button{
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                            
                            Text(formatNumber(Double(totalInvestmentCost)!))
                        }
                    }
                    
                    Spacer()
                        .frame(height: groupSpacer)
                    
                    Group{
                        Text("Tragbarkeit Mindesteinkommen (chf)")
                            .fontWeight(.bold)
                        
                        HStack{
                            
                            Button{
                            } label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(Color("textColor"))
                            }
                            
                            Text(formatNumber(Double(minimumIncome)!))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .groupBoxStyle(resultGroupBox())
            .padding([.leading, .trailing], 20)
            //------------------------------------------------------------------------------------
            
        }//VStack End
    }
}

#Preview {
    mortgageAffordability()
}
