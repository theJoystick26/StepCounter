//
//  PedometerViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 7/31/22.
//

import UIKit
import CoreMotion

class PedometerViewController: UIViewController {
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var isCountingSteps = false
    
    private let activityManager = CMMotionActivityManager()
    
    private let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.tintColor = UIColor.white
        startButton.backgroundColor = UIColor.green
        
        activityManager.startActivityUpdates(to: OperationQueue.main) { _ in
            return
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !isCountingSteps {
            if CMPedometer.isStepCountingAvailable() {
                // .startUpdates is calling the completion handler once the pedometer data has been received
                pedometer.startUpdates(from: Date()) { data, error in
                    if error != nil { return }
                    
                    if let pedometerData = data {
                        DispatchQueue.main.async {
                            self.stepsLabel.text =
                            String(pedometerData.numberOfSteps.intValue)
                        }
                    }
                }
            }
            
            startButton.backgroundColor = UIColor.red
            startButton.setTitle("Stop", for: .normal)
            isCountingSteps = true
        } else {
            pedometer.stopUpdates()
            
            startButton.backgroundColor = UIColor.green
            startButton.setTitle("Start", for: .normal)
        }
        
        
        
    }
}

