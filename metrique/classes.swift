//
//  classes.swift
//  metrique
//
//  Created by Yves Seiler on 06.12.2023.
//

import Foundation
import SwiftUI

class BuildingProject: ObservableObject {
    @Published var publicTotalFee = 0.0
    @Published var publicTotalHours = 0.0
    @Published var publicHourlyRate = 0.0
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
