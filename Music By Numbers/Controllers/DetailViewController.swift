//
//  DetailViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/27/22.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
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
        if isBeingDismissed {
            self.performSegue(withIdentifier: "unwindSegue", sender: nil)
        }
    }
    
    var coreDataActions: CoreDataActions!
    var indexPath: IndexPath!
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        print("WHAT IS HAPPENING \(self.mainTitleText)")
        if self.mainTitleText == "Save" {
            if self.contentLabelText == "Row:" {
                coreDataActions.save(type: "Row", content: contentField?.text ?? "", piece: pieceField?.text ?? "", notes: notesField?.text ?? "")
            } else if contentLabelText == "Set:" {
                print("TRYING TO SAVE SET")
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
//        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

