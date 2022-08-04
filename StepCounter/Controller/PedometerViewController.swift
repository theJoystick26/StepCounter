//
//  PedometerViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 7/31/22.
//

import UIKit
import CoreMotion
import RealmSwift
import HealthKit

class PedometerViewController: UIViewController {
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // initializing realm instance
    let realm = try! Realm()
    
    let hkManager = HKManager()
    
    // initializing tracker
    var tracker = Tracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.tintColor = UIColor.white
        startButton.backgroundColor = UIColor.green
        
        tracker.delegate = self
        
        hkManager.authorizeHealthKit { success in
            if success {
                self.tracker.enableTracking()
            }
        }
        //        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !tracker.getCountingStepsStatus() {
            tracker.startTrackingSteps()
            updateUI(UIColor.red, "Stop")
        } else {
            tracker.stopTrackingSteps()
            updateUI(UIColor.green, "Start")
        }
    }
    
    // MARK: - Update UI Methods
    
    func updateUI(_ color: UIColor, _ buttonText: String) {
        startButton.backgroundColor = color
        startButton.setTitle(buttonText, for: .normal)
        self.stepsLabel.text = "Steps: 0"
        self.milesLabel.text = "Miles: 0"
    }
}

// MARK: - Tracker Delegate Methods

extension PedometerViewController: TrackerDelegate {
    func didUpdatePedometerData(_ steps: Int, _ miles: Float) {
        DispatchQueue.main.async {
            self.stepsLabel.text = "Steps: \(String(steps))"
            self.milesLabel.text = "Miles: \(miles.description)"
        }
    }

    func didFinishWalk(_ steps: Int, _ calories: Float, _ miles: Float, _ startTime: Date, _ endTime: Date) {
        let walk = Walk(steps, calories, miles, startTime, endTime)
        // Writing walk instance to realm
        do {
            try self.realm.write {
                self.realm.add(walk)
            }
        } catch {
            print("Error saving walk: \(error)")
        }
        // writing to HealthKit
        hkManager.writeToHealthKit(calories, startTime, endTime)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
