//
//  Walk.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/3/22.
//

import Foundation
import RealmSwift

class Walk: Object {
    @Persisted var steps: Int = 0
    @Persisted var calories: Float = 0
    @Persisted var miles: Float = 0
    @Persisted var startTime: Date?
    @Persisted var endTime: Date?
    
    convenience init(_ steps: Int, _ calories: Float, _ miles: Float, _ startTime: Date, _ endTime: Date) {
        self.init()
        self.steps = steps
        self.calories = calories
        self.miles = miles
        self.startTime = startTime
        self.endTime = endTime
    }
}
