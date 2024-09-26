//
//  HealthKitManager.swift
//  odo
//
//  Created by Austin Lavalley on 7/11/24.
//

//import Foundation
//import HealthKit
//import WidgetKit
//import Combine
//import SwiftUI
//
//class HealthKitManager: ObservableObject {
//    static let shared = HealthKitManager()
//    
//    var healthStore = HKHealthStore()
//    
//    @Published var stepCountToday: Int = 0
//    var stepCountYesterday: Int = 0
//    var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0,
//                                     4: 0, 5: 0, 6: 0, 7: 0]
//    
//    @AppStorage("weekStartDay") private var weekStartDay: Int = 2 // Default to Monday (2)
//
//    
//    private var timer: Timer?
//    private var cancellables = Set<AnyCancellable>()
//
//    
//    init() {
//        requestAuthorization()
//        startUpdating()
//    }
//    
//    
//    
//    
//    func requestAuthorization() {
//        // this is the type of data we will be reading from Health (e.g stepCount)
//        let toReads = Set([
//            HKObjectType.quantityType(forIdentifier: .stepCount)!, ])
//        // this is to make sure User's Heath Data is Avaialble
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("health data not available!")
//            return
//        }
//        
//        // asking User's permission for their Health Data
//        // note: toShare is set to nil since I'm not updating any data
//        healthStore.requestAuthorization(toShare: nil, read: toReads) {
//            success, error in
//            if success {
//                self.fetchAllData()
//            } else {
//                print("\(String(describing: error))")
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    func startUpdating() {
//        // Start a timer to update step count periodically (e.g., every 5 minutes)
//        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
//            self.readStepCountToday()
//        }
//        
//        // Immediately fetch the initial step count
//        readStepCountToday()
//    }
//    
//    
//
//    func readStepCountToday() {
//        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
//            return
//        }
//        
////        print("readStepCountToday() ran")
//        
//        let now = Date()
//        let startDate = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(
//            withStart: startDate,
//            end: now,
//            options: .strictStartDate
//        )
//        
//        let query = HKStatisticsQuery(
//            quantityType: stepCountType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum
//        ) {
//            _, result, error in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
//                return
//            }
//            
//            let steps = Int(sum.doubleValue(for: HKUnit.count()))
//            
//            DispatchQueue.main.async {
//                self.stepCountToday = steps
//                UserDefaults(suiteName: "group.odo")?.set(self.stepCountToday, forKey: "dailyStepCount")
//                WidgetCenter.shared.reloadAllTimelines()
//            }
//            
//        }
//        
//        healthStore.execute(query)
//    }
//    
//    
//    
//    
//    func fetchAllData() {
//        print("////////////////////////////////////////")
//        print("Attempting to fetch all Datas")
//        readStepCountYesterday()
//        readStepCountToday()
//        readStepCountThisWeek()
//        
//        print("DATAS FETCHED: ")
//        print("\(stepCountToday) steps today")
//        print("////////////////////////////////////////")
//        
//        UserDefaults(suiteName: "group.odo")?.set(stepCountToday, forKey: "dailyStepCount")
//        
//        WidgetCenter.shared.reloadAllTimelines()
//    }
//    
//    
//    
//    
//    func readStepCountYesterday() {
//        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
//            return
//        }
//        
//        let calendar = Calendar.current
//        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
//        let startDate = calendar.startOfDay(for: yesterday!)
//        let endDate = calendar.startOfDay(for: Date())
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//        
//        print("attempting to get step count from \(startDate)")
//        
//        let query = HKStatisticsQuery(
//            quantityType: stepCountType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum
//        ) {
//            _, result, error in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
//                return
//            }
//            
//            let steps = Int(sum.doubleValue(for: HKUnit.count()))
//            print("Fetched your steps yesterday: \(steps)")
//            self.stepCountYesterday = steps
//        }
//        healthStore.execute(query)
//    }
//    
//
//    
// 
//    
//    
//    func readStepCountThisWeek() {
//        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
//            return
//        }
//        
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.firstWeekday = weekStartDay
//        
//        let now = Date()
//        let today = calendar.startOfDay(for: now)
//        
//        // Calculate the start of the week based on the user-defined start day
//        let weekdayOffset = (calendar.component(.weekday, from: today) - weekStartDay + 7) % 7
//        guard let startOfWeek = calendar.date(byAdding: .day, value: -weekdayOffset, to: today) else {
//            print("Failed to calculate the start date of the week.")
//            return
//        }
//        
//        // Calculate the end of the week (7 days after start, to include the full current day)
//        guard let _ = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
//            print("Failed to calculate the end date of the week.")
//            return
//        }
//        
//        let predicate = HKQuery.predicateForSamples(
//            withStart: startOfWeek,
//            end: now,  // Use current time instead of end of day
//            options: .strictStartDate
//        )
//        
//        let query = HKStatisticsCollectionQuery(
//            quantityType: stepCountType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum,
//            anchorDate: startOfWeek,
//            intervalComponents: DateComponents(day: 1)
//        )
//        
//        query.initialResultsHandler = { [weak self] _, result, error in
//            guard let self = self, let result = result else {
//                if let error = error {
//                    print("An error occurred while retrieving step count: \(error.localizedDescription)")
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.thisWeekSteps = [:]  // Reset the dictionary
//            }
//            
//            result.enumerateStatistics(from: startOfWeek, to: now) { statistics, _ in
//                if let quantity = statistics.sumQuantity() {
//                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
//                    let day = calendar.component(.weekday, from: statistics.startDate)
//                    DispatchQueue.main.async {
//                        self.thisWeekSteps[day] = steps
//                    }
//                }
//            }
//            
//            print(self.thisWeekSteps)
//            
//            DispatchQueue.main.async {
//                UserDefaults(suiteName: "group.odo")?.set(self.thisWeekSteps.compactMap{ $0.value }.reduce(0, +), forKey: "weeklyStepCount")
//                WidgetCenter.shared.reloadAllTimelines()
//            }
//            
//        }
//        
//        healthStore.execute(query)
//    }
//}

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
    @Published var stepCountYesterday: Int = 0
    @Published var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0]
    
    @AppStorage("weekStartDay") private var weekStartDay: Int = 2 // Default to Monday (2)
    
    private var updateTimer: Timer?
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
                self?.setupBackgroundDelivery()
                self?.fetchAllData()
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
                self?.fetchAllData()
            }
        }
        
        if let query = observerQuery {
            healthStore.execute(query)
        }
    }
    
    func setupBackgroundDelivery() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        healthStore.enableBackgroundDelivery(for: stepCountType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery: \(error.localizedDescription)")
            } else if success {
                print("Background delivery enabled successfully")
            }
        }
    }
    
    func fetchAllData() {
        readStepCountToday()
//        readStepCountYesterday()
        readStepCountThisWeek()
    }
    
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
            guard let self = self, let result = result, let sum = result.sumQuantity() else {
                print("Failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            
            DispatchQueue.main.async {
                self.stepCountToday = steps
                UserDefaults(suiteName: "group.odo")?.set(self.stepCountToday, forKey: "dailyStepCount")
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
        healthStore.execute(query)
    }
    
    
    func readStepCountThisWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = weekStartDay
        
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        // Calculate the start of the week based on the user-defined start day
        let weekdayOffset = (calendar.component(.weekday, from: today) - weekStartDay + 7) % 7
        guard let startOfWeek = calendar.date(byAdding: .day, value: -weekdayOffset, to: today) else {
            print("Failed to calculate the start date of the week.")
            return
        }
        
        // Calculate the end of the week (7 days after start, to include the full current day)
        guard let _ = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            print("Failed to calculate the end date of the week.")
            return
        }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: now,  // Use current time instead of end of day
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
                    print("An error occurred while retrieving step count: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.thisWeekSteps = [:]  // Reset the dictionary
            }
            
            result.enumerateStatistics(from: startOfWeek, to: now) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    DispatchQueue.main.async {
                        self.thisWeekSteps[day] = steps
                    }
                }
            }
            
            print(self.thisWeekSteps)
            
            DispatchQueue.main.async {
                UserDefaults(suiteName: "group.odo")?.set(self.thisWeekSteps.compactMap{ $0.value }.reduce(0, +), forKey: "weeklyStepCount")
                WidgetCenter.shared.reloadAllTimelines()
            }
            
        }
        
        healthStore.execute(query)
    }
    
    // Implement readStepCountYesterday() and readStepCountThisWeek() similarly
    
    func handleBackgroundRefresh(task: BGAppRefreshTask) {
        let group = DispatchGroup()
        
        group.enter()
        readStepCountToday()
        group.leave()
        
        group.enter()
        readStepCountThisWeek()
        group.leave()
        
        group.notify(queue: .main) {
            task.setTaskCompleted(success: true)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    
    
    
}
