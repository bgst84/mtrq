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
    @Published var hourlyRate = 130.0
}

class GlobalSettings: ObservableObject {
    @Published var hourlyRate: String = "130"
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
