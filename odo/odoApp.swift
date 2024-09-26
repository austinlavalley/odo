//
//  odoApp.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

@main
struct OdoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var healthKitManager = HealthKitManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
        }
    }
}










extension Color {
        static var backgroundColorSet: Color {
            Color("background")
        }
    }
