//
//  ViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 11/8/21.
//

import UIKit

let reuseIdentifier = "CellIdentifer";

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var prLabels = [String]()
    var iriLabels = [String]()
    
    var normalForm: [Int]?
    var primeForm: [Int]?
    
    var userRow = Row(row: [[]])
    
    var matrixRow = [[String]]()
    var selectedCells = [Int]()
    var setViewModel: SetViewModel?
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    let margin: CGFloat = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rowTextField: UITextField!
    
    @IBAction func generateSet(_ sender: Any) {
        setViewModel = SetViewModel()
        
        normalForm = setViewModel?.findNormalForm(pcSet: selectedCells)
        primeForm = setViewModel?.findNormalForm(pcSet: (setViewModel?.findPrimeForm(normalForm: selectedCells))!)

    }
    
    @objc func handleTap() {
        rowTextField.resignFirstResponder() // dismiss keyoard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.layer.borderWidth = 1
//        rowTextField.text! = "02468t13579e"
        generateMatrix(rowString: "02468t13579e")
        rowTextField.delegate = self
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedCells = [Int]()
        collectionView.reloadData()
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
//        } else if rowArray.count > 12 {
//            let ac = UIAlertController(title: "Length error", message: "The row should be 12 pitch classes long with no repeated pitch classes.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            present(ac, animated: true)
//            return
//        } else {
            
            for i in rowArray {
                if i == "t" || i == "a" {
                    normalizedRow.append(10)
                } else if i == "e" || i == "b" {
                    normalizedRow.append(11)
                } else {
                    normalizedRow.append(Int(i)!)
                }
            }
            
            normalizedRow = normalizedRow.map { mod($0-normalizedRow[0],12) }
            for i in normalizedRow {
                invertedRow.append((abs((i-12)%12)))
            }
            for i in 0...(invertedRow.count-1){
                let index = invertedRow[i]
                let newRow = normalizedRow.map { mod(($0+index),12) }
                let stringRow = newRow.map(String.init)
                matrixRow.append(stringRow)
            }

            let vertLabels = setPLabels(matrix: matrixRow)
            let horLabels = setILabels(matrix: matrixRow)
            for i in 0..<matrixRow.count {
                matrixRow[i].insert(vertLabels[i], at: 0)
                matrixRow[i].insert(vertLabels[i], at: matrixRow[i].count)
            }
            matrixRow.insert(horLabels, at: 0)
            matrixRow.insert(horLabels, at: matrixRow.count)
        
            userRow.row = matrixRow
            
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
            var selectedSet = Set(selectedCells)
            selectedCells = Array(selectedSet)
            print(selectedCells)
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
                setVC.normalForm = self.normalForm
                setVC.primeForm = self.primeForm
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

