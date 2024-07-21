//
//  ContentView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var hkManager = HealthKitManager.shared
    @State private var offset: CGFloat = 0
    @State private var showSettings = false
    @State private var isDragging = false

    private let dragThreshold: CGFloat = 25 // Adjust this value as needed

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    Color.clear
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                }
                                .onEnded { value in
                                    isDragging = false
                                    let dragAmount = -value.translation.height
                                    let velocityY = value.predictedEndLocation.y - value.location.y
                                    
                                    if showSettings {
                                        // Currently showing settings, check for upward drag
                                        if dragAmount < -dragThreshold || velocityY > 300 {
                                            withAnimation(.spring()) {
                                                showSettings = false
                                                offset = 0
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = geometry.size.height // Stay in settings view
                                            }
                                        }
                                    } else {
                                        // Currently showing main view, check for downward drag
                                        if dragAmount > dragThreshold || velocityY < -300 {
                                            withAnimation(.spring()) {
                                                showSettings = true
                                                offset = geometry.size.height
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = 0 // Stay in main view
                                            }
                                        }
                                    }
                                }
                        )
                    
                    MainView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: -offset)
                    
                    SettingsView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: geometry.size.height - offset)
                }
                
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            withAnimation(.spring()) {
                                showSettings.toggle()
                                offset = showSettings ? geometry.size.height : 0
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
