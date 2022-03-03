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
        
        let rowString = rowTextField.text!
        let rowArray = rowString.map(String.init)
        let rowSet = Set(rowArray)
        if rowSet.count < rowArray.count {
            let ac = UIAlertController(title: "Repetition error", message: "The row should not repeat any pitch classes.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            generateMatrix(rowString: rowTextField.text!)
        }
    }
    
    @IBAction func clearSelectionPressed(_ sender: UIButton) {
        collectionView.reloadData()
        matrixDelegate?.selectedCells.value = [Int]()
        selectedCells = [Int]()
        setInfoButton.isEnabled = false
    }
    
    @IBAction func saveRow(_ sender: Any) {
        
        let detailVC = DetailViewController()
        detailVC.mainTitleText = "Save"
        detailVC.contentLabelText = "Row:"
        detailVC.contentFieldText = makeRowText(row: self.loneRow)
        detailVC.pieceField?.placeholder = "Enter name of piece (if applicable)..."
        detailVC.pieceLabelText = "Piece Information:"
        detailVC.notesLabelText = "Additional Notes:"
        detailVC.notesFieldText = ""
        
        self.present(detailVC, animated: true, completion: nil)
        
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
    
    func makeRowText(row: [Int]) -> String {
        var rowString = "["
        for i in 0..<row.count {
            if i == row.count - 1 {
                rowString += "\(String(row[i]))]"
            } else {
                rowString += "\(String(row[i])), "
            }
        }
        return rowString
    }
    
    
}

extension MatrixViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        generateMatrix(rowString: rowTextField.text!)
        rowTextField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

extension MatrixViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
