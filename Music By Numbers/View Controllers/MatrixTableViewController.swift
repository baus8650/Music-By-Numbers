//
//  MatrixTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import UIKit
import CoreData

class MatrixTableViewController: UITableViewController {

    // MARK: - Properties
    
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
    
    let acceptedInputs = "0123456789teab"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet var setInfoButton: UIButton!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    
    @IBAction func toLibrary(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    @IBAction func helpButtonClicked(_ sender: Any) {
        let ac = UIAlertController(title: "Help", message: "A \"PC\" (Pitch Class) is an integer that represents a musical pitch where C = 0, C#/Db = 1, and continuing chromatically until B = 11. To simplify double-digit integers, 10 is represented by a or t and 11 is represented by b or e. To ensure an accurate calculation, this \"PC\" field will only allow you to enter these accepted characters: 0-9, a, b, t, and e.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func generatePressed(_ sender: UIButton) {
        if rowTextField.text! == "" {
            let ac = UIAlertController(title: "Empty submission", message: "The generator needs at least one value to process.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let rowString = rowTextField.text!
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
                generateMatrix(rowString: rowTextField.text!)
                collectionView.isHidden = false
                saveButton.isEnabled = true
            }
        }
    }
    
    @IBAction func matrixUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func clearSelectionPressed(_ sender: UIButton) {
        collectionView.reloadData()
        matrixDelegate?.selectedCells.value = [Int]()
        selectedCells = [Int]()
        setInfoButton.isEnabled = false
    }
    
    @IBAction func saveRow(_ sender: Any) {
        
        performSegue(withIdentifier: "matrixToDetail", sender: nil)
        
    }

    @IBAction func generateSet(_ sender: Any) {
        setViewModel = SetViewModel(set: selectedCells)
        
        normalForm = setViewModel?.findNormalForm(pcSet: selectedCells)
        primeForm = setViewModel?.findPrimeForm(normalForm: normalForm!)
        let destVC = tabBarController?.viewControllers![2] as! UINavigationController
        let setVC = destVC.topViewController as! SetTableViewController
        
        setVC.normalForm = self.normalForm!
        setVC.primeForm = self.primeForm!
        setVC.workingSet = self.normalForm!
        tabBarController?.selectedIndex = 2
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "matrixToDetail" {
            let detailVC = segue.destination as! DetailTableViewController
            detailVC.mainTitleText = "Save"
            detailVC.contentLabelText = "Row:"
            detailVC.contentFieldText = makeRowText(row: self.loneRow)
            detailVC.pieceField?.placeholder = "Enter name of piece (if applicable)..."
            detailVC.pieceLabelText = "Piece Information:"
            detailVC.notesLabelText = "Additional Notes:"
            detailVC.notesFieldText = ""
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowTextField.delegate = self
        collectionView.isHidden = true
        saveButton.isEnabled = false
        matrixViewModel = MatrixViewModel(row: "t50e96137824")
        matrixDelegate = MatrixCollectionDelegate(row: userRow, parent: self)
        matrixData = MatrixDataSource(row: userRow, prLabels: prLabels, iriLabels: iriLabels)
        collectionView.delegate = matrixDelegate
        collectionView.dataSource = matrixData
        
        updateMatrix()
        title = "Matrix"
    }
    
    // MARK: - Helper Functions
    
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
    
    func makeRowText(row: [Int]) -> String {
        var rowString = ""
        for i in 0..<row.count {
            if row[i] == 10 {
                rowString += UserDefaults.standard.string(forKey: "Ten") ?? "t"
            } else if row[i] == 11 {
                rowString += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
            } else {
                rowString += String(row[i])
            }
        }
        return rowString
    }

    // MARK: - Tableview Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

}

extension MatrixTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if rowTextField.text! == "" {
            return false
        } else {
            generateMatrix(rowString: rowTextField.text!)
            rowTextField.resignFirstResponder() // dismiss keyboard
            collectionView.isHidden = false
            saveButton.isEnabled = true
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: acceptedInputs).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
}

