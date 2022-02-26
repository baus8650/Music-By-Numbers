//
//  ViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 11/8/21.
//

import UIKit
import CoreData

class MatrixViewController: UIViewController {
    
    var savedRow: NSManagedObject!
    var matrixViewModel: MatrixViewModel?
    var setViewModel: SetViewModel?
    var matrixDelegate: MatrixCollectionDelegate?
    var matrixData: MatrixDataSource?
    
    var userRow = Row(row: [[]])
    var normalForm: [Int]?
    var primeForm: [Int]?
    var prLabels = [String]()
    var iriLabels = [String]()
    var selectedCells = [Int]()
    var loneRow = [Int]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet var setInfoButton: UIButton!
    
    @IBAction func generatePressed(_ sender: UIButton) {
        generateMatrix(rowString: rowTextField.text!)
    }
    
    @IBAction func clearSelectionPressed(_ sender: UIButton) {
        collectionView.reloadData()
        matrixDelegate?.selectedCells.value = [Int]()
        selectedCells = [Int]()
        setInfoButton.isEnabled = false
    }
    
    @IBAction func saveRow(_ sender: Any) {
        
        let ac = UIAlertController(title: "Row Details", message: "Please enter any additional information for this row.", preferredStyle: .alert)
        ac.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter name of piece (if applicable)."
        })

        ac.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter any additional notes for this row."
        })

        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "SavedRow", in: managedContext)!

            self.savedRow = NSManagedObject(entity: entity, insertInto: managedContext)

            let piece = ac.textFields![0] as UITextField
            self.savedRow.setValue(piece.text!, forKey: "piece")
            let notes = ac.textFields![1] as UITextField
            self.savedRow.setValue(notes.text!, forKey: "notes")
            self.savedRow.setValue(Date(), forKey: "dateCreated")
            self.savedRow.setValue(self.loneRow, forKey: "userRow")
            self.savedRow.setValue(UUID(), forKey: "id")

            do {
                try managedContext.save()
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            print("Cancelled Save")
        }))
        
        present(ac, animated: true)
        
    }
    
    @IBAction func generateSet(_ sender: Any) {
        setViewModel = SetViewModel(set: selectedCells)
        
        normalForm = setViewModel?.findNormalForm(pcSet: selectedCells)
        primeForm = setViewModel?.findPrimeForm(normalForm: normalForm!)
        let destVC = tabBarController?.viewControllers![2] as! UINavigationController
        let setVC = destVC.topViewController as! SetViewController
        
        setVC.normalForm = self.normalForm!
        setVC.primeForm = self.primeForm!
        setVC.workingSet = self.normalForm!
        tabBarController?.selectedIndex = 2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowTextField.delegate = self

        matrixViewModel = MatrixViewModel(row: "t50e96137824")
        matrixDelegate = MatrixCollectionDelegate(row: userRow)
        matrixData = MatrixDataSource(row: userRow, prLabels: prLabels, iriLabels: iriLabels)
        
        collectionView.delegate = matrixDelegate
        collectionView.dataSource = matrixData
        
        updateMatrix()
        
    }
    
    func updateMatrix() {
        matrixViewModel?.userRow.bind(listener: { [weak self] row in
            self?.userRow = row
        })
        
        matrixViewModel?.prLabels.bind(listener: { [weak self] prLabels in
            self?.prLabels = prLabels
        })
        
        matrixViewModel?.iriLabels.bind(listener: { [weak self] iriLabels in
            self?.iriLabels = iriLabels
        })
        
        matrixViewModel?.loneRow.bind(listener: { row in
            self.loneRow = row
        })
        
        matrixDelegate?.selectedCells.bind(listener: { selectedCells in
            self.selectedCells = selectedCells
            if selectedCells.count >= 2 {
                self.setInfoButton.isEnabled = true
            } else {
                self.setInfoButton.isEnabled = false
            }
        })
        
        matrixDelegate?.matrixData = userRow
        matrixData?.matrixData = userRow
        matrixData?.prLabels = prLabels
        matrixData?.iriLabels = iriLabels
        
    }
    
    func generateMatrix(rowString: String) {
        rowTextField.resignFirstResponder() // dismiss keyoard
        
        let _ = matrixViewModel?.generateMatrix(rowString: rowString)
        updateMatrix()
        
        collectionView.reloadData()
    }
    
    
}

extension MatrixViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        generateMatrix(rowString: rowTextField.text!)
        rowTextField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

