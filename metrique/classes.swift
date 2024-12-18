//
//  classes.swift
//  metrique
//
//  Created by Yves Seiler on 06.12.2023.
//

import Foundation
import SwiftUI

class BuildingProject: ObservableObject {
    @Published var totalFee = 0.0
    @Published var totalHours = 0.0
    @Published var hourlyRate = 130.0 //muss weg zugusten von => GlobalSettings.hourlyRate
}

class GlobalSettings: ObservableObject {
    @Published var hourlyRate: String = "130"
    @Published var kantoneMietzins: [String: Double] = [:] // Adding kantoneMietzins
    @Published var rentDataDate: String = ""

        init() {
            updateKantoneMietzins() // Automatically fetch data during initialization
        }

        func updateKantoneMietzins() {
            let urlString = "https://metrique.app/data/rent.csv"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Failed to fetch kantoneMietzins: \(error.localizedDescription)")
                    return
                }

                guard let data = data, let fileContent = String(data: data, encoding: .utf8) else {
                    print("Data or encoding error")
                    return
                }

                var updatedData: [String: Double] = [:]
                let lines = fileContent.components(separatedBy: .newlines)

                if let firstLine = lines.first, !firstLine.isEmpty {
                    let components = firstLine.components(separatedBy: ",")
                    if components.count > 1 { // Ensure there are at least two items
                        DispatchQueue.main.async {
                            self.rentDataDate = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            print("Dataset date: \(self.rentDataDate)") // Debug output
                        }
                    }
                }
                
                for line in lines.dropFirst() where !line.isEmpty {
                    let components = line.components(separatedBy: ",")
                    if components.count == 2 {
                        let canton = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        if let monthlyValue = Double(components[1].trimmingCharacters(in: .whitespacesAndNewlines)) {
                            let yearlyValue = monthlyValue * 12
                            updatedData[canton] = yearlyValue
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.kantoneMietzins = updatedData
                    print("kantoneMietzins updated successfully: \(self.kantoneMietzins)")
                }
            }

            task.resume()
        }
}

struct FeePhase: Identifiable, Hashable {
    var id = UUID()
    var phaseName = ""
    var phaseDescription = ""
    var phasePercentage = 0.0
    var phaseHours = 0.0
    var phaseFee = 0.0
    var phaseHourlyRate = 0.0
    
}
