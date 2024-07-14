//
//  StepCountWidget.swift
//  StepCountWidget
//
//  Created by Austin Lavalley on 7/14/24.
//

import WidgetKit
import SwiftUI



struct StepCountWidget: Widget {
    let kind: String = "StepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepCountProvider()) { entry in
            StepCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Step Count")
        .description("Displays your daily step count.")
        .supportedFamilies([.systemMedium])  // Only medium size
    }
}





struct StepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepCountEntry {
        StepCountEntry(date: Date(), stepCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepCountEntry) -> ()) {
        let entry = StepCountEntry(date: Date(), stepCount: UserDefaults(suiteName: "group.odo")?.integer(forKey: "widgetStep") ?? 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepCountEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let stepCount = UserDefaults(suiteName: "group.odo")?.integer(forKey: "widgetStep") ?? 0
        let entry = StepCountEntry(date: currentDate, stepCount: stepCount)
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}






struct StepCountEntry: TimelineEntry {
    let date: Date
    let stepCount: Int
}





struct StepCountWidgetEntryView : View {
    var entry: StepCountProvider.Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Steps Today")
                    .font(.headline)
                Text("\(entry.stepCount)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: "figure.walk")
                .font(.system(size: 40))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}





struct StepCountWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepCountWidgetEntryView(entry: StepCountEntry(date: Date(), stepCount: 5000))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium Widget")
    }
}
