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
        _stepsArr = State(initialValue: OdometerView.createStepsArray(from: steps.wrappedValue))
    }
    
    
    static func createStepsArray(from number: Int) -> [Int] {
        let digits = String(number).compactMap { Int(String($0)) }
        let paddingCount = max(0, 6 - digits.count)
        return Array(repeating: 0, count: paddingCount) + digits
    }
    
    
    var body: some View {
        HStack(spacing: 4) {
            
            DigitWheel(digit: stepsArr[0])
            DigitWheel(digit: stepsArr[1])
            DigitWheel(digit: stepsArr[2])
            DigitWheel(digit: stepsArr[3])
            DigitWheel(digit: stepsArr[4])
            DigitWheel(digit: stepsArr[5])


        }
        .background(.black)
        
        .onChange(of: steps) { _, newSteps in
            withAnimation {
                stepsArr = OdometerView.createStepsArray(from: newSteps)

            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    OdometerView(steps: .constant(123456))
}



struct DigitWheel: View {
    var digit: Int
    
    var body: some View {
        ZStack {
            OdometerRect()
                .frame(width: 48, height: 72)
            
            Text(digit.description)
                .fontDesign(.monospaced)
                .font(.largeTitle).bold()
                .foregroundStyle(.white)
            
                .contentTransition(.numericText())
        }
    }
    
    
    struct OdometerRect: View {
        let darkGray = Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255)

        var body: some View {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.black, darkGray, .black]), startPoint: .top, endPoint: .bottom))
                .frame(width: 48, height: 72)
        }
    }
}
