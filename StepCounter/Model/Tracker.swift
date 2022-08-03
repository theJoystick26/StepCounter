//
//  Tracker.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/2/22.
//

import Foundation
import CoreMotion

protocol TrackerDelegate {
    func didUpdatePedometerData(_ steps: Int, _ miles: Float)
    func didFailWithError(_ error: Error)
}

class Tracker {
    private let activityManager: CMMotionActivityManager
    private let pedometer: CMPedometer
    private var isCountingSteps: Bool
    var delegate: TrackerDelegate?
    
    init() {
        activityManager = CMMotionActivityManager()
        pedometer = CMPedometer()
        isCountingSteps = false
    }
    
    func startTrackingSteps() {
        // enables tracking
        activityManager.startActivityUpdates(to: OperationQueue.main) { _ in
            return
        }
        
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() {
            // .startUpdates is calling the completion handler once the pedometer data has been received
            pedometer.startUpdates(from: Date()) { data, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let pedometerData = data {
                    self.delegate?.didUpdatePedometerData(pedometerData.numberOfSteps.intValue, self.metersToMiles(pedometerData.distance?.floatValue ?? 0))
                }
            }
        }
        
        isCountingSteps = true
    }
    
    func stopTrackingSteps() {
        pedometer.stopUpdates()
        activityManager.stopActivityUpdates()
        isCountingSteps = false
    }
    
    func getCountingStepsStatus() -> Bool {
        return isCountingSteps
    }
    
    func metersToMiles(_ distanceInMeters: Float) -> Float {
        return Float(Int(distanceInMeters * 0.00062137 * 100)) / 100
    }
}
