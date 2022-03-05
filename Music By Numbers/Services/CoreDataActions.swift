//
//  CoreDataActions.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 3/4/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataActions {
    
    var managedContext: NSManagedObjectContext!
    var rowEntity: NSEntityDescription?
    var setEntity: NSEntityDescription?
    var savedSets: Binder<[NSManagedObject]> = Binder([NSManagedObject]())
    var savedRows: Binder<[NSManagedObject]> = Binder([NSManagedObject]())
    
    var localContent: Binder<String?> = Binder(nil)
    var localPiece: Binder<String?> = Binder(nil)
    var localNotes: Binder<String?> = Binder(nil)
    var id: Binder<UUID?> = Binder(nil)
    
    init() {
        setUpCoreData()
    }
    
    func setUpCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.managedContext = appDelegate.persistentContainer.viewContext
        
        self.rowEntity = NSEntityDescription.entity(forEntityName: "SavedRow", in: managedContext)!
        
        self.setEntity = NSEntityDescription.entity(forEntityName: "SavedSet", in: managedContext)!
    }
    
    func fetch(type: String) {
        if type == "Row" {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
            do {
                savedRows.value = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else if type == "Set" {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
            do {
                savedSets.value = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func save(type: String, content: String, piece: String, notes: String) {
        if type == "Row" {
            let savedRow: NSManagedObject!
            savedRow = NSManagedObject(entity: self.rowEntity!, insertInto: managedContext)
            
            savedRow.setValue(piece, forKey: "piece")
            savedRow.setValue(notes, forKey: "notes")
            savedRow.setValue(Date(), forKey: "dateCreated")
            let localRow = content.map(String.init)
            var intRow = [Int]()
            for i in localRow {
                if i.isInt {
                    intRow.append(Int(i)!)
                }
            }
            savedRow.setValue(intRow, forKey: "userRow")
            savedRow.setValue(UUID(), forKey: "id")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        } else if type == "Set" {
            let savedSet: NSManagedObject!
            savedSet = NSManagedObject(entity: self.setEntity!, insertInto: managedContext)
            
            savedSet.setValue(piece, forKey: "piece")
            savedSet.setValue(notes, forKey: "notes")
            savedSet.setValue(Date(), forKey: "dateCreated")
            let localSet = content.map(String.init)
            var intSet = [Int]()
            for i in localSet {
                if i.isInt {
                    intSet.append(Int(i)!)
                }
            }
            savedSet.setValue(intSet, forKey: "userSet")
            savedSet.setValue(UUID(), forKey: "id")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func delete(type: String, indexPath: IndexPath) {
        if type == "Row" {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
            fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedRows.value[indexPath.row].value(forKey: "id") as! CVarArg)
            do {
                let object = try managedContext.fetch(fetchRequest)
                managedContext.delete(object[0])
                try managedContext.save()
                self.savedRows.value.remove(at: indexPath.row)
            } catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else if type == "Set" {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
            fetchRequest.predicate = NSPredicate(format: "id == %@", self.savedSets.value[indexPath.row].value(forKey: "id") as! CVarArg)
            do {
                let object = try managedContext.fetch(fetchRequest)
                managedContext.delete(object[0])
                try managedContext.save()
                self.savedSets.value.remove(at: indexPath.row)
            } catch let error as NSError{
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func update(type: String, editID: UUID, pieceField: String, notesField: String, contentField: String) {
        
        if type == "Row" {

            let editRow: NSManagedObject!
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
            fetchRequest.predicate = NSPredicate(format: "id == %@", editID as CVarArg)
            
            let results = try? managedContext.fetch(fetchRequest)
            
            if results?.count == 0 {
                print("Didn't find a result")
                return
            } else {
                editRow = results?.first
            }
            
            editRow.setValue(pieceField, forKey: "piece")
            editRow.setValue(notesField, forKey: "notes")
            #warning("This looks like it will update the date when editing information")
            editRow.setValue(Date(), forKey: "dateCreated")
            let localRow = contentField.map(String.init)
            var intRow = [Int]()
            for i in localRow {
                if i.isInt {
                    intRow.append(Int(i)!)
                }
            }
            editRow.setValue(intRow, forKey: "userRow")
            editRow.setValue(editID, forKey: "id")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
            
        } else if type == "Set" {
            
            let editSet: NSManagedObject!
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
            fetchRequest.predicate = NSPredicate(format: "id == %@", editID as CVarArg)
            
            let results = try? managedContext.fetch(fetchRequest)
            
            if results?.count == 0 {
                print("Didn't find a result")
                return
            } else {
                editSet = results?.first
            }
            
            editSet.setValue(pieceField, forKey: "piece")
            editSet.setValue(notesField, forKey: "notes")
            #warning("This looks like it will update the date when editing information")
            editSet.setValue(Date(), forKey: "dateCreated")
            let localSet = contentField.map(String.init)
            var intSet = [Int]()
            for i in localSet {
                if i.isInt {
                    intSet.append(Int(i)!)
                }
            }
            editSet.setValue(intSet, forKey: "userSet")
            editSet.setValue(editID, forKey: "id")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save. \(error), \(error.userInfo)")
            }
        }
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
