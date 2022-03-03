//
//  DetailViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/27/22.
//

import UIKit
import CoreData

protocol SavedItemsProtocol {
    func saveUpdatedEntry(content: String, piece: String, notes: String)
}

class DetailViewController: UIViewController {
    
    var editID: UUID?
    
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var notesField: UITextView!
    @IBOutlet var pieceLabel: UILabel!
    @IBOutlet var pieceField: UITextField!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentField: UITextField!
    @IBOutlet var mainTitle: UILabel!
    
    @IBAction func savedButtonPressed(_ sender: Any) {
        
        if self.mainTitleText == "Save" {
            if self.contentLabelText == "Row:" {
                
                let savedRow: NSManagedObject!
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "SavedRow", in: managedContext)!
                
                savedRow = NSManagedObject(entity: entity, insertInto: managedContext)
                
                savedRow.setValue(pieceField?.text, forKey: "piece")
                savedRow.setValue(notesField?.text, forKey: "notes")
                savedRow.setValue(Date(), forKey: "dateCreated")
                let localRow = contentField.text!.map(String.init)
                var intRow = [Int]()
                for i in localRow {
                    if i.isInt {
                        intRow.append(Int(i)!)
                    }
                }
                print("USER ROW: \(intRow)")
                savedRow.setValue(intRow, forKey: "userRow")
                savedRow.setValue(UUID(), forKey: "id")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("could not save. \(error), \(error.userInfo)")
                }
            } else if contentLabelText == "Set:" {
                let savedSet: NSManagedObject!
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "SavedSet", in: managedContext)!
                
                savedSet = NSManagedObject(entity: entity, insertInto: managedContext)
                
                savedSet.setValue(pieceField?.text, forKey: "piece")
                savedSet.setValue(notesField?.text, forKey: "notes")
                savedSet.setValue(Date(), forKey: "dateCreated")
                let localSet = contentField.text!.map(String.init)
                var intSet = [Int]()
                for i in localSet {
                    if i.isInt {
                        intSet.append(Int(i)!)
                    }
                }
                savedSet.setValue(intSet, forKey: "userSet")
                savedSet.setValue(UUID(), forKey: "id")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("could not save. \(error), \(error.userInfo)")
                }
            }
        } else if self.mainTitleText == "Edit" {
            print("IN THE EDIT BLOCK")
            if contentLabelText == "Row:" {
                
                let editRow: NSManagedObject!
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedRow")
                fetchRequest.predicate = NSPredicate(format: "id == %@", editID! as CVarArg)
                
                let results = try? managedContext.fetch(fetchRequest)
                
                if results?.count == 0 {
                    return
                } else {
                    editRow = results?.first
                }
                
                editRow.setValue(pieceField?.text, forKey: "piece")
                editRow.setValue(notesField?.text, forKey: "notes")
                editRow.setValue(Date(), forKey: "dateCreated")
                let localRow = contentField.text!.map(String.init)
                var intRow = [Int]()
                for i in localRow {
                    if i.isInt {
                        intRow.append(Int(i)!)
                    }
                }
                print("USER ROW: \(intRow)")
                editRow.setValue(intRow, forKey: "userRow")
                editRow.setValue(editID, forKey: "id")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("could not save. \(error), \(error.userInfo)")
                }
                
            } else if contentLabelText == "Set:" {
                let editSet: NSManagedObject!
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedSet")
                fetchRequest.predicate = NSPredicate(format: "id == %@", editID! as CVarArg)
                
                let results = try? managedContext.fetch(fetchRequest)
                
                if results?.count == 0 {
                    print("Didn't find a result")
                    return
                } else {
                    editSet = results?.first
                }
                
                editSet.setValue(pieceField?.text, forKey: "piece")
                editSet.setValue(notesField?.text, forKey: "notes")
                editSet.setValue(Date(), forKey: "dateCreated")
                let localSet = contentField.text!.map(String.init)
                var intSet = [Int]()
                for i in localSet {
                    if i.isInt {
                        intSet.append(Int(i)!)
                    }
                }
//                print("USER ROW: \(intRow)")
                editSet.setValue(intSet, forKey: "userSet")
                editSet.setValue(editID, forKey: "id")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("could not save. \(error), \(error.userInfo)")
                }
            }
        }

        dismiss(animated: true, completion: nil)
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
    
    var delegate: SavedItemsProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesField.layer.borderWidth = 1
        updateDatails()
        print("SENT OVER ID",editID)
    }
    
    func updateDatails() {
        mainTitle?.text = mainTitleText!
        contentLabel?.text = contentLabelText
        contentField?.text = contentFieldText
        pieceLabel?.text = pieceLabelText
        pieceField?.text = pieceFieldText
        notesLabel?.text = notesLabelText
        notesField?.text = notesFieldText
        print("SENT OVER ID",editID)
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
