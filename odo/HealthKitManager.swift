//
//  HealthKitManager.swift
//  odo
//
//  Created by Austin Lavalley on 7/11/24.
//

import Foundation
import HealthKit
import WidgetKit
import Combine
import SwiftUI
import BackgroundTasks

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    var healthStore = HKHealthStore()
    
    @Published var stepCountToday: Int = 0
    @Published var stepCountThisWeek: Int = 0
    @Published var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0]
    
    @AppStorage("weekStartDay", store: UserDefaults(suiteName: "group.odo")) private var weekStartDay: Int = 2  // Default to Monday (2)
    
    
    
    private var observerQuery: HKObserverQuery?
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let toReads = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available!")
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: toReads) { [weak self] success, error in
            if success {
                self?.setupObserverQuery()
                self?.fetchStepCounts()
            } else {
                print("Authorization failed: \(String(describing: error))")
            }
        }
    }
    
    func setupObserverQuery() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        observerQuery = HKObserverQuery(sampleType: stepCountType, predicate: nil) { [weak self] _, _, error in
            if let error = error {
                print("Observer Query Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchStepCounts()
            }
        }
        
        if let query = observerQuery {
            healthStore.execute(query)
        }
    }
    
    func fetchStepCounts(weekStartDay: Int? = nil) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        var calendar = Calendar(identifier: .gregorian)
        let startDay = weekStartDay ?? self.weekStartDay
        calendar.firstWeekday = startDay
        
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        let weekdayOffset = (calendar.component(.weekday, from: today) - startDay + 7) % 7
        guard let startOfWeek = calendar.date(byAdding: .day, value: -weekdayOffset, to: today) else {
            print("Failed to calculate the start date of the week.")
            return
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { [weak self] _, result, error in
            guard let self = self, let result = result else {
                if let error = error {
                    print("An error occurred while retrieving step counts: \(error.localizedDescription)")
                }
                return
            }
            
            var totalWeeklySteps = 0
            var todaySteps = 0
            
            result.enumerateStatistics(from: startOfWeek, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    totalWeeklySteps += steps
                    
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    if calendar.isDate(statistics.startDate, inSameDayAs: today) {
                        todaySteps = steps
                    }
                    
                    DispatchQueue.main.async {
                        self.thisWeekSteps[day] = steps
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.stepCountToday = todaySteps
                self.stepCountThisWeek = totalWeeklySteps
                
                UserDefaults(suiteName: "group.odo")?.set(todaySteps, forKey: "dailyStepCount")
                UserDefaults(suiteName: "group.odo")?.set(totalWeeklySteps, forKey: "weeklyStepCount")
                
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
        healthStore.execute(query)
    }
    
    func handleBackgroundRefresh(task: BGAppRefreshTask) {
        fetchStepCounts()
        task.setTaskCompleted(success: true)
    }
}
