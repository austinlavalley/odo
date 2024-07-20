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
    @State private var extraOffset: CGFloat = 0

    private let dragSensitivity: CGFloat = 0.5
    private let springStiffness: CGFloat = 0.3

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
                                    let dragAmount = value.translation.height * dragSensitivity
                                    let proposedOffset = offset - dragAmount
                                    
                                    if proposedOffset < 0 {
                                        offset = 0
                                        extraOffset = proposedOffset * springStiffness
                                    } else if proposedOffset > geometry.size.height {
                                        offset = geometry.size.height
                                        extraOffset = (proposedOffset - geometry.size.height) * -springStiffness
                                    } else {
                                        offset = proposedOffset
                                        extraOffset = 0
                                    }
                                }
                                .onEnded { value in
                                    isDragging = false
                                    let velocityY = (value.predictedEndLocation.y - value.location.y) * dragSensitivity
                                    let shouldOpen = offset > geometry.size.height / 2 || velocityY < -300
                                    withAnimation(.spring()) {
                                        offset = shouldOpen ? geometry.size.height : 0
                                        showSettings = shouldOpen
                                        extraOffset = 0
                                    }
                                }
                        )
                    
                    MainView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: -offset - extraOffset)
                    
                    SettingsView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: geometry.size.height - offset + extraOffset)
                }
                .animation(isDragging ? .spring(response: 0.3, dampingFraction: 0.7) : .spring(), value: extraOffset)
                .animation(isDragging ? nil : .spring(), value: offset)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showSettings.toggle()
                            offset = showSettings ? UIScreen.main.bounds.height : 0
                            extraOffset = 0  // Reset extra offset when using toolbar
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
