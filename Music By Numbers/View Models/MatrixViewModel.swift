//
//  MatrixViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/26/22.
//

import Foundation
import UIKit

class MatrixViewModel {
    
    var prLabels: Binder<[String]> = Binder([])
    var iriLabels: Binder<[String]> = Binder([])
    
    var rowString: Binder<String> = Binder("")
    var userRow: Binder<Row> = Binder(Row(row: [[]]))
    var loneRow: Binder<[Int]> = Binder([])
    
    var matrixRow: Binder<[[String]]> = Binder([[]])
    
    var setViewModel: SetViewModel?
    
    var rowPiece: Binder<String> = Binder("")
    var rowDate: Binder<Date?> = Binder(nil)
    var rowNotes: Binder<String> = Binder("")
    
    var normalForm: Binder<[Int]> = Binder([])
    var primeForm: Binder<[Int]> = Binder([])
    
    var matrixDataSource: MatrixDataSource?
    
    init(row: String) {
        self.rowString.value = row
        self.userRow.value = generateMatrix(rowString: row)
        if userRow.value.row == [[]] {
            return
        }
        let matrixData = userRow.value
        
        self.matrixDataSource = MatrixDataSource(row: matrixData, prLabels: prLabels.value, iriLabels: iriLabels.value)
    }
    
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    
    
    func generateMatrix(rowString: String) -> Row {
        userRow.value.row = [[]]
        matrixRow.value = [[String]]()
        var normalizedRow: [Int] = []
        var invertedRow: [Int] = []
        
        let rowArray = rowString.map(String.init)
        let rowSet = Set(rowArray)
        if rowSet.count < rowArray.count {
#warning("Figure out how to present an alert from a view model")
            //            let ac = UIAlertController(title: "Repetition error", message: "The row should not repeat any pitch classes.", preferredStyle: .alert)
            //            ac.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(ac, animated: true)
//            return
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
            loneRow.value = normalizedRow
            
            print("LONE ROW \(loneRow.value)")
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
                    matrixRow.value.append(stringRow)
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
                matrixRow.value.append(testRow)
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
                        matrixRow.value.append(stringRow)
                    }
                }
            }
            let vertLabels = setPLabels(matrix: matrixRow.value)
            let horLabels = setILabels(matrix: matrixRow.value)
            for i in 0..<matrixRow.value.count {
                matrixRow.value[i].insert(vertLabels[i], at: 0)
                matrixRow.value[i].insert(vertLabels[i], at: matrixRow.value[i].count)
            }
            matrixRow.value.insert(horLabels, at: 0)
            matrixRow.value.insert(horLabels, at: matrixRow.value.count)
            
            //            print("MATRIX ROW \(matrixRow)")
            userRow.value.row = matrixRow.value
            //            print("USER ROW \(userRow.row)")
            
            #warning("Update collection view")
//            collectionView.reloadData()
//            rowTextField.text = ""
            #warning("Update text and resign first responder")
//            rowTextField.resignFirstResponder()
        }
        
        return userRow.value
        
    }
    
    func setPLabels(matrix: [[String]]) -> [String] {
        prLabels.value = [String]()
        for i in matrix {
            prLabels.value.append(i[0])
        }
        return prLabels.value
    }
    
    func setILabels(matrix: [[String]]) -> [String]{
        iriLabels.value = []
        iriLabels.value.append("")
        for i in matrix[0] {
            iriLabels.value.append(i)
        }
        iriLabels.value.append("")
        return iriLabels.value
    }
    
    
    
}




