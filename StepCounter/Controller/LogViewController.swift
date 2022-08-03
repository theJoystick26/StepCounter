//
//  LogViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/3/22.
//

import UIKit

class LogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

}

// MARK: - TavleView Data Source Methods

extension LogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProtoCell", for: indexPath)
        
        cell.textLabel?.text = "Hi"
        
        return cell
    }
}
