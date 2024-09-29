//
//  SettingsView.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI
import WidgetKit

struct WeekStartPicker: View {
    @StateObject var hkManager = HealthKitManager.shared

    @AppStorage("weekStartDay", store: UserDefaults(suiteName: "group.odo")) private var weekStartDay: Int = 2

    var body: some View {
        Picker("Week Starts On", selection: $weekStartDay) {
            Text("Sunday").tag(1)
            Text("Monday").tag(2)
            Text("Tuesday").tag(3)
            Text("Wednesday").tag(4)
            Text("Thursday").tag(5)
            Text("Friday").tag(6)
            Text("Saturday").tag(7)
        }
        .bold()
        .pickerStyle(.wheel)
        
        
        .onChange(of: weekStartDay) { _, _ in
            hkManager.fetchStepCounts()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    
    @StateObject var hkManager = HealthKitManager.shared

    @State private var showInstruction = false
    @State private var showStartDay = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Spacer()
                
                Button {
                    withAnimation(.spring) {
                        showInstruction.toggle()
                    }
                } label: {
                    Label("How to use", systemImage: "")
                        .labelStyle(SettingsButton())
                }
                
                Button {
                    withAnimation(.spring) {
                        showStartDay.toggle()
                    }
                } label: {
                    Label("Week start day", systemImage: "")
                        .labelStyle(SettingsButton())
                }
                
                
                Button {
                    openURL(URL(string: "https://odo.austinlavalley.com")!)
                } label: {
                    Label("Terms & privacy", systemImage: "")
                        .labelStyle(SettingsButton())
                }
                
                Button {
                    openURL(URL(string: "https://odo.austinlavalley.com")!)
                } label: {
                    Label("Feedback", systemImage: "")
                        .labelStyle(SettingsButton())
                }
                
                
                Spacer()
                Text("by Austin in Austin for Austin").font(.caption).bold().foregroundColor(.secondary).padding(.bottom, 12)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .foregroundColor(.white)
            .font(.title)
            
            
            if showInstruction {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring) {
                            showInstruction = false
                        }
                    }
                
                VStack {
                    VStack(spacing: 24) {
                        
                        Text("Using the odo widget").font(.title2)
                        
                        VStack(spacing: 24) {
                            Text("To add our widget to your device, long-press on your home screen and tap the '+' button at the top.")
                            Text("Then scroll down or search for 'odo' to add our widget to your home screen.")
                        }.font(.subheadline).padding()
                        
                        Spacer()
                        Button {
                            withAnimation(.spring) { showInstruction = false }
                        } label: {
                            Label("Close", systemImage: "")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        
                    }
                    .padding(.vertical, 24)
                    .padding()
                    .bold()
                    .multilineTextAlignment(.center)
                    
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 420)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
            }
            
            if showStartDay {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring) {
                            showStartDay = false
                        }
                    }
                
                VStack {
                    VStack {
                        Spacer()
                        VStack(spacing: 0) {
                            Text("Starting day of week").font(.title2)
                            Text("Choose the preferred day you'd like us to calculate your weekly step count from.").font(.subheadline).padding()
                        }.multilineTextAlignment(.center)
                        
                        WeekStartPicker()
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring) { showStartDay = false }
                        } label: {
                            Label("Save and close", systemImage: "")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.padding(.horizontal)
                        
                        Spacer()
                    }.bold()
                }
                .frame(maxWidth: .infinity, maxHeight: 480)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
            }
            
            
        }
    }
}





#Preview {
    SettingsView()
}





struct SettingsButton: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
                .frame(maxWidth: .infinity, maxHeight: 72)
                .font(.subheadline).fontDesign(.monospaced).bold()
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(.white, lineWidth: 2) }
        }
    }
}
