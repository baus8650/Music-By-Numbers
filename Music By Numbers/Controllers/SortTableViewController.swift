//
//  SortTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/7/22.
//

import UIKit
import CoreData

protocol SortItemsDelegate {
    func sortItems(order: String)
}

class SortTableViewController: UITableViewController {

    // MARK: - Properties
    
    var sortItemsDelegate: SortItemsDelegate?
    
    // MARK: - IBActions
    
    @IBAction func ascendingPressed(_ sender: Any) {
        sortItemsDelegate?.sortItems(order: "ascending")
        dismiss(animated: true)
    }
    
    @IBAction func descendingPressed(_ sender: Any) {
        sortItemsDelegate?.sortItems(order: "descending")
        dismiss(animated: true)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Tableview Methods

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 2
    }

}
