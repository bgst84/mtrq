//
//  data.swift
//  metrique
//
//  Created by Yves Seiler on 07.07.23.
//

import Foundation
import SwiftUI

let kantoneMietzins: [String: String] = [
    "Zürich": String(formatNumber(19.6 * 12)),
    "Bern": String(formatNumber(15.2 * 12)),
    "Luzern": String(formatNumber(15.6 * 12)),
    "Uri": String(formatNumber(13.6 * 12)),
    "Schwyz": String(formatNumber(16.8 * 12)),
    "Obwalden": String(formatNumber(14.9 * 12)),
    "Nidwalden": String(formatNumber(15.8 * 12)),
    "Glarus": String(formatNumber(13.3 * 12)),
    "Zug": String(formatNumber(19.4 * 12)),
    "Freiburg": String(formatNumber(15.1 * 12)),
    "Solothurn": String(formatNumber(14.1 * 12)),
    "Basel-Stadt": String(formatNumber(18.5 * 12)),
    "Basel-Landschaft": String(formatNumber(17 * 12)),
    "Schaffhausen": String(formatNumber(14.2 * 12)),
    "Appenzell AR": String(formatNumber(13.5 * 12)),
    "Appenzell IR": String(formatNumber(14.8 * 12)),
    "St. Gallen": String(formatNumber(14.5 * 12)),
    "Graubünden": String(formatNumber(15.4 * 12)),
    "Aargau": String(formatNumber(15.5 * 12)),
    "Thurgau": String(formatNumber(13.9 * 12)),
    "Tessin": String(formatNumber(14.0 * 12)),
    "Waadt": String(formatNumber(18.1 * 12)),
    "Wallis": String(formatNumber(14.2 * 12)),
    "Neuenburg": String(formatNumber(13 * 12)),
    "Genf": String(formatNumber(19.9 * 12)),
    "Jura": String(formatNumber(11.8 * 12))
]

let groupSpacer: Double = 15
let doubleGroupSpacer: Double = 30

struct resultGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding(10)
            //.background(RoundedRectangle(cornerRadius: 0).fill(Color(.resultField)))
            .border(Color("lineColor"))
    }
}

struct subResultGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding(10)
            //.background(RoundedRectangle(cornerRadius: 0).fill(Color(.subResultField)))
            .border(Color("lineColor"))
    }
}
