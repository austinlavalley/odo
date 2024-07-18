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


struct SettingsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Day Start - 24h period")
            }
            .frame(maxWidth: .infinity, maxHeight: 72)
            .font(.subheadline).fontDesign(.monospaced).bold()
            .foregroundStyle(.white)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay { RoundedRectangle(cornerRadius: 12).stroke(.white, lineWidth: 2) }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .foregroundColor(.white)
            .font(.title)
    }
}


#Preview {
    ContentView()
}
