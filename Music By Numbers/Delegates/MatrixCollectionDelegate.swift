//
//  MatrixCollectionDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/25/22.
//

import Foundation
import UIKit

class MatrixCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var selectedCells: Binder<[Int]> = Binder([])
    var matrixData: Row
    var defaults: UserDefaults
    let margin: CGFloat = 1
    var selectedIndexes = [IndexPath]()
    var parent: UITableViewController
    
    init(row: Row, parent: UITableViewController) {
        self.matrixData = row
        defaults = UserDefaults.standard
        self.selectedCells.value = []
        self.parent = parent
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("HERE'S THE INDEX PATH SECTION \(indexPath.section) and the matrix data count \(matrixData.row[0].count)")
        if indexPath.section == 0 || indexPath.section == matrixData.row[0].count - 1 || indexPath.row == 0 || indexPath.row == matrixData.row[0].count - 1 {
            let ac = UIAlertController(title: "Selection Error", message: "You cannot add a row or column label to the pitch class collection. Please only select a PC from inside the body of the matrix.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            parent.present(ac, animated: true)
            
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            if !selectedCells.value.contains(Int(cell.cellLabel.text!)!) {
                cell.layer.backgroundColor = defaults.color(forKey: "MatrixCellColor")?.cgColor
                selectedCells.value.append(Int(cell.cellLabel.text!)!)
                let selectedSet = Set(selectedCells.value)
                selectedCells.value = Array(selectedSet)
                selectedIndexes.append(indexPath)
            } else {
                for i in selectedIndexes {
                    if i == indexPath {
                        let index = selectedIndexes.firstIndex(of: i)
                        selectedIndexes.remove(at: index!)
                        selectedCells.value = selectedCells.value.filter { return $0 != Int(cell.cellLabel.text!)! }
                    }
                }
                cell.backgroundColor = UIColor(named: "default")
            }
        }
    }
    
    // MARK: - FLOW LAYOUT METHOD
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = matrixData.row[0].count
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let leftInset = flowLayout.sectionInset.left
        let rightInset = flowLayout.sectionInset.right
        let minimumSpacing = flowLayout.minimumInteritemSpacing
        
        let totalSpace = leftInset + rightInset + (minimumSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
        
    }
    
}
