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
    var tableRow = [TableRow]()
    var searchTableRow = [TableRow]()
    var tableSet = [TableSet]()
    var searchTableSet = [TableSet]()
    var isSearching: Bool = false
    
    init(viewController: UITableViewController, rows: [NSManagedObject], sets: [NSManagedObject]) {
        self.parentViewController = viewController
        setViewModel = SetViewModel(set: [])
        self.savedRows = rows
        self.savedSets = sets
        super.init()
//        self.populateTableRows(rows: self.savedRows)
//        self.populateTableSets(sets: sets)
        
    }
    
    func populateTableRows(rows: [NSManagedObject]) {
        tableRow = []
        for i in rows {
            guard let row = i.value(forKey: "userRow") as? [Int] else {
                return
            }
            let date = i.value(forKey: "dateCreated") as! Date
            
            let newLabel = makeRowText(row: row)
            tableRow.append(TableRow(row: newLabel, date: date))
        }
    }
    
    func populateTableSets(sets: [NSManagedObject]) {
        tableSet = []
        for i in sets {
            guard let set = i.value(forKey: "userSet") as? [Int] else {
                return
            }
            
            let normalForm = setViewModel.findNormalForm(pcSet: set)
//            setCell.pcCircleView?.setShape = normalForm
            let newLabel = makeText(setList: normalForm)
            let date = i.value(forKey: "dateCreated") as! Date
            
            tableSet.append(TableSet(setString: newLabel, setInt: normalForm, date: date))
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isSearching == true {
                return searchTableRow.count
            } else {
                if tableRow.count == 0 {
                    return 1
                } else {
                    return tableRow.count
                }
            }
        } else {
            if isSearching == true {
                return searchTableSet.count
            } else {
                if tableSet.count == 0 {
                    return 1
                } else {
                    return tableSet.count
                }
            }
        }
    }
    
    func filterRows(searchString: String) {
        searchTableRow = tableRow.filter {
            $0.row.replacingOccurrences(of: "11, ", with: UserDefaults.standard.string(forKey: "Eleven") ?? "e").replacingOccurrences(of: "10, ", with: UserDefaults.standard.string(forKey: "Ten") ?? "t").replacingOccurrences(of: ", ", with: "").contains(searchString)
        }
    }
    
    func filterSets(searchString: String) {
        searchTableSet = tableSet.filter {
            $0.setString.contains(searchString)
        }
    }
    
    func sortEntires(order: String) {
        if order == "descending" {
            tableRow.sort {
                $0.date > $1.date
            }
            tableSet.sort {
                $0.date > $1.date
            }
        } else {
            tableRow.sort {
                $0.date < $1.date
            }
            tableSet.sort {
                $0.date < $1.date
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if tableRow.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
                emptyCell.emptyCellLabel.text = "You have no saved rows yet."
                return emptyCell
            } else {
            let rowCell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! RowTableViewCell
                if isSearching == false {
                    rowCell.rowLabel.text = tableRow[indexPath.row].row
                    rowCell.rowDate.text = "\(tableRow[indexPath.row].date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                } else {
                    rowCell.rowLabel.text = searchTableRow[indexPath.row].row
                    rowCell.rowDate.text = "\(searchTableRow[indexPath.row].date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                }
                rowCell.cellIndexRow = indexPath.row
                rowCell.cellIndexSection = 0
                rowCell.delegate = self.parentViewController as? ClickDelegate
                return rowCell
            }
        } else {
            if tableSet.count == 0 {
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
                emptyCell.emptyCellLabel.text = "You have no saved sets yet."
                return emptyCell
            } else {
                let setCell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetTableViewCell
                if isSearching == false {
                    setCell.pcCircleView?.setShape = tableSet[indexPath.row].setInt
                    let newLabel = tableSet[indexPath.row].setString
                    setCell.setDate.text = "\(tableSet[indexPath.row].date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                    setCell.setLabel.text = newLabel
                } else {
                    setCell.pcCircleView?.setShape = searchTableSet[indexPath.row].setInt
                    let newLabel = searchTableSet[indexPath.row].setString
                    setCell.setDate.text = "\(searchTableSet[indexPath.row].date.formatted(.dateTime.month(.wide).day().year(.extended())))"
                    setCell.setLabel.text = newLabel
                }
                
                setCell.cellIndexRow = indexPath.row
                setCell.cellIndexSection = 1
                setCell.delegate = self.parentViewController as? ClickDelegate
                
                return setCell
            }
        }
    }
    
    func makeText(setList: [Int]) -> String {
        var normDisplay = "["
        for i in setList {
            if i == 10 {
                normDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
            } else if i == 11 {
                normDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
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



