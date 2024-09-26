//
//  AppDelegate.swift
//  odo
//
//  Created by Austin Lavalley on 9/19/24.
//

import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerBackgroundTasks()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        HealthKitManager.shared.fetchAllData()
        HealthKitManager.shared.fetchStepCounts()
        completionHandler(.newData)
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.refreshSteps", using: nil) { task in
            self.handleStepRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundStepRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.refreshSteps")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleStepRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundStepRefresh() // Schedule next refresh
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        HealthKitManager.shared.handleBackgroundRefresh(task: task)
    }
}
