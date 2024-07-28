//
//  StepCountWidgetView.swift
//  odo
//
//  Created by Austin Lavalley on 7/14/24.
//

import SwiftUI
import WidgetKit



struct StepCountWidgetEntryView : View {
    @Environment(\.colorScheme) var colorScheme

    var entry: StepCountEntry

    var body: some View {
        VStack(spacing: 8) {
            Text("Steps Today").foregroundStyle(colorScheme != .dark ? .black.opacity(0.5) : .white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
            OdometerView(steps: entry.stepCount, darkMode: colorScheme == .dark)
//            Text("\(entry.date.description)").foregroundStyle(.white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? .black : .white)
        .containerBackground(colorScheme == .dark ? .black : .white, for: .widget)
    }
}





struct StepCountWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepCountWidgetEntryView(entry: StepCountEntry(date: Date(), stepCount: 3852))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
