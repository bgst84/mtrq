import SwiftUI
import SceneKit

// Enum for navigation destinations
private enum MenuDestination: Hashable {
    case fee, cost, returns, costRent, mortgage, settings, camera
}

struct menuView: View {
    @State private var path: [MenuDestination] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and title
                    VStack(spacing: 8) {
                        Image("metrique_icon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .shadow(radius: 6)
                            .accessibilityLabel("Metrique App Icon")
                        
                    }
                    .padding(.top, 32)
                    
                    // Menu Cards
                    VStack(spacing: 0) {
                        menuCard(
                            image: "honorar",
                            title: "Architekten-Honorar",
                            subtitle: "Berechnung Honorar anhand der Baukosten.",
                            destination: .fee
                        )
                        menuCard(
                            image: "erstellungskosten",
                            title: "Erstellungskosten",
                            subtitle: "Berechnung mögliche Volumetrie und Erstellungskosten.",
                            destination: .cost
                        )
                        menuCard(
                            image: "return",
                            title: "Brutto-Rendite",
                            subtitle: "Berechnung zu erwartende Brutto-Rendite bei Vermietung.",
                            destination: .returns
                        )
                        menuCard(
                            image: "kostenmiete",
                            title: "Kostenmiete",
                            subtitle: "Berechnung des kostendeckenden Mietzins ohne Gewinnanteil.",
                            destination: .costRent
                        )
                        menuCard(
                            image: "hypothek2",
                            title: "Hypothek",
                            subtitle: "Berechnung Hypothek und Tragbarkeit.",
                            destination: .mortgage
                        )
                        // Settings (liquid glass SceneView example)
                        menuCardScene(
                            title: "Über uns",
                            subtitle: "Über uns & Kontakt",
                            destination: .settings
                        )
//                        menuCardScene(
//                            title: "Kamera",
//                            subtitle: "Foto & Analyse",
//                            destination: .camera
//                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 0)
                }
            }
            .navigationDestination(for: MenuDestination.self) { dest in
                switch dest {
                    case .fee: feeView()
                    case .cost: costView()
                    case .returns: returnView()
                    case .costRent: costRentView()
                    case .mortgage: mortgageAffordability()
                    case .settings: settingsView()
                    case .camera: camView()
                }
            }
        }
    }
    
    // MARK: - Menu Card (image)
    @ViewBuilder
    private func menuCard(image: String, title: LocalizedStringKey, subtitle: LocalizedStringKey, destination: MenuDestination) -> some View {
        Button {
            path.append(destination)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            HStack(spacing: 15) {
                ZStack {
                    Image(image)
                        .resizable()
                        .clipShape(Circle())
                        .padding(5)
                        .shadow(radius: 5)

                }
                .frame(width: 100, height: 100)

                .accessibilityLabel(title)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3).bold()
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
    
    // MARK: - Menu Card (SceneKit view)
    @ViewBuilder
    private func menuCardScene(title: LocalizedStringKey, subtitle: LocalizedStringKey, destination: MenuDestination) -> some View {
        Button {
            path.append(destination)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            HStack(spacing: 15) {
                ZStack {
                    SceneView(
                        scene: scene,
                        pointOfView: cameraNode,
                        options: []
                    )
                    .clipShape(Circle())
                    .padding(5) // shows a subtle glass rim
                    .shadow(radius: 5)

                }
                .frame(width: 100, height: 100)
                .accessibilityLabel(title)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3).bold()
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

// MARK: - Preview
#Preview {
    menuView()
        .environmentObject(GlobalSettings())
        .environmentObject(BuildingProject())
}
