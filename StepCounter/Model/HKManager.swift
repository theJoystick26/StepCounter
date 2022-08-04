//
//  HKManager.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/3/22.
//

import Foundation
import HealthKit

class HKManager {
    var healthStore: HKHealthStore?
    
    func authorizeHealthKit(completion: @escaping (Bool) -> Void) {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            
            let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            
            healthStore?.requestAuthorization(toShare: [calorieType], read: [], completion: { success, error in
                if error != nil {
                    print("Error \(error!)")
                } else {
                    completion(success)
                }
            })
        }
    }
    
    func writeToHealthKit(_ calories: Float, _ startTime: Date, _ endTime: Date) {
        let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: Double(calories))
        let sample = HKQuantitySample(type: calorieType, quantity: quantity, start: startTime, end: endTime)
        
        healthStore?.save(sample, withCompletion: { success, error in
            guard error == nil else {
                print(error!)
                return
            }
            print("Success: \(success)")
        })
    }
}
