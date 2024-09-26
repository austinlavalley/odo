//
//  StepCountWidget.swift
//  StepCountWidget
//
//  Created by Austin Lavalley on 7/14/24.
//


import WidgetKit
import SwiftUI

struct StepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepCountEntry {
        StepCountEntry(date: Date(), stepCount: 0, isWeekly: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepCountEntry) -> ()) {
        let isWeekly = (context.family == .systemLarge)
        let key = isWeekly ? "weeklyStepCount" : "dailyStepCount"
        let entry = StepCountEntry(date: Date(), stepCount: UserDefaults(suiteName: "group.odo")?.integer(forKey: key) ?? 0, isWeekly: isWeekly)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let isWeekly = (context.family == .systemLarge)
        let healthKitManager = HealthKitManager.shared
        
        healthKitManager.fetchStepCounts()
        
        let currentDate = Date()
        let key = isWeekly ? "weeklyStepCount" : "dailyStepCount"
        
        // Use a DispatchGroup to ensure we have the latest data before creating the timeline
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Give some time for fetchStepCounts to complete
            group.leave()
        }
        
        group.notify(queue: .main) {
            let stepCount = UserDefaults(suiteName: "group.odo")?.integer(forKey: key) ?? 0
            let entry = StepCountEntry(date: currentDate, stepCount: stepCount, isWeekly: isWeekly)
            
            let timeline = Timeline(entries: [entry], policy: .after(currentDate.addingTimeInterval(15 * 60))) // Update every 15 minutes
            completion(timeline)
        }
    }
}

struct DailyStepCountWidget: Widget {
    let kind: String = "DailyStepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepCountProvider()) { entry in
            StepCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Step Count")
        .description("Displays your daily step count.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WeeklyStepCountWidget: Widget {
    let kind: String = "WeeklyStepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepCountProvider()) { entry in
            StepCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weekly Step Count")
        .description("Displays your steps for the current week.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
