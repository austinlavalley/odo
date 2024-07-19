//
//  SettingsView.swift
//  odo
//
//  Created by Austin Lavalley on 7/19/24.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack(spacing: 12) {
            
            Button {
                
            } label: {
                Label("Dark mode", systemImage: "")
                    .labelStyle(SettingsButton())
            }
            
            Button {
                //
            } label: {
                Label("Privacy policy", systemImage: "")
                    .labelStyle(SettingsButton())
            }
            
            Button {
                //
            } label: {
                Label("Feedback", systemImage: "")
                    .labelStyle(SettingsButton())
            }

            
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
