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
            Text(entry.isWeekly ? "Steps this week" : "Steps today").foregroundStyle(colorScheme != .dark ? .black.opacity(0.5) : .white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
            OdometerView(steps: entry.stepCount, darkMode: colorScheme == .dark)
//            Text("\(entry.date.description)").foregroundStyle(.white.opacity(0.5)).textCase(.uppercase).font(.caption).fontDesign(.monospaced).bold()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? Color(red: 17/255, green: 17/255, blue: 17/255) : Color(red: 231/255, green: 231/255, blue: 232/255))
        .containerBackground(colorScheme == .dark ? Color(red: 17/255, green: 17/255, blue: 17/255) : Color(red: 231/255, green: 231/255, blue: 232/255), for: .widget)
    }
}





struct StepCountWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepCountWidgetEntryView(entry: StepCountEntry(date: Date(), stepCount: 3852, isWeekly: true))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
