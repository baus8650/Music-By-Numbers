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
    
    init(row: Row) {
        self.matrixData = row
        defaults = UserDefaults.standard
        self.selectedCells.value = []
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
