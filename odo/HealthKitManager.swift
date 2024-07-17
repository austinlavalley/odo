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

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    var healthStore = HKHealthStore()
    
    @Published var stepCountToday: Int = 0
    var stepCountYesterday: Int = 0
    var thisWeekSteps: [Int: Int] = [1: 0, 2: 0, 3: 0,
                                     4: 0, 5: 0, 6: 0, 7: 0]
        
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    
    init() {
        requestAuthorization()
        startUpdating()
    }
    
    
    
    
    func requestAuthorization() {
        // this is the type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!, ])
        // this is to make sure User's Heath Data is Avaialble
        guard HKHealthStore.isHealthDataAvailable() else {
            print("health data not available!")
            return
        }
        
        // asking User's permission for their Health Data
        // note: toShare is set to nil since I'm not updating any data
        healthStore.requestAuthorization(toShare: nil, read: toReads) {
            success, error in
            if success {
                self.fetchAllData()
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    
    
    
    
    
    func startUpdating() {
        // Start a timer to update step count periodically (e.g., every 5 minutes)
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.readStepCountToday()
        }
        
        // Immediately fetch the initial step count
        readStepCountToday()
    }
    
    

    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        print("readStepCountToday() ran")
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            
            DispatchQueue.main.async {
                self.stepCountToday = steps
                UserDefaults(suiteName: "group.odo")?.set(self.stepCountToday, forKey: "widgetStep")
                WidgetCenter.shared.reloadAllTimelines()
            }
            
        }
        
        healthStore.execute(query)
    }
    
    
    
    
    func fetchAllData() {
        print("////////////////////////////////////////")
        print("Attempting to fetch all Datas")
        readStepCountYesterday()
        readStepCountToday()
        readStepCountThisWeek()
        
        print("DATAS FETCHED: ")
        print("\(stepCountToday) steps today")
        print("////////////////////////////////////////")
        
        UserDefaults(suiteName: "group.odo")?.set(stepCountToday, forKey: "widgetStep")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    
    
    func readStepCountYesterday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        let startDate = calendar.startOfDay(for: yesterday!)
        let endDate = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        print("attempting to get step count from \(startDate)")
        
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            print("Fetched your steps yesterday: \(steps)")
            self.stepCountYesterday = steps
        }
        healthStore.execute(query)
    }
    

    
 
    
    
    func readStepCountThisWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        // Find the start date (Monday) of the current week
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            print("Failed to calculate the start date of the week.")
            return
        }
        // Find the end date (Sunday) of the current week
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            print("Failed to calculate the end date of the week.")
            return
        }
        
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endOfWeek,
            options: .strictStartDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("An error occurred while retrieving step count: \(error.localizedDescription)")
                }
                return
            }
            
            //      print("---> ---> ATTEMPTING TO GET WEEK's STEPS")
            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    //          print("for day \(weekday) u have \(steps) steps!")
                    self.thisWeekSteps[day] = steps
                }
            }
            
            print("\(self.thisWeekSteps)")
        }
        healthStore.execute(query)
    }
}

