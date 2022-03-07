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
    var coreDataActions: CoreDataActions?
    
    init() {
        self.coreDataActions = CoreDataActions()
    }
    
    func fetchSets() {
        coreDataActions?.fetch(type: "Set")
        coreDataActions?.savedSets.bind(listener: { savedSets in
            self.savedSets.value = savedSets
        })
    }
    
    func fetchRows() {
        coreDataActions?.fetch(type: "Row")
        coreDataActions?.savedRows.bind(listener: { savedRows in
            self.savedRows.value = savedRows
        })
    }
    
    func updateData() {
        fetchSets()
        fetchRows()
    }
    
}
