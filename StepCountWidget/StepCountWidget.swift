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
        .supportedFamilies([.systemMedium])
    }
}

struct StepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepCountEntry {
        StepCountEntry(date: Date(), stepCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepCountEntry) -> ()) {
        let entry = StepCountEntry(date: Date(), stepCount: UserDefaults(suiteName: "group.odo")?.integer(forKey: "widgetStep") ?? 888888)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepCountEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let stepCount = UserDefaults(suiteName: "group.odo")?.integer(forKey: "widgetStep") ?? 999999
        let entry = StepCountEntry(date: currentDate, stepCount: stepCount)
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}


