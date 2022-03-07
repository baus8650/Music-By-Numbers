//
//  MatrixDataSource.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 2/25/22.
//

import Foundation
import UIKit

class MatrixDataSource: NSObject, UICollectionViewDataSource {
    
    var matrixViewModel: MatrixViewModel?
    var matrixData: Row
//    var collectionView: UICollectionView?
    var prLabels = [String]()
    var iriLabels = [String]()
    
    init(row: Row, prLabels: [String], iriLabels: [String]) {
        self.matrixData = row
        
        self.prLabels = prLabels
        self.iriLabels = iriLabels
//        self.collectionView = collectionView
//        matrixViewModel = MatrixViewModel(row: row)
    }
    
    func setBaseline(for string: String, location: Int, length: Int) -> NSMutableAttributedString {
        let label = NSMutableAttributedString(string: string)
        label.setAttributes([NSAttributedString.Key.baselineOffset: -5], range: NSRange(location: location, length: length))
        label.addAttribute(.font, value: UIFont.systemFont(ofSize:9), range: NSRange(location: location, length: length))
        return label
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matrixData.row[0].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return matrixData.row[0].count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == 0 && indexPath.row == matrixData.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == matrixData.row[0].count - 1 && indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == matrixData.row[0].count - 1 && indexPath.row == matrixData.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCell", for: indexPath) as! BlankCollectionViewCell
            cell.backgroundColor = UIColor(named: "default")
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ICollectionViewCell", for: indexPath) as! ICollectionViewCell
            cell.labelLabel.attributedText = setBaseline(for: "I\(matrixData.row[indexPath.section][indexPath.row])", location: 1, length: iriLabels[indexPath.row].count)
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else if indexPath.section == matrixData.row[0].count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RICollectionViewCell", for: indexPath) as! RICollectionViewCell
            cell.labelLabel.attributedText = setBaseline(for: "RI\(matrixData.row[indexPath.section][indexPath.row])", location: 2, length: iriLabels[indexPath.row].count)
            cell.backgroundColor = UIColor(named: "default")
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PCollectionViewCell", for: indexPath) as! PCollectionViewCell
                cell.labelLabel.attributedText = setBaseline(for: "P\(matrixData.row[indexPath.section][indexPath.row])", location: 1, length: prLabels[indexPath.section - 1].count)
                
                cell.backgroundColor = UIColor(named: "default")
                return cell
            } else if indexPath.row == matrixData.row[0].count - 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RCollectionViewCell", for: indexPath) as! RCollectionViewCell
                cell.backgroundColor = UIColor(named: "default")
                cell.labelLabel.attributedText = setBaseline(for: "R\(matrixData.row[indexPath.section][indexPath.row])", location: 1, length: prLabels[indexPath.section - 1].count)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCell", for: indexPath) as! CollectionViewCell
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor(named: "default")?.cgColor
                cell.cellLabel.text = matrixData.row[indexPath.section][indexPath.row]
                cell.backgroundColor = UIColor(named: "default")
                return cell
            }
        }
    }
}
