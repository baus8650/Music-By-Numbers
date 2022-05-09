//
//  DetailTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import CoreData
import UIKit

protocol UpdateTableDelegate {
    func updateTable()
}

class DetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var delegate: UpdateTableDelegate?
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
    let acceptedInputs = "0123456789teab"
    
    // MARK: - IBOutlets
    
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var pieceLabel: UILabel!
    @IBOutlet var pieceField: UITextField! {
        didSet {
            let borderColor: UIColor = .opaqueSeparator
            pieceField.layer.cornerRadius = 5
            pieceField.layer.borderColor = borderColor.cgColor
            pieceField.layer.borderWidth = 0.5
        }
    }
    @IBOutlet var notesField: UITextView! {
        didSet {
            let borderColor: UIColor = .opaqueSeparator
            notesField.layer.cornerRadius = 5
            notesField.layer.borderWidth = 0.5
            notesField.layer.borderColor = borderColor.cgColor
            //            notesField.
        }
    }
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentField: UITextField! {
        didSet {
            let borderColor: UIColor = .opaqueSeparator
            contentField.layer.cornerRadius = 5
            contentField.layer.borderWidth = 0.5
            contentField.layer.borderColor = borderColor.cgColor
        }
    }
    @IBOutlet var mainTitle: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        //        dismiss(animated: true)
        if contentField.text! == "" {
            var type = self.contentLabelText
            type = String(type!.dropLast())
            let ac = UIAlertController(title: "Empty submission", message: "In order to \(self.mainTitleText.lowercased()) this entry, the \(type!.lowercased()) must contain at least \(self.contentLabelText == "Row:" ? "one value." : "two values.")", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            if self.contentLabelText == "Row:" {
                let rowString = contentField.text!
                let rowArray = rowString.map(String.init)
                let rowSet = Set(rowArray)
                if rowSet.count < rowArray.count {
                    let ac = UIAlertController(title: "Repetition error", message: "The row should not repeat any pitch classes.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                } else if rowArray.contains("a") && rowArray.contains("t") || rowArray.contains("b") && rowArray.contains("e") {
                    let ac = UIAlertController(title: "Variable Mix Error", message: "The row should not mix a/b and t/e. Please use one or the other.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                    
                } else {
                    saveData()
                }
            } else {
                let setString = contentField.text!
                let setArray = setString.map(String.init)
                if setArray.contains("a") && setArray.contains("t") || setArray.contains("b") && setArray.contains("e") {
                    let ac = UIAlertController(title: "Variable Mix Error", message: "The set should not mix a/b and t/e. Please use one or the other.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                } else {
                    saveData()
                }
            }
        }
        //        saveData()
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDatails()
        notesField?.layer.borderWidth = 1
        coreDataActions = CoreDataActions()
        indexPath = [0, 0]
        tableView.keyboardDismissMode = .onDrag
        contentField.delegate = self
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
        delegate?.updateTable()
        
        dismiss(animated: true)
        //        self.performSegue(withIdentifier: "unwindSegue", sender: nil)
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

extension DetailTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contentField {
            let cs = NSCharacterSet(charactersIn: acceptedInputs).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        } else {
            return true
        }
    }
    
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
