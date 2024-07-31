//
//  SettingsView.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @AppStorage("weekStartDay") private var weekStartDay: Int = 2 // Default to Monday (2)
    
    @StateObject var hkManager = HealthKitManager.shared

    @State private var showInstruction = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Spacer()
                
                Picker("Week Starts On", selection: $weekStartDay) {
                    Text("Sunday").tag(1)
                    Text("Monday").tag(2)
                    Text("Tuesday").tag(3)
                    Text("Wednesday").tag(4)
                    Text("Thursday").tag(5)
                    Text("Friday").tag(6)
                    Text("Saturday").tag(7)
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: weekStartDay) { _, _ in
                    hkManager.readStepCountThisWeek()
                }
                
                Button {
                    withAnimation(.spring) {
                        showInstruction.toggle()
                    }
                } label: {
                    Label("How to use", systemImage: "")
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
                        
                        Text("Using the odo widget").font(.title)
                        
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
