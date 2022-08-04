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
    func didFinishWalk(_ steps: Int, _ calories: Float, _ miles: Float, _ startTime: Date, _ endTime: Date)
    func didFailWithError(_ error: Error)
}

class Tracker {
    private let activityManager: CMMotionActivityManager
    private let pedometer: CMPedometer
    private var isCountingSteps: Bool
    private var steps: Int = 0
    private var calories: Float = 0
    private var miles: Float = 0
    private var startTime: Date?
    private var endTime: Date?
    var delegate: TrackerDelegate?
    
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
    
    func startTrackingSteps() {
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() {
            // .startUpdates is calling the completion handler once the pedometer data has been received
            startTime = Date()
            
            pedometer.startUpdates(from: Date()) { data, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let data = data {
                    self.steps = data.numberOfSteps.intValue
                    self.calories = data.numberOfSteps.floatValue * 0.04
                    self.miles = self.metersToMiles(data.distance?.floatValue ?? 0)
                    
                    self.delegate?.didUpdatePedometerData(self.steps, self.miles)
                }
            }
        }
        
        isCountingSteps = true
    }
    
    func stopTrackingSteps() {
        pedometer.stopUpdates()
        endTime = Date()
        
        if let startTime = startTime, let endTime = endTime {
            delegate?.didFinishWalk(steps, calories, miles, startTime, endTime)
        }
        
        isCountingSteps = false
    }
    
    func getCountingStepsStatus() -> Bool {
        return isCountingSteps
    }
    
    func metersToMiles(_ distanceInMeters: Float) -> Float {
        return Float(Int(distanceInMeters * 0.00062137 * 100)) / 100
    }
}
