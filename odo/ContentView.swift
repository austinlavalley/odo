//
//  ContentView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var stepCounter = 123456
    
    var body: some View {
        VStack {
            OdometerView(steps: $stepCounter)
            
            Button("+1") {
                stepCounter += 1
            }
            
            Button("Random") {
                stepCounter = .random(in: 000000...999999)
            }
            
            Text(stepCounter.description)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
