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
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
        
    }
    
    var editID: UUID?
    var mainTitleText: String! = ""
    var contentLabelText: String! = ""
    var contentFieldText: String? = ""
    var pieceLabelText: String! = ""
    var pieceFieldText: String? = ""
    var notesLabelText: String! = ""
    var notesFieldText: String? = ""
    
    
    var savedItemsDelegate: SavedItemsTableDelegate!
    var savedItemsDataSource: SavedItemsDataSource!
    var savedItemsViewModel: SavedItemsViewModel!
    
    var detailVC: DetailTableViewController!
    
    var savedSets = [NSManagedObject]()
    var savedRows = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        
        savedItemsViewModel = SavedItemsViewModel()
        
        savedItemsDataSource = SavedItemsDataSource(viewController: self, rows: self.savedRows, sets: self.savedSets)
        savedItemsDelegate = SavedItemsTableDelegate(viewController: self, dataSource: savedItemsDataSource, rows: self.savedRows, sets: self.savedSets)
        tableView.delegate = savedItemsDelegate
        tableView.dataSource = savedItemsDataSource
        savedItemsDelegate.updateDelegate = self
        
        updateData()
        detailVC = DetailTableViewController()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func refreshTable(sender:AnyObject) {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
    }
    
    func updateData() {
        savedItemsViewModel.savedRows.bind { rows in
            self.savedRows = rows
            self.savedItemsDataSource.savedRows = rows
            self.savedItemsDelegate.savedRows = rows
        }
        
        savedItemsViewModel.savedSets.bind { sets in
            self.savedSets = sets
            self.savedItemsDataSource.savedSets = sets
            self.savedItemsDelegate.savedSets = sets
        }
        
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailTableViewController
        detailVC.loadViewIfNeeded()
        detailVC.editID = editID
        detailVC.mainTitleText = mainTitleText
        detailVC.contentLabelText = contentLabelText
        detailVC.contentFieldText = contentFieldText
        detailVC.pieceLabelText = pieceLabelText
        detailVC.pieceFieldText = pieceFieldText
        detailVC.notesLabelText = notesLabelText
        detailVC.notesFieldText = notesFieldText
        detailVC.updateDatails()
    }
    
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
    
    
    
}

extension SavedItemsTableViewController: UpdateDetailsProtocol {
    func updateDetails(id: UUID, title: String, contentLabel: String, contentField: String, pieceLabel: String, pieceField: String, NotesLabel: String, NotesField: String) {
        self.editID = id
        self.mainTitleText = title
        self.contentLabelText = contentLabel
        self.contentFieldText = contentField
        self.pieceLabelText = pieceLabel
        self.pieceFieldText = pieceField
        self.notesLabelText = NotesLabel
        self.notesFieldText = NotesField
    }
}

extension SavedItemsTableViewController: UISearchBarDelegate {
    
}

