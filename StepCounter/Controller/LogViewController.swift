//
//  LogViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 8/3/22.
//

import UIKit
import RealmSwift

class LogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var walks: Results<Walk>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        
        loadWalks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadWalks()
    }
    
    // loading walk instances from realm
    func loadWalks() {
        walks = realm.objects(Walk.self).sorted(byKeyPath: "startTime", ascending: false)
        tableView.reloadData()
    }
}

// MARK: - TavleView DataSource/Delegate Methods

extension LogViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath)
        
        if let walks = walks {
            cell.textLabel?.text = "\(String(format: "%.2f", walks[indexPath.row].calories)) calories"
            cell.textLabel?.font = UIFont(name: "RobotoCondensed-Regular", size: 24)
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toStatsView", sender: indexPath)
    }
}

// MARK: - Segue Handling

extension LogViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "toStatsView" {
            if let walks = walks {
                let statsViewController = segue.destination as! StatsViewController
                let sender = sender as! IndexPath
                statsViewController.steps = walks[sender.row].steps
            }
        }
    }
}
