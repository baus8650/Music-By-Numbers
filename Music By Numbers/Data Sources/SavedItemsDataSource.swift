//
//  RowDataSource.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/26/22.
//

import Foundation
import UIKit
import CoreData

class SavedItemsDataSource: NSObject, UITableViewDataSource {
    
    let sections = ["Rows","Sets"]
    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    var parentViewController: UITableViewController!
    var setViewModel: SetViewModel!
    
    init(viewController: UITableViewController, rows: [NSManagedObject], sets: [NSManagedObject]) {
        self.parentViewController = viewController
        setViewModel = SetViewModel(set: [])
        self.savedRows = rows
        self.savedSets = sets
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return savedRows.count
        } else {
            return savedSets.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let rowCell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! RowTableViewCell
            if savedRows[indexPath.row].value(forKey: "userRow") == nil {
                return rowCell
            } else {
                let date = savedRows[indexPath.row].value(forKey: "dateCreated") as! Date

                let newLabel = makeRowText(row: savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
                rowCell.rowLabel.text = newLabel
                rowCell.cellIndexRow = indexPath.row
                rowCell.cellIndexSection = 0
                rowCell.delegate = self.parentViewController as? ClickDelegate
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
                setCell.delegate = self.parentViewController as? ClickDelegate
                setCell.setLabel.text = newLabel
                setCell.setDate.text = "\(date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                
                return setCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

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
    
}
