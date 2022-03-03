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
                let fetchedSet = savedSets[indexPath.row].value(forKey: "userSet") as! [Int]
                let normalForm = setViewModel.findNormalForm(pcSet: fetchedSet)
                setCell.pcCircleView?.setShape = normalForm
                let newLabel = makeText(setList: normalForm)
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
