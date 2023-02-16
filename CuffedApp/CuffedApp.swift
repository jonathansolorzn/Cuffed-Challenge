//
//  CuffedAppApp.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

@main
struct CuffedApp: App {
    
    @StateObject var realmManager = RealmManager()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
               .environmentObject(realmManager)
        }
    }
}
