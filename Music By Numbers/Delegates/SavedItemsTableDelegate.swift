//
//  SavedItemsTableDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/26/22.
//

import Foundation
import UIKit
import CoreData

class SavedItemsTableDelegate: NSObject, UITableViewDelegate {
    
    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    var setViewModel: SetViewModel!
    var savedItemsDataSource: SavedItemsDataSource!
    var parentViewController: UITableViewController!
    
    
    init(viewController: UITableViewController, dataSource: SavedItemsDataSource, rows: [NSManagedObject], sets: [NSManagedObject]) {
        self.savedRows = rows
        self.savedSets = sets
        self.setViewModel = SetViewModel(set: [])
        self.parentViewController = viewController
        self.savedItemsDataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let destVC = parentViewController.tabBarController?.viewControllers![1] as! UINavigationController
            let rowVC = destVC.topViewController as! MatrixViewController
            
            let row = revertRow(row: savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
            if rowVC.isViewLoaded {
                rowVC.generateMatrix(rowString: row)
                parentViewController.tabBarController?.selectedIndex = 1
            } else{
                let _ = rowVC.view
                rowVC.generateMatrix(rowString: row)
                parentViewController.tabBarController?.selectedIndex = 1
            }
        } else {
            let destVC = parentViewController.tabBarController?.viewControllers![2] as! UINavigationController
            let setVC = destVC.topViewController as! SetViewController
            
            let set = savedSets[indexPath.row].value(forKey: "userSet") as! [Int]
            
            if setVC.isViewLoaded {
                setVC.normalForm = set
                setVC.primeForm = setViewModel.findPrimeForm(normalForm: set)
                setVC.workingSet = set
                parentViewController.tabBarController?.selectedIndex = 2
            } else{
                let _ = setVC.view
                setVC.normalForm = set
                setVC.primeForm = setViewModel.findPrimeForm(normalForm: set)
                setVC.workingSet = set
                parentViewController.tabBarController?.selectedIndex = 2
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue)  in
            if indexPath.section == 0 {
                
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
                fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedRows[indexPath.row].value(forKey: "id") as! CVarArg)
                do {
                    let object = try managedContext.fetch(fetchRequest)
                    managedContext.delete(object[0])
                    try managedContext.save()
                    self.savedRows.remove(at: indexPath.row)
                    self.savedItemsDataSource.savedRows = self.savedRows
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError{
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
            } else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
                fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedSets[indexPath.row].value(forKey: "id") as! CVarArg)
                do {
                    let object = try managedContext.fetch(fetchRequest)
                    managedContext.delete(object[0])
                    try managedContext.save()
                    self.savedSets.remove(at: indexPath.row)
                    self.savedItemsDataSource.savedSets = self.savedSets
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch let error as NSError{
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                
            }
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, boolValue) in
            print("I want to edit this")
        }
        
        edit.backgroundColor = UIColor.blue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipeActions
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
}
