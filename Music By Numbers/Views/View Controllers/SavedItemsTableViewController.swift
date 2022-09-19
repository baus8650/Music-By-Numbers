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

class SavedItemsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var savedItemsDelegate: SavedItemsTableDelegate!
    var savedItemsDataSource: SavedItemsDataSource!
    var savedItemsViewModel: SavedItemsViewModel!
    
    var detailVC: DetailTableViewController!
    
    var isSearching: Bool? = false
    var editID: UUID?
    var mainTitleText: String! = ""
    var contentLabelText: String! = ""
    var contentFieldText: String? = ""
    var pieceLabelText: String! = ""
    var pieceFieldText: String? = ""
    var notesLabelText: String! = ""
    var notesFieldText: String? = ""
    
    var savedSets: [NSManagedObject]! {
        didSet {
            tableView.reloadData()
        }
    }
    var savedRows: [NSManagedObject]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - IBOutlets

    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - IBActions
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
        
    }
    
    @IBAction func sortPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "Sort", message: "How should the table be sorted?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Date Ascending", style: .default, handler: { (action) -> Void in
            self.savedItemsDataSource.sortEntires(order: "ascending")
            self.tableView.reloadData()
        }))
        ac.addAction((UIAlertAction(title: "Date Descending", style: .default, handler: { (action) -> Void in
            self.savedItemsDataSource.sortEntires(order: "descending")
            self.tableView.reloadData()
        })))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)

    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        self.tableView.keyboardDismissMode = .onDrag
        savedRows = []
        savedSets = []
        savedItemsViewModel = SavedItemsViewModel()
        detailVC = DetailTableViewController()
        searchBar.delegate = self
        
        savedItemsDataSource = SavedItemsDataSource(viewController: self, rows: self.savedRows, sets: self.savedSets)
        savedItemsDelegate = SavedItemsTableDelegate(viewController: self, dataSource: savedItemsDataSource, rows: self.savedRows, sets: self.savedSets)
        tableView.delegate = savedItemsDelegate
        tableView.dataSource = savedItemsDataSource
        
        savedItemsDelegate.updateDelegate = self
        
        updateData()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshTable(sender:)), for: UIControl.Event.valueChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        savedItemsViewModel.updateData()
        //        updateData()
        tableView.reloadData()
    }
    
    // MARK: - Helper Functions
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.searchBar.endEditing(true)
    }
    
    @objc func refreshTable(sender:AnyObject) {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }
    
    
    func updateData() {
        savedItemsViewModel.savedRows.bind { rows in
            self.savedRows = rows
            self.savedItemsDataSource.savedRows = rows
            self.savedItemsDataSource.populateTableRows(rows: rows)
            self.savedItemsDelegate.savedRows = rows
        }
        
        savedItemsViewModel.savedSets.bind { sets in
            self.savedSets = sets
            self.savedItemsDataSource.savedSets = sets
            self.savedItemsDataSource.populateTableSets(sets: sets)
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
            detailVC.delegate = self
    }
    
}

extension SavedItemsTableViewController: ClickDelegate {
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            savedItemsDataSource.isSearching = false
            tableView.reloadData()
        } else {
            savedItemsDataSource.isSearching = true
            savedItemsDataSource.filterRows(searchString: searchText.lowercased())
            savedItemsDataSource.filterSets(searchString: searchText.lowercased())
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return text != " "
    }
    
}

extension SavedItemsTableViewController: UpdateTableDelegate {
    func updateTable() {
        savedItemsViewModel.updateData()
        updateData()
        tableView.reloadData()
        
//        tabBarController?.selectedIndex = 0
    }
}

