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
                                        if dragAmount > dragThreshold || velocityY > 300 {
                                            withAnimation(.spring()) {
                                                showSettings = false
                                                offset = 0
                                            }
                                        } else {
                                            withAnimation(.spring()) {
                                                offset = geometry.size.height
                                            }
                                        }
                                    } else {
                                        if dragAmount < -dragThreshold || velocityY < -300 {
                                            withAnimation(.spring()) {
                                                showSettings = true
                                                offset = geometry.size.height
                                            }
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
