//
//  Tracker.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/2/22.
//

import Foundation
import CoreMotion

struct Tracker {
    private let activityManager: CMMotionActivityManager
    private let pedometer: CMPedometer
    private var isCountingSteps: Bool
    
    init() {
        activityManager = CMMotionActivityManager()
        pedometer = CMPedometer()
        isCountingSteps = false
    }
    
    func enableTracking() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { _ in
            return
        }
    }
    
    mutating func startTrackingSteps(completionHandler: @escaping (String) -> Void) {
        if CMPedometer.isStepCountingAvailable() {
            // .startUpdates is calling the completion handler once the pedometer data has been received
            pedometer.startUpdates(from: Date()) { data, error in
                if error != nil { return }
                
                if let pedometerData = data {
                    DispatchQueue.main.async {
                        completionHandler(String(pedometerData.numberOfSteps.intValue))
                    }
                }
            }
        }
        
        isCountingSteps = true
    }
    
    mutating func stopTrackingSteps() {
        pedometer.stopUpdates()
        isCountingSteps = false
    }
    
    func getCountingStepsStatus() -> Bool {
        return isCountingSteps
    }
}
