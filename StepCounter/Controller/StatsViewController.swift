//
//  StatsViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/4/22.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var stepsLabel: UILabel!
    
    var steps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepsLabel.text = String(steps)
    }
}
