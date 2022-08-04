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

// MARK: - TavleView Data Source Methods

extension LogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrototypeCell", for: indexPath)
        
        if let walks = walks {
            cell.textLabel?.text = "\(String(walks[indexPath.row].calories)) calories"
        }
        
        return cell
    }
}
