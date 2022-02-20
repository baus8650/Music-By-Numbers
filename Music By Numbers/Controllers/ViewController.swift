//
//  ViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 11/8/21.
//

import UIKit
import CoreData

let reuseIdentifier = "CellIdentifer";



class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var prLabels = [String]()
    var iriLabels = [String]()
    
    var savedRow: NSManagedObject!
    
    var normalForm: [Int]?
    var primeForm: [Int]?
    
    var userRow = Row(row: [[]])
    var loneRow = [Int]()
    
    var matrixRow = [[String]]()
    var selectedCells = [Int]()
    var setViewModel: SetViewModel?
    var rowPiece = ""
    var rowDate: Date?
    var rowNotes = ""
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    let margin: CGFloat = 1
    
    @IBOutlet var loneRowCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rowTextField: UITextField!
    
    @IBAction func saveRow(_ sender: Any) {
        
        let ac = UIAlertController(title: "Row Details", message: "Please enter any additional information for this row.", preferredStyle: .alert)
        ac.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter name of piece (if applicable)."
        })
        
        ac.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Enter any additional notes for this row."
        })
        
        
        
        present(ac, animated: true)
        
        
        
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "SavedRow", in: managedContext)!
            
            self.savedRow = NSManagedObject(entity: entity, insertInto: managedContext)
            
            let piece = ac.textFields![0] as UITextField
//            self.rowPiece = piece.text!
            self.savedRow.setValue(piece.text!, forKey: "piece")
            let notes = ac.textFields![1] as UITextField
//            self.rowNotes = notes.text!
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
    
    @IBAction func locatSets(_ sender: UIButton) {
        let ac = UIAlertController(title: "Enter set", message: "Please enter a set you would like to locate in the row.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Search", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something interesting with "answer" here
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        return
    }
    @objc func handleTap() {
        rowTextField.resignFirstResponder() // dismiss keyoard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        //       collectionView.layer.borderWidth = 1
        //        rowTextField.text! = "02468t13579e"
        generateMatrix(rowString: "t50e96137824")
        rowTextField.delegate = self
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        selectedCells = [Int]()
        //        collectionView.reloadData()
    }
    
    @IBAction func generatePressed(_ sender: UIButton) {
        generateMatrix(rowString: rowTextField.text!)
    }
    
    func generateMatrix(rowString: String) {
        userRow.row = [[]]
        matrixRow = [[String]]()
        var normalizedRow: [Int] = []
        var invertedRow: [Int] = []
        
        let rowArray = rowString.map(String.init)
        let rowSet = Set(rowArray)
        if rowSet.count < rowArray.count {
            //        if rowArray.count < 12 || rowSet.count < 12 {
            let ac = UIAlertController(title: "Repetition error", message: "The row should not repeat any pitch classes.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        } else {            
            for i in rowArray {
                if i == "t" || i == "a" {
                    normalizedRow.append(10)
                } else if i == "e" || i == "b" {
                    normalizedRow.append(11)
                } else {
                    normalizedRow.append(Int(i)!)
                }
            }
            loneRow = normalizedRow
            
            print("LONE ROW \(loneRow)")
            if normalizedRow.count == 12 {
                //                print("GOT A COUNT OF 12")
                normalizedRow = normalizedRow.map { mod($0-normalizedRow[0],12) }
                
                print(normalizedRow)
                for i in normalizedRow {
                    invertedRow.append((abs((i-12)%12)))
                }
                print(invertedRow)
                for i in 0...(invertedRow.count-1){
                    let index = invertedRow[i]
//                    print("INDEX",index)
                    
                    let newRow = normalizedRow.map { mod(($0+index),12) }
//                    print("TESTING",newRow, normalizedRow)
                    let stringRow = newRow.map(String.init)
//                    print("STRING ROW \(stringRow)")
                    matrixRow.append(stringRow)
                }
            } else {
                invertedRow.append(normalizedRow[0])
                var intRow = [Int]()
                for i in 1..<normalizedRow.count {
                    let index = normalizedRow[i] - normalizedRow[i-1]
                    intRow.append(index)
                    invertedRow.append(mod(invertedRow[i-1]-index,12))
                }
                let testRow = normalizedRow.map(String.init)
                matrixRow.append(testRow)
                for i in 0..<invertedRow.count{
                    if i == 0 {
                        let testRow = normalizedRow.map(String.init)
                    } else {
                        var newRow = [Int]()
                        for dist in intRow {
                            if newRow == [] {
                                newRow.append(invertedRow[i])
                                newRow.append(mod(invertedRow[i]+dist,12))
                            } else {
                                newRow.append(mod(newRow.last!+dist,12))
                            }
                        }
                        let stringRow = newRow.map(String.init)
                        matrixRow.append(stringRow)
                    }
                }
            }
            let vertLabels = setPLabels(matrix: matrixRow)
            let horLabels = setILabels(matrix: matrixRow)
            for i in 0..<matrixRow.count {
                matrixRow[i].insert(vertLabels[i], at: 0)
                matrixRow[i].insert(vertLabels[i], at: matrixRow[i].count)
            }
            matrixRow.insert(horLabels, at: 0)
            matrixRow.insert(horLabels, at: matrixRow.count)
        
//            print("MATRIX ROW \(matrixRow)")
            userRow.row = matrixRow
//            print("USER ROW \(userRow.row)")
            
            collectionView.reloadData()
            rowTextField.text = ""
            rowTextField.resignFirstResponder()
        }
    }
    
    func setBaseline(for string: String, location: Int, length: Int) -> NSMutableAttributedString {
        let label = NSMutableAttributedString(string: string)
        label.setAttributes([NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: location, length: length))
        label.addAttribute(.font, value: UIFont.systemFont(ofSize:9), range: NSRange(location: location, length: length))
        return label
    }
    
    func setPLabels(matrix: [[String]]) -> [String] {
        prLabels = [String]()
        for i in matrix {
            prLabels.append(i[0])
        }
        return prLabels
    }
    
    func setILabels(matrix: [[String]]) -> [String]{
        iriLabels = []
        iriLabels.append("")
        for i in matrix[0] {
            iriLabels.append(i)
        }
        iriLabels.append("")
        return iriLabels
    }
    
    @IBOutlet var setInfoButton: UIButton!
    @IBAction func clearSelectionPressed(_ sender: UIButton) {
        collectionView.reloadData()
        selectedCells = [Int]()
        setInfoButton.isEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userRow.row[0].count
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return userRow.row[0].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == 0 && indexPath.row == userRow.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == userRow.row[0].count - 1 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == userRow.row[0].count - 1 && indexPath.row == userRow.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ICollectionViewCell", for: indexPath) as! ICollectionViewCell
            cell.labelLabel.attributedText = setBaseline(for: "I\(userRow.row[indexPath.section][indexPath.row])", location: 1, length: iriLabels[indexPath.row].count)
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == userRow.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RICollectionViewCell", for: indexPath) as! RICollectionViewCell
            cell.labelLabel.attributedText = setBaseline(for: "RI\(userRow.row[indexPath.section][indexPath.row])", location: 2, length: iriLabels[indexPath.row].count)
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PCollectionViewCell", for: indexPath) as! PCollectionViewCell
                cell.labelLabel.attributedText = setBaseline(for: "P\(userRow.row[indexPath.section][indexPath.row])", location: 1, length: prLabels[indexPath.section - 1].count)
                
                cell.backgroundColor = UIColor(named: "default")
                return cell
            } else if indexPath.row == userRow.row[0].count - 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCollectionViewCell", for: indexPath) as! RCollectionViewCell
                cell.backgroundColor = UIColor(named: "default")
                cell.labelLabel.attributedText = setBaseline(for: "R\(userRow.row[indexPath.section][indexPath.row])", location: 1, length: prLabels[indexPath.section - 1].count)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCell", for: indexPath) as! CollectionViewCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(named: "default")?.cgColor
                cell.cellLabel.text = userRow.row[indexPath.section][indexPath.row]
                cell.backgroundColor = UIColor(named: "default")
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        if !selectedCells.contains(Int(cell.cellLabel.text!)!) {
            cell.layer.backgroundColor = CGColor(red: 0.3, green: 0.276, blue: 0.6, alpha: 1)
            selectedCells.append(Int(cell.cellLabel.text!)!)
            let selectedSet = Set(selectedCells)
            selectedCells = Array(selectedSet)
            print(selectedCells)
        } else {
            selectedCells = selectedCells.filter { return $0 != Int(cell.cellLabel.text!)! }
            cell.backgroundColor = UIColor(named: "default")
        }
        if selectedCells.count >= 2 {
            setInfoButton.isEnabled = true
        } else {
            setInfoButton.isEnabled = false
        }
    }
    // MARK: - FLOW LAYOUT METHOD
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = userRow.row[0].count   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MatrixToSet" {
            if let setVC = segue.destination as? SetViewController {
                setVC.normalForm = self.normalForm!
                setVC.primeForm = self.primeForm!
                setVC.workingSet = self.normalForm!
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        generateMatrix(rowString: rowTextField.text!)
        rowTextField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

