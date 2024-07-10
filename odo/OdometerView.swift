//
//  OdometerView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct OdometerView: View {
    
    @Binding var steps: Int
    
    @State private var stepsArr: [Int]
    
    init(steps: Binding<Int>) {
        self._steps = steps
        _stepsArr = State(initialValue: String(steps.wrappedValue).compactMap { Int(String($0)) })
        
    }
    
    
    var body: some View {
        HStack(spacing: 2) {
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[0].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

            }
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[1].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

            }
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[2].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

            }
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[3].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

            }
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[4].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())
                
            }
            
            ZStack {
                OdometerRect()
                    .frame(width: 48, height: 72)
                
                Text(stepsArr[5].description)
                    .font(.largeTitle).bold()
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

            }
            

        }
        .background(.black)
        
        .onChange(of: steps) { _, newSteps in
            withAnimation {
                stepsArr = String(newSteps).compactMap { Int(String($0)) }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    OdometerView(steps: .constant(123456))
}



struct OdometerRect: View {
    let darkGray = Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255)

    var body: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [.black, darkGray, .black]), startPoint: .top, endPoint: .bottom))
            .frame(width: 48, height: 72)
    }
}
