//
//  ContentView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var hkManager = HealthKitManager.shared

    var body: some View {
        VStack {
            Spacer()
            
            OdometerView(steps: hkManager.stepCountToday)
            
            Spacer()
            
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
                
                HStack {
                    Text("Day Start - 24h period")
                }
                .frame(maxWidth: .infinity, maxHeight: 72)
                .font(.subheadline).fontDesign(.monospaced).bold()
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(.white, lineWidth: 2) }
                
                HStack {
                    Text("Day Start - 24h period")
                }
                .frame(maxWidth: .infinity, maxHeight: 72)
                .font(.subheadline).fontDesign(.monospaced).bold()
                .foregroundStyle(.white)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(.white, lineWidth: 2) }
                
                
            }.padding()
        }
    }
}

#Preview {
    ContentView()
}
