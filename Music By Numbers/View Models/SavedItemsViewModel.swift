//
//  SavedItemsViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/26/22.
//

import Foundation
import UIKit
import CoreData

class SavedItemsViewModel {
    
    var savedSets: Binder<[NSManagedObject]> = Binder([NSManagedObject]())
    var savedRows: Binder<[NSManagedObject]> = Binder([NSManagedObject]())
    
    func fetchSets() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
        
        do {
            savedSets.value = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchRows() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
        
        do {
            savedRows.value = try managedContext.fetch(fetchRequest)
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateData() {
        fetchSets()
        fetchRows()
    }
    
}
