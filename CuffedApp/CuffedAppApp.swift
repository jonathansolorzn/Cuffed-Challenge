//
//  CuffedAppApp.swift
//  CuffedApp
//
//  Created by Jonathan on 11/2/23.
//

import SwiftUI

@main
struct CuffedAppApp: App {
    @StateObject var realmManager = RealmManager(name: "cuffApp")
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(realmManager)
        }
    }
}
