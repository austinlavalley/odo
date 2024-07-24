//
//  odoApp.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

@main
struct odoApp: App {
    @StateObject var notificationManager = NotificationManager()
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}











extension Color {
        static var backgroundColorSet: Color {
            Color("background")
        }
    }
