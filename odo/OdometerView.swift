//
//  OdometerView.swift
//  odo
//
//  Created by Austin Lavalley on 7/9/24.
//

import SwiftUI

struct OdometerView: View {
    
    @StateObject var hkManager = HealthKitManager.shared
    
    let darkMode: Bool
    var steps: Int
    @State private var stepsArr: [Int]
    
    
    init(steps: Int, darkMode: Bool) {
        self.steps = steps
        self.darkMode = darkMode
        _stepsArr = State(initialValue: OdometerView.createStepsArray(from: steps))

    }

    
    static func createStepsArray(from number: Int) -> [Int] {
        let digits = String(number).compactMap { Int(String($0)) }
        let paddingCount = max(0, 6 - digits.count)
        return Array(repeating: 0, count: paddingCount) + digits
    }
    
    
    var body: some View {
        HStack(spacing: 4) {
            
            DigitWheel(darkMode: darkMode, digit: stepsArr[0])
            DigitWheel(darkMode: darkMode, digit: stepsArr[1])
            DigitWheel(darkMode: darkMode, digit: stepsArr[2])
            DigitWheel(darkMode: darkMode, digit: stepsArr[3])
            DigitWheel(darkMode: darkMode, digit: stepsArr[4])
            DigitWheel(darkMode: darkMode, digit: stepsArr[5])


        }
        .background(darkMode ? .black : .white)
        
        .onChange(of: steps) { _, newSteps in
            withAnimation {
                stepsArr = OdometerView.createStepsArray(from: newSteps)

            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    OdometerView(steps: 123456, darkMode: false)
}



struct DigitWheel: View {
    let darkMode: Bool
    var digit: Int
    
    var body: some View {
        ZStack {
            OdometerRect(darkMode: darkMode)
                .frame(width: 48, height: 72)
            
            Text(digit.description)
                .fontDesign(.monospaced)
                .font(.largeTitle).bold()
                .foregroundStyle(darkMode ? .white : .black)
            
                .contentTransition(.numericText())
        }
    }
    
    
    struct OdometerRect: View {
        let darkMode: Bool
        
        let darkGray = Color(red: 45 / 255, green: 45 / 255, blue: 45 / 255)
        let lightGray = Color(red: 210 / 255, green: 210 / 255, blue: 210 / 255)

        var body: some View {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: darkMode ? [.black, darkGray, .black] : [.white, lightGray, .white]), startPoint: .top, endPoint: .bottom))
                .frame(width: 48, height: 72)
        }
    }
}
