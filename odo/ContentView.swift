//
//  ContentView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var hkManager = HealthKitManager.shared

    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            VStack {
                if showSettings {
                    SettingsView()
                        .transition(.move(edge: .bottom))
                } else {
                    MainView()
                        .transition(.move(edge: .top))
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        withAnimation {
                            showSettings.toggle()
                        }
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}


struct MainView: View {
    @StateObject var hkManager = HealthKitManager.shared
    
    var body: some View {
        Spacer()
        
        OdometerView(steps: hkManager.stepCountToday)
        
        Spacer()
        
        VStack {
            

            
            
        }.padding()
    }
}





#Preview {
    ContentView()
}
