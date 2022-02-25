//
//  MatrixCollectionDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/25/22.
//

import Foundation
import UIKit

class MatrixCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
//    var collectionView: UICollectionView?
    var selectedCells = [Int]()
    var matrixData: Row
    
    init(row: Row) {
        self.matrixData = row
        
        
//        self.collectionView = collectionView
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
        #warning("set info button needs to be disabled if too small")
//        if selectedCells.count >= 2 {
//            setInfoButton.isEnabled = true
//        } else {
//            setInfoButton.isEnabled = false
//        }
    }
    // MARK: - FLOW LAYOUT METHOD
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = matrixData.row[0].count   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
        
    }
    
}
