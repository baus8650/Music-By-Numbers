//
//  MatrixTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import UIKit
import CoreData

class MatrixTableViewController: UIViewController {
    
    // MARK: - Properties
    
    var savedRow: NSManagedObject!
    var matrixViewModel: MatrixViewModel?
    var setViewModel: SetViewModel?
    var matrixDelegate: MatrixCollectionDelegate?
    var matrixData: MatrixDataSource?
    var setDescription: String?
    var listOfSets: ListSets?
    var networkManager: NetworkManager?
    
    var userRow = Row(row: [[]])
    var normalForm: [Int]?
    var primeForm: [Int]?
    var prLabels = [String]()
    var iriLabels = [String]()
    var selectedCells = [Int]()
    var loneRow = [Int]()
    
    let acceptedInputs = "0123456789teab"
    
    // MARK: - IBActions
    
    @IBAction func quickDetailsPressed(_ sender: Any) {
        if self.selectedCells.count >= 2 {
            print("Selected cells \(selectedCells)")
            //        setViewModel = SetViewModel(set: selectedCells)
            //        setViewModel?.workingSet.value = selectedCells
            print("Here is the set view model",
                  setViewModel?.workingSet.value)
            setViewModel?.listOfSets.value = self.listOfSets
            setViewModel!.populateText(workingSet: selectedCells)
            print("general value",
                  setViewModel?.setDescription.value)
            self.setViewModel?.setDescription.bind { text in
                self.setDescription = text
                print("Here's the text: \(text)")
            }
            let ac = UIAlertController(title: "Set Information", message: self.setDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.addAction(UIAlertAction(title: "View", style: .default, handler: { (action) -> Void in
                self.setViewModel = SetViewModel(set: self.selectedCells)
                
                self.normalForm = self.setViewModel?.findNormalForm(pcSet: self.selectedCells)
                self.primeForm = self.setViewModel?.findPrimeForm(normalForm: self.normalForm!)
                let destVC = self.tabBarController?.viewControllers![2] as! UINavigationController
                let setVC = destVC.topViewController as! SetTableViewController
                
                setVC.normalForm = self.normalForm!
                setVC.primeForm = self.primeForm!
                setVC.workingSet = self.normalForm!
                self.tabBarController?.selectedIndex = 2
            }))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Too Small", message: "This quick information button needs a selection of at least two PCs to process.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func toLibrary(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    @IBAction func helpButtonClicked(_ sender: Any) {
        let ac = UIAlertController(title: "Help", message: "A \"PC\" (Pitch Class) is an integer that represents a musical pitch where C = 0, C#/Db = 1, and continues chromatically until B = 11. To simplify double-digit integers, 10 is represented by a or t and 11 is represented by b or e. To ensure an accurate calculation, this \"PC\" field will only allow you to enter these accepted characters: 0-9, a, b, t, and e.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func generatePressed(_ sender: UIButton) {
//        generateMatrix(rowString: rowTextField.text!)
    }
    
    @IBAction func matrixUnwind(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func clearSelectionPressed(_ sender: UIButton) {
        matrixDelegate?.selectedCells.value = [Int]()
        selectedCells = [Int]()
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
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        setViewModel = SetViewModel(set: selectedCells)
        networkManager = NetworkManager()
        networkManager?.parseJSON { sets in
            self.listOfSets = sets
            self.setViewModel?.listOfSets.value = sets
            print(sets)
            self.setViewModel?.populateText(workingSet: self.selectedCells)
        }
        matrixViewModel = MatrixViewModel(row: "t50e96137824")
        matrixDelegate = MatrixCollectionDelegate(row: userRow, parent: self)
        matrixData = MatrixDataSource(row: userRow, prLabels: prLabels, iriLabels: iriLabels)
        
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
//                self.quickInfoButton.isEnabled = true
            } else if selectedCells.count == 1 {
//                self.clearPCButton.isEnabled = true
            } else {
//                self.clearPCButton.isEnabled = false
//                self.quickInfoButton.isEnabled = false
            }
        })
        
        matrixDelegate?.matrixData = userRow
        matrixData?.matrixData = userRow
        matrixData?.prLabels = prLabels
        matrixData?.iriLabels = iriLabels
        
    }
    
    func generateMatrix(rowString: String) {
        if rowString == "" {
            let ac = UIAlertController(title: "Empty submission", message: "The generator needs at least one value to process.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
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
                let _ = matrixViewModel?.generateMatrix(rowString: rowString)
                updateMatrix()
            }
        }
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
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.bounds
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 2
        default:
            return 20
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension MatrixTableViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if rowTextField.text! == "" {
//            return false
//        } else {
//            generateMatrix(rowString: rowTextField.text!)
//            rowTextField.resignFirstResponder() // dismiss keyboard
//            saveButton.isEnabled = true
//            return true
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: acceptedInputs).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
}

