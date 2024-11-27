import SwiftUI

struct feePercentageView: View {

    @Binding var isPresented: Bool

    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var buildingProject: BuildingProject

    // Array of all fee phases
    let feePhases: [FeePhase] = [
           FeePhase(
               phaseName: NSLocalizedString("Vorprojekt", comment: "Phase name for preliminary project"),
               phaseDescription: NSLocalizedString("Studium der Lösungsmöglichkeiten und Grobkostenschätzung", comment: "Phase description for study of solution options and rough cost estimate"),
               phasePercentage: 3,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Vorprojekt", comment: "Phase name for preliminary project"),
               phaseDescription: NSLocalizedString("Vorprojekt und Kostenschätzung", comment: "Phase description for preliminary project and cost estimation"),
               phasePercentage: 6,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
               phaseDescription: NSLocalizedString("Bauprojekt", comment: "Phase description for construction project"),
               phasePercentage: 13,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
               phaseDescription: NSLocalizedString("Detailstudien", comment: "Phase description for detailed studies"),
               phasePercentage: 4,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Bauprojekt", comment: "Phase name for construction project"),
               phaseDescription: NSLocalizedString("Kostenvoranschlag", comment: "Phase description for cost estimate"),
               phasePercentage: 4,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Bewilligung", comment: "Phase name for approval"),
               phaseDescription: NSLocalizedString("Bewilligungsverfahren", comment: "Phase description for approval process"),
               phasePercentage: 2.5,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausschreibung", comment: "Phase name for tendering"),
               phaseDescription: NSLocalizedString("Ausschreibungspläne", comment: "Phase description for tender plans"),
               phasePercentage: 10,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausschreibung", comment: "Phase name for tendering"),
               phaseDescription: NSLocalizedString("Ausschreibung und Vergabe", comment: "Phase description for tendering and awarding"),
               phasePercentage: 8,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausführungsplanung", comment: "Phase name for execution planning"),
               phaseDescription: NSLocalizedString("Ausführungspläne", comment: "Phase description for execution plans"),
               phasePercentage: 15,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausführungsplanung", comment: "Phase name for execution planning"),
               phaseDescription: NSLocalizedString("Werkverträge", comment: "Phase description for work contracts"),
               phasePercentage: 1,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausführung", comment: "Phase name for execution"),
               phaseDescription: NSLocalizedString("Gestalterische Bauleitung", comment: "Phase description for design site management"),
               phasePercentage: 6,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Ausführung", comment: "Phase name for execution"),
               phaseDescription: NSLocalizedString("Bauleitung & Kostenkontrolle", comment: "Phase description for site management and cost control"),
               phasePercentage: 23,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
               phaseDescription: NSLocalizedString("Inbetriebnahme", comment: "Phase description for commissioning"),
               phasePercentage: 1,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
               phaseDescription: NSLocalizedString("Dokumentation Bauwerk", comment: "Phase description for building documentation"),
               phasePercentage: 1,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
               phaseDescription: NSLocalizedString("Leitung Garantiearbeiten", comment: "Phase description for management of warranty works"),
               phasePercentage: 1.5,
               phaseHourlyRate: 130
           ),
           FeePhase(
               phaseName: NSLocalizedString("Abschluss", comment: "Phase name for completion"),
               phaseDescription: NSLocalizedString("Schlussrechnung", comment: "Phase description for final invoice"),
               phasePercentage: 1,
               phaseHourlyRate: 130
           )
       ]


    // Struct to represent a phase with its fee phases and subtotals
    struct Phase {
        let name: String
        let feePhases: [FeePhase]
        let subtotalPercentage: Double
        let subtotal: Double
    }

    // Generate phases with subtotals
    private var phases: [Phase] {
        var phases: [Phase] = []
        var currentPhaseName: String? = nil
        var currentFeePhases: [FeePhase] = []
        var currentSubtotalPercentage: Double = 0.0
        var currentSubtotal: Double = 0.0

        for feePhase in feePhases {
            if feePhase.phaseName != currentPhaseName {
                if let name = currentPhaseName {
                    phases.append(Phase(name: name, feePhases: currentFeePhases, subtotalPercentage: currentSubtotalPercentage, subtotal: currentSubtotal))
                }
                currentPhaseName = feePhase.phaseName
                currentFeePhases = []
                currentSubtotalPercentage = 0.0
                currentSubtotal = 0.0
            }
            currentFeePhases.append(feePhase)
            currentSubtotalPercentage += feePhase.phasePercentage
            currentSubtotal += feePhase.phasePercentage * buildingProject.totalFee / 100
        }
        // Append the last phase
        if let name = currentPhaseName {
            phases.append(Phase(name: name, feePhases: currentFeePhases, subtotalPercentage: currentSubtotalPercentage, subtotal: currentSubtotal))
        }
        return phases
    }

    // Calculate grand totals
    private var grandTotalPercentage: Double {
        feePhases.reduce(0) { $0 + $1.phasePercentage }
    }

    private var grandTotalFee: Double {
        feePhases.reduce(0) { $0 + ($1.phasePercentage * buildingProject.totalFee / 100) }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) { // Use VStack to control spacing between phases
                    Grid(alignment: .top, verticalSpacing: 10) {
                        Spacer().frame(height: 20) // Adjusted spacer for layout

                        // Header Row with 3 columns
                        GridRow {
                            Text("Phase")
                                .gridColumnAlignment(.leading)
                            Text("Prozent")
                                .gridColumnAlignment(.trailing)
                            Text("Honorar")
                                .gridColumnAlignment(.trailing)
                        }

                        dashDivider()

                        ForEach(phases, id: \.name) { phase in
                            // Display the phase header with subtotal percentage and subtotal
                            GridRow {
                                Text(phase.name)
                                    .fontWeight(.black)
                                    .gridColumnAlignment(.leading)
                                Text(String(format: "%.2f", phase.subtotalPercentage))
                                    .fontWeight(.bold)
                                    .gridColumnAlignment(.trailing)
                                Text(String(formatNumber2(phase.subtotal)))
                                    .fontWeight(.bold)
                                    .gridColumnAlignment(.trailing)
                            }

                            // Display the fee phases
                            ForEach(phase.feePhases, id: \.phaseDescription) { feePhase in
                                GridRow {
                                    // Merged fee phase and description into one column
                                    Text(feePhase.phaseDescription)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .gridColumnAlignment(.leading)
                                    Text(String(format: "%.2f", feePhase.phasePercentage))
                                        .gridColumnAlignment(.trailing)
                                    Text(String(formatNumber2(feePhase.phasePercentage * buildingProject.totalFee / 100)))
                                        .gridColumnAlignment(.trailing)
                                }
                            }

                            // Add spacer between phases
                            Spacer().frame(height: 15) // Adjust the height as needed
                        }

                        // Add grand total row
                        dashDivider()

                        GridRow {
                            Text("Total")
                                .fontWeight(.black)
                                .gridColumnAlignment(.leading)
                            Text(String(format: "%.2f", grandTotalPercentage))
                                .fontWeight(.bold)
                                .gridColumnAlignment(.trailing)
                            Text(String(formatNumber2(grandTotalFee)))
                                .fontWeight(.bold)
                                .gridColumnAlignment(.trailing)
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

struct feePercentageView_Previews: PreviewProvider {
    @State static var isPresented = false

    static var previews: some View {
        feePercentageView(isPresented: $isPresented)
            .environmentObject(GlobalSettings())
            .environmentObject(BuildingProject())
    }
}
