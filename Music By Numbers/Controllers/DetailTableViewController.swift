//
//  DetailTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import CoreData
import UIKit

class DetailTableViewController: UITableViewController {

    var editID: UUID?
    
    var delegate: UpdateDetailsProtocol?
    
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesField: UITextView!
    @IBOutlet var pieceLabel: UILabel!
    @IBOutlet var pieceField: UITextField!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentField: UITextField!
    @IBOutlet var mainTitle: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if isBeingDismissed {
//            self.performSegue(withIdentifier: "unwindSegue", sender: nil)
//        }
    }
    
    var coreDataActions: CoreDataActions!
    var indexPath: IndexPath!
    
    
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        saveData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    var mainTitleText: String! = ""
    var contentLabelText: String! = ""
    var contentFieldText: String? = ""
    var pieceLabelText: String! = ""
    var pieceFieldText: String? = ""
    var notesLabelText: String! = ""
    var notesFieldText: String? = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDatails()
        notesField?.layer.borderWidth = 1
        coreDataActions = CoreDataActions()
        indexPath = [0, 0]
        tableView.keyboardDismissMode = .onDrag
    }
    
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
