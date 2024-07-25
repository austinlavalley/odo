//
//  SettingsView.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    
    @State private var showInstruction = true
    
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
                    VStack {
                        
                        Text("yo")
                        
                        
                        Spacer()
                        Button("Close") { withAnimation(.spring) { showInstruction = false }}
                        
                    }.padding()
                    
                    
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
