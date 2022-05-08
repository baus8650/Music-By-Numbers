//
//  DetailTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import CoreData
import UIKit

class DetailTableViewController: UITableViewController {

    // MARK: - Properties
    
    var delegate: UpdateDetailsProtocol?
    var coreDataActions: CoreDataActions!
    var editID: UUID?
    var indexPath: IndexPath!
    
    var mainTitleText: String! = ""
    var contentLabelText: String! = ""
    var contentFieldText: String? = ""
    var pieceLabelText: String! = ""
    var pieceFieldText: String? = ""
    var notesLabelText: String! = ""
    var notesFieldText: String? = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesField: UITextView!
    @IBOutlet var pieceLabel: UILabel!
    @IBOutlet var pieceField: UITextField!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentField: UITextField!
    @IBOutlet var mainTitle: UILabel!

    // MARK: - IBActions

    @IBAction func savedButtonPressed(_ sender: Any) {
        saveData()
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDatails()
        notesField?.layer.borderWidth = 1
        coreDataActions = CoreDataActions()
        indexPath = [0, 0]
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Helper Functions
    
    func saveData() {
        if self.mainTitleText == "Save" {
            if self.contentLabelText == "Row:" {
                coreDataActions.save(type: "Row", content: contentField?.text ?? "", piece: pieceField?.text ?? "", notes: notesField?.text ?? "")
            } else if contentLabelText == "Set:" {
                coreDataActions.save(type: "Set", content: contentField?.text ?? "", piece: pieceField?.text ?? "", notes: notesField?.text ?? "")
            }
        } else if self.mainTitleText == "Edit" {
            if contentLabelText == "Row:" {
                coreDataActions.update(type: "Row", editID: self.editID!, pieceField: pieceField?.text ?? "", notesField: notesField?.text ?? "", contentField: contentField?.text ?? "")
            } else if contentLabelText == "Set:" {
                coreDataActions.update(type: "Set", editID: self.editID!, pieceField: pieceField?.text ?? "", notesField: notesField?.text ?? "", contentField: contentField?.text ?? "")
            }
        }
        
        self.performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
    func updateDatails() {
        mainTitle?.text = mainTitleText!
        contentLabel?.text = contentLabelText
        contentField?.text = contentFieldText
        pieceLabel?.text = pieceLabelText
        pieceField?.text = pieceFieldText
        notesLabel?.text = notesLabelText
        notesField?.text = notesFieldText
    }

    // MARK: - Tableview Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
