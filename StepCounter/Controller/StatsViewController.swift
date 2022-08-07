//
//  StatsViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/4/22.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var stepsDescription: UILabel!
    
    var steps: Int = 0
    var calories: Float = 0
    var miles: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepsDescription.text = "You walked \(String(steps)) steps, burning \(String(format: "%.2f", calories)) calories and covering \(miles) miles"
    }
}
