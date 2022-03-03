//
//  SavedItemsTableDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/26/22.
//

import Foundation
import UIKit
import CoreData

class SavedItemsTableDelegate: NSObject, UITableViewDelegate, SavedItemsProtocol {
    
    
    
    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    var setViewModel: SetViewModel!
    var savedItemsDataSource: SavedItemsDataSource!
    var parentViewController: UITableViewController!
    var saveItemDelegate: SavedItemsProtocol?
    
    var content: String?
    var piece: String?
    var notes: String?
    
    
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
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            if indexPath.section == 0 {
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
            
            let detailVC = DetailViewController()
            #warning("An Int of 10 will cause errors.")
            if indexPath.section == 0 {
            
                var localContent: String?
                var localPiece: String?
                var localNotes: String?
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
                fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedRows[indexPath.row].value(forKey: "id") as! CVarArg)
                
                localContent = self.makeRowText(row: self.savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
                
                localPiece = self.savedRows[indexPath.row].value(forKey: "piece") as? String
                localNotes = self.savedRows[indexPath.row].value(forKey: "notes") as? String
                
                let id = self.savedRows[indexPath.row].value(forKey: "id") as? UUID
                
                detailVC.editID = id
                detailVC.mainTitleText = "Edit"
                detailVC.contentLabelText = "Row:"
                detailVC.contentFieldText = localContent
                detailVC.pieceLabelText = "Piece Information:"
                detailVC.pieceFieldText = localPiece
                detailVC.notesLabelText = "Additional Notes:"
                detailVC.notesFieldText = localNotes
                detailVC.updateDatails()
                self.parentViewController.present(detailVC, animated: true, completion: nil)
            
            } else {
                var localContent: String?
                var localPiece: String?
                var localNotes: String?
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
                fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedSets[indexPath.row].value(forKey: "id") as! CVarArg)
                
                localContent = self.makeText(setList: self.savedSets[indexPath.row].value(forKey: "userSet") as! [Int])
                
                localPiece = self.savedSets[indexPath.row].value(forKey: "piece") as? String
                localNotes = self.savedSets[indexPath.row].value(forKey: "notes") as? String
                
                let id = self.savedSets[indexPath.row].value(forKey: "id") as? UUID
                
                detailVC.editID = id
                detailVC.mainTitleText = "Edit"
                detailVC.contentLabelText = "Set:"
                detailVC.contentFieldText = localContent
                detailVC.pieceLabelText = "Piece Information:"
                detailVC.pieceFieldText = localPiece
                detailVC.notesLabelText = "Additional Notes:"
                detailVC.notesFieldText = localNotes
                detailVC.updateDatails()
                self.parentViewController.present(detailVC, animated: true, completion: nil)
            }

        }
        
        edit.backgroundColor = UIColor.blue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipeActions
    }
    
    func saveUpdatedEntry(content: String, piece: String, notes: String) {
        self.content = content
        self.piece = piece
        self.notes = notes
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
