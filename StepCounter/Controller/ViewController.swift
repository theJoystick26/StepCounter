//
//  ViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 7/31/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        startButton.tintColor = UIColor.green
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        print(sender.titleLabel?.text!)
        
    }
    
}

