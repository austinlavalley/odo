//
//  StepCountWidget.swift
//  StepCountWidget
//
//  Created by Austin Lavalley on 7/14/24.
//


import WidgetKit
import SwiftUI

struct DailyStepCountWidget: Widget {
    let kind: String = "DailyStepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyStepCountProvider()) { entry in
            StepCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Step Count")
        .description("Displays your daily step count.")
        .supportedFamilies([.systemMedium])
    }
}

struct DailyStepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepCountEntry {
        StepCountEntry(date: Date(), stepCount: 0, isWeekly: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepCountEntry) -> ()) {
        let entry = StepCountEntry(date: Date(), stepCount: UserDefaults(suiteName: "group.odo")?.integer(forKey: "dailyStepCount") ?? 888888, isWeekly: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepCountEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let stepCount = UserDefaults(suiteName: "group.odo")?.integer(forKey: "dailyStepCount") ?? 999999
        let entry = StepCountEntry(date: currentDate, stepCount: stepCount, isWeekly: false)
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}



struct WeeklyStepCountWidget: Widget {
    let kind: String = "WeeklyStepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeeklyStepCountProvider()) { entry in
            StepCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weekly Step Count")
        .description("Displays your steps for the current week.")
        .supportedFamilies([.systemMedium])
    }
}


struct WeeklyStepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepCountEntry {
        StepCountEntry(date: Date(), stepCount: 0, isWeekly: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepCountEntry) -> ()) {
        let entry = StepCountEntry(date: Date(), stepCount: UserDefaults(suiteName: "group.odo")?.integer(forKey: "weeklyStepCount") ?? 888888, isWeekly: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepCountEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let stepCount = UserDefaults(suiteName: "group.odo")?.integer(forKey: "weeklyStepCount") ?? 999999
        let entry = StepCountEntry(date: currentDate, stepCount: stepCount, isWeekly: true)
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}
