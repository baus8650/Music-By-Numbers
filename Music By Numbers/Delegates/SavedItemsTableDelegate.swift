//
//  SavedItemsTableDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/26/22.
//

import Foundation
import UIKit
import CoreData

protocol UpdateDetailsProtocol {
    func updateDetails(id: UUID, title: String, contentLabel: String, contentField: String, pieceLabel: String, pieceField: String, NotesLabel: String, NotesField: String)
}

class SavedItemsTableDelegate: NSObject, UITableViewDelegate {

    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    var setViewModel: SetViewModel!
    var savedItemsDataSource: SavedItemsDataSource!
    var parentViewController: UITableViewController!
    var coreDataActions: CoreDataActions!
    var updateDelegate: UpdateDetailsProtocol?
    var tableRow = [TableRow]()
    
    var content: String?
    var piece: String?
    var notes: String?
    
    init(viewController: UITableViewController, dataSource: SavedItemsDataSource, rows: [NSManagedObject], sets: [NSManagedObject]) {
        self.savedRows = rows
        self.savedSets = sets
        self.setViewModel = SetViewModel(set: [])
        self.parentViewController = viewController
        self.savedItemsDataSource = dataSource
        self.coreDataActions = CoreDataActions()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
                if savedRows.count != 0 {
                    let destVC = parentViewController.tabBarController?.viewControllers![1] as! UINavigationController
                    let rowVC = destVC.topViewController as! MatrixTableViewController
                    
                    let row = revertRow(row: savedRows[indexPath.row].value(forKey: "userRow") as! [Int])
                    if rowVC.isViewLoaded {
                        rowVC.generateMatrix(rowString: row)
//                        rowVC.collectionView.isHidden = false
//                        rowVC.saveButton.isEnabled = true
                        parentViewController.tabBarController?.selectedIndex = 1
                    } else{
                        let _ = rowVC.view
                        rowVC.generateMatrix(rowString: row)
//                        rowVC.collectionView.isHidden = false
//                        rowVC.saveButton.isEnabled = true
                        parentViewController.tabBarController?.selectedIndex = 1
                    }
                } else {
                    let destVC = parentViewController.tabBarController?.viewControllers![1] as! UINavigationController
                    let rowVC = destVC.topViewController as! MatrixTableViewController
                    if rowVC.isViewLoaded {
                        parentViewController.tabBarController?.selectedIndex = 1
                    } else{
                        let _ = rowVC.view
                        parentViewController.tabBarController?.selectedIndex = 1
                    }
                }
        } else {
            if savedSets.count != 0 {
            let destVC = parentViewController.tabBarController?.viewControllers![2] as! UINavigationController
            let setVC = destVC.topViewController as! SetTableViewController
            
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
            } else {
                let destVC = parentViewController.tabBarController?.viewControllers![2] as! UINavigationController
                let setVC = destVC.topViewController as! SetTableViewController
                if setVC.isViewLoaded {
                    parentViewController.tabBarController?.selectedIndex = 2
                } else{
                    let _ = setVC.view
                    parentViewController.tabBarController?.selectedIndex = 2
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.bounds
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue)  in

            if indexPath.section == 0 {
                self.coreDataActions.savedRows.value = self.savedRows
                self.coreDataActions.delete(type: "Row", indexPath: indexPath)
                
                self.coreDataActions.savedRows.bind { savedRows in
                    self.savedRows = savedRows
                    self.savedItemsDataSource.populateTableRows(rows: self.savedRows)
                    
                }
                
                self.savedItemsDataSource.savedRows = self.savedRows
                if self.savedRows.count == 0 {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else {
                self.coreDataActions.savedSets.value = self.savedSets
                self.coreDataActions.delete(type: "Set", indexPath: indexPath)
                self.coreDataActions.savedSets.bind { savedSets in
                    self.savedSets = savedSets
                    self.savedItemsDataSource.populateTableSets(sets: self.savedSets)
                }
                self.savedItemsDataSource.savedSets = self.savedSets
                if self.savedSets.count == 0 {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, boolValue) in

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
                
                self.updateDelegate?.updateDetails(id: id!, title: "Edit", contentLabel: "Row:", contentField: localContent!, pieceLabel: "Piece Information:", pieceField: localPiece!, NotesLabel: "Additional Notes:", NotesField: localNotes!)
                self.parentViewController.performSegue(withIdentifier: "toDetail", sender: nil)
            } else {
                var localContent: String?
                var localPiece: String?
                var localNotes: String?
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
                fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedSets[indexPath.row].value(forKey: "id") as! CVarArg)
                
                let fetchedSet = self.savedSets[indexPath.row].value(forKey: "userSet") as! [Int]
                
                let normalForm = self.setViewModel.findNormalForm(pcSet: fetchedSet)
                
                localContent = self.makeText(setList: normalForm)
                
                localPiece = self.savedSets[indexPath.row].value(forKey: "piece") as? String
                localNotes = self.savedSets[indexPath.row].value(forKey: "notes") as? String
                
                let id = self.savedSets[indexPath.row].value(forKey: "id") as? UUID
                
                self.updateDelegate?.updateDetails(id: id!, title: "Edit", contentLabel: "Set:", contentField: localContent!, pieceLabel: "Piece Information:", pieceField: localPiece!, NotesLabel: "Additional Notes:", NotesField: localNotes!)
                self.parentViewController.performSegue(withIdentifier: "toDetail", sender: nil)
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
                rowString += UserDefaults.standard.string(forKey: "Ten") ?? "t"
            } else if i == 11 {
                rowString += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
            } else {
                rowString += String(i)
            }
        }
        return rowString
    }
    
    func makeText(setList: [Int]) -> String {
        var normDisplay = ""
        for i in setList {
            if i == 10 {
                normDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
            } else if i == 11 {
                normDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
            } else if i != 10 || i != 11 {
                normDisplay += "\(i)"
            }
        }
        return normDisplay
    }
    
    func makeRowText(row: [Int]) -> String {
        var rowString = ""
        for i in 0..<row.count {
            if row[i] == 10 {
                rowString += UserDefaults.standard.string(forKey: "Ten") ?? "t"
            } else if row[i] == 11 {
                    rowString += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
            } else {
                rowString += String(row[i])
            }
        }
        return rowString
    }
    
}

