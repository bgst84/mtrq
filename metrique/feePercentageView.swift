import SwiftUI

struct feePercentageView: View {
    
    @ObservedObject var buildingProject: BuildingProject
    @Binding var isPresented: Bool

    // Array of all fee phases
    let feePhases: [FeePhase] = [
        FeePhase(phaseName: "Vorprojekt", phaseDescription: "Studium der Lösungsmöglichkeiten und Grobkostenschätzung", phasePercentage: 3, phaseHourlyRate: 130),
        FeePhase(phaseName: "Vorprojekt", phaseDescription: "Vorprojekt und Kostenschätzung", phasePercentage: 6, phaseHourlyRate: 130),
        FeePhase(phaseName: "Bauprojekt", phaseDescription: "Bauprojekt", phasePercentage: 13, phaseHourlyRate: 130),
        FeePhase(phaseName: "Bauprojekt", phaseDescription: "Detailstudien", phasePercentage: 4, phaseHourlyRate: 130),
        FeePhase(phaseName: "Bauprojekt", phaseDescription: "Kostenvoranschlag", phasePercentage: 4, phaseHourlyRate: 130),
        FeePhase(phaseName: "Bewilligung", phaseDescription: "Bewilligungsverfahren", phasePercentage: 2.5, phaseHourlyRate: 130),
        FeePhase(phaseName: "Ausschreibung", phaseDescription: "Ausschreibungspläne", phasePercentage: 10, phaseHourlyRate: 130),
        FeePhase(phaseName: "Bauprojekt", phaseDescription: "Ausschreibung und Vergabe", phasePercentage: 8, phaseHourlyRate: 130),
        FeePhase(phaseName: "Ausführungsplanung", phaseDescription: "Ausführungspläne", phasePercentage: 15, phaseHourlyRate: 130),
        FeePhase(phaseName: "Ausführungsplanung", phaseDescription: "Werkverträge", phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: "Ausführung", phaseDescription: "gestalterische Bauleitung", phasePercentage: 6, phaseHourlyRate: 130),
        FeePhase(phaseName: "Ausführung", phaseDescription: "Bauleitung & Kostenkontrolle", phasePercentage: 23, phaseHourlyRate: 130),
        FeePhase(phaseName: "Abschluss", phaseDescription: "Inbetriebnahme", phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: "Abschluss", phaseDescription: "Dokumentation Bauwerk", phasePercentage: 1, phaseHourlyRate: 130),
        FeePhase(phaseName: "Abschluss", phaseDescription: "Leitung Garantiearbeiten", phasePercentage: 1.5, phaseHourlyRate: 130),
        FeePhase(phaseName: "Abschluss", phaseDescription: "Schlussrechnung", phasePercentage: 1, phaseHourlyRate: 130)
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
                        Text("Stunden")
                            .gridColumnAlignment(.trailing)
                        Text("chf/h")
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
                            Text(String(formatNumber2(feePhase.phasePercentage * buildingProject.publicTotalHours / 100)))
                            Text(String(buildingProject.publicHourlyRate))
                            Text(String(formatNumber2(feePhase.phasePercentage * buildingProject.publicTotalFee / 100)))
                        }
                    }
                }
                Button("Zurück") {
                    isPresented = false
                }
                .padding(25)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct feePercentageView_Preview: PreviewProvider {
    
    @State static var isPresented = false

    static var previews: some View {
        feePercentageView(buildingProject: BuildingProject(), isPresented: $isPresented)
    }
}
