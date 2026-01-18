import SwiftUI
import SceneKit

struct settingsView: View {
    @State private var lastRotation: Float = 90.0
    @State private var rotation: Float = 0.0
    @FocusState private var isFocused: Bool

    @State private var changelog: [VersionGroup] = []
    @State private var isLoading = false

    var currentLocale: String {
        Locale.current.language.languageCode?.identifier ?? "en"
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    SceneView(scene: scene, pointOfView: cameraNode, options: [])
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let translation = value.translation
                                    let newRotation = -Float(translation.width) * .pi / 180
                                    rotation = lastRotation + newRotation
                                    rotateCameraAroundOrigin(rotation: rotation)
                                }
                                .onEnded { value in
                                    let translation = value.translation
                                    let newRotation = -Float(translation.width) * .pi / 180
                                    lastRotation += newRotation
                                }
                        )
                        .frame(height: 300)
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading) {
                    Group {
                        Text("Über uns")
                            .font(.title)
                            .fontWeight(.bold)

                        Spacer().frame(height: 5)

                        Text("Diese App wird laufend weiterentwickelt und um Funktionen ergänzt.")

                        Spacer()

                        Text("Für Fragen, Anmerkungen und Feedback stehen wir per Mail zur Verfügung:")

                        Spacer()

                        Link("mail@metrique.app", destination: URL(string: "mailto:metrique.app")!)
                    }

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("Version: " + UIApplication.version)
                        }
                    }

                    // Changelog Section
                    if isLoading {
                        ProgressView("Lade Änderungen...")
                            .padding()
                    } else {
                        VStack(alignment: .leading) {
                            Text("Changelog")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)

                            ForEach(changelog) { versionGroup in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Version \(versionGroup.version) – \(versionGroup.date)")
                                        .font(.headline)

                                    ForEach(versionGroup.entries) { entry in
                                        HStack(alignment: .top) {
                                            Text("•")
                                            Text(entry.description)
                                                .font(.body)
                                        }
                                    }
                                }
                                .padding(.vertical, 5)

                                Divider()
                            }
                        }
                    }
                }
                .padding(25.0)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onTapGesture {
            if isFocused {
                isFocused = false
            }
        }
        .onAppear {
            loadChangelog()
        }
    }

    func compareVersions(_ version1: String, _ version2: String) -> Bool {
        let components1 = version1.split(separator: ".").compactMap { Int($0) }
        let components2 = version2.split(separator: ".").compactMap { Int($0) }
        
        let maxLength = max(components1.count, components2.count)
        
        for i in 0..<maxLength {
            let v1 = i < components1.count ? components1[i] : 0
            let v2 = i < components2.count ? components2[i] : 0
            
            if v1 != v2 {
                return v1 > v2  // Descending order (newest first)
            }
        }
        
        return false  // Equal versions
    }
    
    func loadChangelog() {
        guard let url = URL(string: "https://metrique.app/data/changelog.csv") else { return }

        isLoading = true

        URLSession.shared.dataTask(with: url) { data, _, error in
            defer { isLoading = false }

            guard let data = data, error == nil,
                  let csvString = String(data: data, encoding: .utf8) else {
                print("Failed to load CSV:", error?.localizedDescription ?? "Unknown error")
                return
            }

            let lines = csvString.components(separatedBy: "\n").filter { !$0.isEmpty }
            guard lines.count > 1 else { return }

            var allEntries: [ChangelogEntry] = lines.dropFirst().compactMap { line -> ChangelogEntry? in
                let components = line.components(separatedBy: ",")
                guard components.count >= 4 else { return nil }
                return ChangelogEntry(
                    version: components[0],
                    date: components[1],
                    lang: components[2],
                    description: components[3]
                )
            }

            // Filter by current language
            allEntries = allEntries.filter { $0.lang == currentLocale }

            // Group entries by version
            let groupedDict = Dictionary(grouping: allEntries, by: { $0.version })

            let groupedEntries = groupedDict.map { (version, entries) in
                VersionGroup(version: version, date: entries.first?.date ?? "", entries: entries)
            }.sorted { compareVersions($0.version, $1.version) }

            DispatchQueue.main.async {
                changelog = groupedEntries
            }
        }.resume()
    }
}

// MARK: - Data Structures

struct ChangelogEntry: Identifiable {
    let id = UUID()
    let version: String
    let date: String
    let lang: String
    let description: String
}

struct VersionGroup: Identifiable {
    let id = UUID()
    let version: String
    let date: String
    let entries: [ChangelogEntry]
}

// MARK: - Preview

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView()
    }
}
