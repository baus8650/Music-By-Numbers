//
//  MatrixViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/26/22.
//

import Foundation
import UIKit

class MatrixViewModel {
    
    var setViewModel: SetViewModel?
    var matrixDataSource: MatrixDataSource?
    
    var userRow: Binder<Row> = Binder(Row(row: [[]]))
    var prLabels: Binder<[String]> = Binder([])
    var iriLabels: Binder<[String]> = Binder([])
    var loneRow: Binder<[Int]> = Binder([])
    var rowString: String = ""
    var matrixRow = [[String]]()
    
    init(row: String) {
        self.rowString = row
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
    
    #warning("This is generally pretty gross; can this be broken up in multiple functions?")
    func generateMatrix(rowString: String) -> Row {
        userRow.value.row = [[]]
        matrixRow = [[String]]()
        var normalizedRow: [Int] = []
        var invertedRow: [Int] = []
        
        let rowArray = rowString.map(String.init)
        let rowSet = Set(rowArray)
        if rowSet.count < rowArray.count {
            return Row(row: [[]])
        } else {
            for i in rowArray {
                if i != " " {
                    if i == "t" || i == "a" {
                        normalizedRow.append(10)
                    } else if i == "e" || i == "b" {
                        normalizedRow.append(11)
                    } else {
                        normalizedRow.append(Int(i)!)
                    }
                }
            }
            loneRow.value = normalizedRow
            if normalizedRow.count == 12 {
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
                        #warning("Why is this even here?")
                        let _ = normalizedRow.map(String.init)
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
            userRow.value.row = matrixRow
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




