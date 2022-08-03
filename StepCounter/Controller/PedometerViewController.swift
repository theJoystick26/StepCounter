//
//  PedometerViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 7/31/22.
//

import UIKit
import CoreMotion
import RealmSwift

class PedometerViewController: UIViewController {
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // initializing realm instance
    let realm = try! Realm()
    // initializing tracker
    var tracker = Tracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.tintColor = UIColor.white
        startButton.backgroundColor = UIColor.green
        
        tracker.delegate = self
        tracker.enableTracking()
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
        self.stepsLabel.text = "0"
        self.milesLabel.text = "0"
    }
}

// MARK: - Tracker Delegate Methods

extension PedometerViewController: TrackerDelegate {
    func didUpdatePedometerData(_ steps: Int, _ miles: Float) {
        DispatchQueue.main.async {
            self.stepsLabel.text = String(steps)
            self.milesLabel.text = miles.description
        }
    }
    
    // Writing walk instance to realm
    
    func didFinishWalk(_ steps: Int, _ miles: Float, _ startTime: Date, _ endTime: Date) {
        let walk = Walk(steps, miles, startTime, endTime)
        do {
            try realm.write {
                realm.add(walk)
            }
        } catch {
            print("Error saving walk: \(error)")
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

