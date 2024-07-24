//
//  SettingsView.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Button {
                withAnimation {
                    
                }
            } label: {
                Label("dark mode", systemImage: "")
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
