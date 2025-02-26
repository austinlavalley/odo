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
    @State private var dragOffset: CGFloat = 0
    @State private var showSettings = false
    @State private var isDragging = false

    private let dragThreshold: CGFloat = 50 // Adjusts drag distance to trigger view chance
    private let dragResistanceFactor: CGFloat = 0.35 // Adjusts stretchiness
    
    
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
                                    
                                    let dragAmount = value.translation.height
                                    
                                    // Applies diminishing effect
                                    dragOffset = dragAmount * dragResistanceFactor
                                }
                                .onEnded { value in
                                    isDragging = false
                                    let dragAmount = value.translation.height
                                    let velocityY = value.predictedEndLocation.y - value.location.y
                                    
                                    if showSettings {
                                    // If we're on the bottom view, and the user drags the minimum distance down OR drags down quick enough, trigger the animation to the above view
                                        if dragAmount > dragThreshold || velocityY > 300 {
                                            withAnimation(.spring()) {
                                                showSettings = false
                                                offset = 0
                                            }
                                    // If drags and doesn't meet either requirements for a transition, reset the view with a spring animation
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = geometry.size.height
                                            }
                                        }
                                        
                                    } else {
                                    // If we're on the top view, and the user drags the minimum distance up OR drags up quick enough, trigger the animation to the below view
                                        if dragAmount < -dragThreshold || velocityY < -300 {
                                            withAnimation(.spring()) {
                                                showSettings = true
                                                offset = geometry.size.height
                                            }
                                    // If drags and doesn't meet either requirements for a transition, reset the view with a spring animation
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = 0
                                            }
                                        }
                                    }
                                    withAnimation(.spring()) {
                                        dragOffset = 0 // Reset drag offset
                                    }
                                }
                        )
                    
                    MainView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: -offset + (showSettings ? 0 : dragOffset))

                    
                    SettingsView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: geometry.size.height - offset + (showSettings ? dragOffset : 0))
                }
                
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            withAnimation(.spring()) {
                                showSettings.toggle()
                                offset = showSettings ? geometry.size.height : 0
                            }
                        }) {
                            Image(systemName: showSettings ? "arrow.up" : "gear")
                                .foregroundColor(.white)
                        }
                    }
                }                
                
            }
            .background(Color.backgroundColorSet)
        }
    }
}



struct MainView: View {
    @StateObject var hkManager = HealthKitManager.shared
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            VStack(spacing: 24) {
                Text("Steps Today").foregroundStyle(.white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
                OdometerView(steps: hkManager.stepCountToday, darkMode: true)
            }
            
            VStack(spacing: 24) {
                Text("Steps this week").foregroundStyle(.white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
                OdometerView(steps: hkManager.thisWeekSteps.compactMap{ $0.value }.reduce(0, +), darkMode: true)
            }
            Spacer()
        }
    }
}





#Preview {
    ContentView()
}
