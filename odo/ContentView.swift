//
//  ContentView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var hkManager = HealthKitManager.shared

    var body: some View {
        VStack {
            OdometerView(steps: $hkManager.stepCountToday)
        }
    }
}

#Preview {
    ContentView()
}
