//
//  SavedItemsTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/29/22.
//

import UIKit
import CoreData

protocol ClickDelegate {
    func clicked(row: Int, section: Int)
}

class SavedItemsTableViewController: UITableViewController, ClickDelegate {
    
    func clicked(row: Int, section: Int) {
        if section == 0 {
            let fetchedDate = savedRows[row].value(forKey: "dateCreated")! as! Date
            let alert = UIAlertController(title: "Row Details", message: "Piece: \(savedRows[row].value(forKey: "piece")!)\n \n Notes: \(savedRows[row].value(forKey: "notes")!)\n \n Date added: \(fetchedDate.formatted(.dateTime.month(.wide).day().year(.extended())))", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        } else {
            let fetchedDate = savedSets[row].value(forKey: "dateCreated")! as! Date
            let alert = UIAlertController(title: "Set Details", message: "Piece: \(savedSets[row].value(forKey: "piece")!)\n \n Notes: \(savedSets[row].value(forKey: "notes")!)\n \n Date added: \(fetchedDate.formatted(.dateTime.month(.wide).day().year(.extended())))", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    

    let sections = ["Rows","Sets"]
    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    var setViewModel: SetViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        setViewModel = SetViewModel(set: [])
        fetchSets()
        fetchRows()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func refreshTable(sender:AnyObject) {
        fetchSets()
        fetchRows()
        tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSets()
        fetchRows()
        tableView.reloadData()
    }

    func fetchSets() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
        
        do {
            savedSets = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRows() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
        
        do {
            savedRows = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func makeText(setList: [Int]) -> String {
        var normDisplay = "["
        for i in setList {
            if i == 10 {
                normDisplay += "t"
            } else if i == 11 {
                normDisplay += "e"
            } else if i != 10 || i != 11 {
                normDisplay += "\(i)"
            }
        }
        normDisplay += "]"
        return normDisplay
    }
    
    func makeRowText(row: [Int]) -> String {
        var rowString = "["
        for i in 0..<row.count {
            if i == row.count - 1 {
                rowString += "\(String(row[i]))]"
            } else {
                rowString += "\(String(row[i])), "
            }
        }
        return rowString
    }
    
    func revertRow(row: [Int]) -> String {
        var rowString = ""
        
        for i in row {
            if i == 10 {
                rowString += "t"
            } else if i == 11 {
                rowString += "e"
            } else {
                rowString += String(i)
            }
        }
        return rowString
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return savedRows.count
        } else {
            return savedSets.count
        }
        // #warning Incomplete implementation, return the number of rows
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let rowCell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! RowTableViewCell
            // to-do Implement a way of checking if the core data stack is empty
            if savedRows[indexPath.row].value(forKey: "userRow") == nil {
                return rowCell
            } else {
                let date = savedRows[indexPath.row].value(forKey: "dateCreated") as! Date

                let newLabel = makeRowText(row: savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
                rowCell.rowLabel.text = newLabel
                rowCell.cellIndexRow = indexPath.row
                rowCell.cellIndexSection = 0
                rowCell.delegate = self
                rowCell.rowDate.text = "\(date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                return rowCell
            }
        } else {
            let setCell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetTableViewCell
            #warning("This could be refactored into a guard statement rather than an if else statement")
            if savedSets[indexPath.row].value(forKey: "userSet") == nil {
                return setCell
            } else {
                setCell.pcCircleView?.setShape = savedSets[indexPath.row].value(forKey: "userSet") as! [Int]
                let newLabel = makeText(setList: savedSets[indexPath.row].value(forKey: "userSet") as! [Int])
                let date = savedSets[indexPath.row].value(forKey: "dateCreated") as! Date
                setCell.setLabel.text = newLabel
                setCell.cellIndexRow = indexPath.row
                setCell.cellIndexSection = 1
                setCell.delegate = self
                setCell.setLabel.text = newLabel
                setCell.setDate.text = "\(date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                
                return setCell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let destVC = tabBarController?.viewControllers![1] as! UINavigationController
            let rowVC = destVC.topViewController as! MatrixViewController
            
            let row = revertRow(row: savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
            if rowVC.isViewLoaded {
                rowVC.generateMatrix(rowString: row)
                tabBarController?.selectedIndex = 1
            } else{
                let _ = rowVC.view
                rowVC.generateMatrix(rowString: row)
                tabBarController?.selectedIndex = 1
            }
        } else {
            let destVC = tabBarController?.viewControllers![2] as! UINavigationController
            let setVC = destVC.topViewController as! SetViewController
            
            let set = savedSets[indexPath.row].value(forKey: "userSet") as! [Int]
            
            if setVC.isViewLoaded {
                setVC.normalForm = set
                setVC.primeForm = setViewModel.findPrimeForm(normalForm: set)
                setVC.workingSet = set
                tabBarController?.selectedIndex = 2
            } else{
                let _ = setVC.view
                setVC.normalForm = set
                setVC.primeForm = setViewModel.findPrimeForm(normalForm: set)
                setVC.workingSet = set
                tabBarController?.selectedIndex = 2
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
                fetchRequest.predicate = NSPredicate(format: "id == %@", savedRows[indexPath.row].value(forKey: "id") as! CVarArg)
                do {
                    let object = try managedContext.fetch(fetchRequest)
                    managedContext.delete(object[0])
                    try managedContext.save()
                    savedRows.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError{
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
            }
        } else {
            if editingStyle == .delete {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
                fetchRequest.predicate = NSPredicate(format: "id == %@", savedSets[indexPath.row].value(forKey: "id") as! CVarArg)
                do {
                    let object = try managedContext.fetch(fetchRequest)
                    managedContext.delete(object[0])
                    try managedContext.save()
                    savedSets.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError{
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
            }
        }
    }

}

