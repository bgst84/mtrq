//
//  metrique.swift
//  metrique.app
//
//  Created by Yves Seiler on 17.06.23.
//

import SwiftUI

@main
struct metriqueApp: App {
    
    
    var globalSettings = GlobalSettings()
    var buildingProject = BuildingProject()
    
    var body: some Scene {
        WindowGroup {
            
            menuView()
                .environmentObject(globalSettings)
                .environmentObject(buildingProject)
        }
    }
}
