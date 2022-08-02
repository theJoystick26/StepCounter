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
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var tracker = Tracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.tintColor = UIColor.white
        startButton.backgroundColor = UIColor.green
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !tracker.getCountingStepsStatus() {
            tracker.startTrackingSteps { data in
                self.stepsLabel.text = data["steps"]
                self.milesLabel.text = data["miles"]
            }
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
        stepsLabel.text = "0"
        caloriesLabel.text = "0"
        caloriesLabel.text = "0"
    }
}

