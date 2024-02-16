import SwiftUI

struct feePercentageView: View {
    
    @Binding var isPresented: Bool

    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var buildingProject: BuildingProject
    
    // Array of all fee phase
    
    
    let feePhases: [FeePhase] = [
        FeePhase(phaseName: NSLocalizedString("Vorprojekt", comment: "Phase name for preliminary project"),
                 phaseDescription: NSLocalizedString("Studium der Lösungsmöglichkeiten und Grobkostenschätzung", comment: "Phase description for study of solution options and rough cost estimate"),
                 phasePercentage: 3, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Vorprojekt", comment: "Phase name for preliminary project"),
                 phaseDescription: NSLocalizedString("Vorprojekt und Kostenschätzung", comment: "Phase description for preliminary project and cost estimation"),
                 phasePercentage: 6, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
                 phaseDescription: NSLocalizedString("Bauprojekt", comment: "Phase description for construction project"),
                 phasePercentage: 13, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
                 phaseDescription: NSLocalizedString("Detailstudien", comment: "Phase description for detailed studies"),
                 phasePercentage: 4, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
                 phaseDescription: NSLocalizedString("Kostenvoranschlag", comment: "Phase description for cost estimate"),
                 phasePercentage: 4, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Bewilligung", comment: "Phase name for approval"),
                 phaseDescription: NSLocalizedString("Bewilligungsverfahren", comment: "Phase description for approval process"),
                 phasePercentage: 2.5, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Ausschreibung", comment: "Phase name for tendering"),
                 phaseDescription: NSLocalizedString("Ausschreibungspläne", comment: "Phase description for tender plans"),
                 phasePercentage: 10, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
                 phaseDescription: NSLocalizedString("Ausschreibung und Vergabe", comment: "Phase description for tender and awarding"),
                 phasePercentage: 8, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Ausführungsplanung", comment: "Phase name for execution planning"),
                 phaseDescription: NSLocalizedString("Ausführungspläne", comment: "Phase description for implementation plans"),
                 phasePercentage: 15, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Ausführungsplanung", comment: "Phase name for execution planning"),
                 phaseDescription: NSLocalizedString("Werkverträge", comment: "Phase description for work contracts"),
                 phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Ausführung", comment: "Phase name for execution"),
                 phaseDescription: NSLocalizedString("gestalterische Bauleitung", comment: "Phase description for creative construction management"),
                 phasePercentage: 6, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Ausführung", comment: "Phase name for execution"),
                 phaseDescription: NSLocalizedString("Bauleitung & Kostenkontrolle", comment: "Phase description for construction management & cost control"),
                 phasePercentage: 23, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
                 phaseDescription: NSLocalizedString("Inbetriebnahme", comment: "Phase description for commissioning"),
                 phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
                 phaseDescription: NSLocalizedString("Dokumentation Bauwerk", comment: "Phase description for documentation of the building"),
                 phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
                 phaseDescription: NSLocalizedString("Leitung Garantiearbeiten", comment: "Phase description for management of warranty works"),
                 phasePercentage: 1.5, phaseHourlyRate: 130),
        FeePhase(phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
                 phaseDescription: NSLocalizedString("Schlussrechnung", comment: "Phase description for final invoice"),
                 phasePercentage: 1, phaseHourlyRate: 130)

    ]

    var body: some View {
        
        NavigationView {
            ScrollView {
                Grid(alignment: .top, verticalSpacing: 10) {
                    Spacer().frame(height: groupSpacer)
                    
                    
                    GridRow() {
                        Text("Honorarphase")
                            .gridColumnAlignment(.leading)
                        Text("Beschrieb")
                            .gridColumnAlignment(.leading)
                        Text("Prozent")
                            .gridColumnAlignment(.trailing)
                        //Text("Stunden")
                            .gridColumnAlignment(.trailing)
                        //Text("chf/h")
                            .gridColumnAlignment(.trailing)
                        Text("Honorar")
                            .gridColumnAlignment(.trailing)
                    }
                    
                    dashDivider()
                    
                        ForEach(feePhases, id: \.self) { feePhase in
                            GridRow {
                                if feePhase == feePhases.first || feePhase.phaseName != feePhases[feePhases.firstIndex(of: feePhase)! - 1].phaseName {
                                    Text(feePhase.phaseName).fontWeight(.black)
                                } else {
                                    Text("")
                                }
                                Text(feePhase.phaseDescription)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(String(feePhase.phasePercentage))
                                //Text(String(formatNumber2(feePhase.phasePercentage * buildingProject.totalHours / 100)))
                                //Text(globalSettings.hourlyRate)
                                Text(String(formatNumber2(feePhase.phasePercentage * buildingProject.totalFee / 100)))
                            }
                        }
                    }
         
                
                
                
                 
                Button("Zurück") {
                    isPresented = false
                }
                .padding(.top, 25)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(20)
        }
    }
}

struct feePercentageView_Preview: PreviewProvider {
    
    @State static var isPresented = false

    static var previews: some View {
        feePercentageView(isPresented: $isPresented)
            .environmentObject(GlobalSettings())
            .environmentObject(BuildingProject())
    }
}
