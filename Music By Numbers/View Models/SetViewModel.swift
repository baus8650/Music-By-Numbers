//
//  SetViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/22/22.
//

import Foundation

class SetViewModel {
//    var userSet: [Int]?
//    
//    init(cells: [Int]) {
//        self.userSet = cells
//    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }

    func rotateSingleLeft(_ set: [Int]) -> [Int] {
        let first = set[0]
        var arr = set
        for i in 0..<set.count - 1 {
            arr[i] = arr[i + 1]
        }
        arr[set.count - 1] = first
        return arr
    }

    func findDistances(tiedSets: [[Int]]) -> [[Int]:[Int]] {
        var calculatedSets = [[Int]: [Int]]()
        
        for tie in tiedSets {
            var distances = [Int]()
            for i in 0..<tie.count {
                let index = 1 + i
                distances.append(abs(tie.first! - tie[tie.endIndex - index]))
            }
            calculatedSets[tie] = distances
        }
        
        return calculatedSets
    }

    func findTieBreaker(ties: [[Int]: [Int]], originalSet: [Int]) -> [Int] {
        var shortestDistance = [[Int]]()
        var localDistance = 13
        let cardinality = originalSet.count
        
    outerLoop: for i in 1..<cardinality {
        for (key, value) in ties {
            if value[i] < localDistance {
                localDistance = value[i]
                shortestDistance = [key]
            } else if value[i] == localDistance {
                shortestDistance.append(key)
            }
        }
        break outerLoop
    }
        
        if shortestDistance.count > 1 {
            let sortedForm = shortestDistance.sorted(by: {$0[0] < $1[0] })
            var normalForm = [Int]()
            for i in sortedForm[0] {
                if i < 12 {
                    normalForm.append(i)
                } else {
                    normalForm.append(i-12)
                }
            }
            return normalForm
        }
        
        var normalForm = [Int]()
        for i in shortestDistance[0] {
            if i < 12 {
                normalForm.append(i)
            } else {
                normalForm.append(i-12)
            }
        }
        
        return normalForm
        
    }

    func findNormalForm(pcSet: [Int]) -> [Int] {

        let sortedSet = pcSet.sorted()
        var workingSet = sortedSet
        var localSet: [Int] = sortedSet
        var tiedSets: [[Int]]?
        var distance = abs(sortedSet.first! - sortedSet.last!)
        for _ in 0..<workingSet.count - 1 {
            workingSet = rotateSingleLeft(workingSet)
            
            
            if workingSet.last! < workingSet.first! {
                workingSet[workingSet.endIndex-1] = workingSet.last! + 12
            }
            let localDistance = abs(workingSet.first! - workingSet.last!)
            
            if localDistance < distance {
                tiedSets = nil
                distance = localDistance
                localSet = workingSet
            } else if localDistance == distance {
                tiedSets = [[Int]]()
                    tiedSets!.append(localSet)
                    tiedSets!.append(workingSet)
            }
        }
        if tiedSets != nil {
            let distances = findDistances(tiedSets: tiedSets!)
            let normalForm = findTieBreaker(ties: distances, originalSet: pcSet)
            return normalForm
            
        } else {
            var normalForm = [Int]()
            for i in localSet {
                if i < 12 {
                    normalForm.append(i)
                } else {
                    normalForm.append(i-12)
                }
            }
            return normalForm
        }
    }

    func normalize(normalForm: [Int]) -> [Int] {
        let normalized = normalForm.map { mod($0-normalForm[0],12) }
        
        return normalized
    }

    func invertForm(normalizedForm: [Int]) -> [Int] {
        var invertedSet = [Int]()
        for i in normalizedForm {
            invertedSet.append((abs((i-12)%12)))
        }
        return invertedSet
    }

    func findPrimeForm(normalForm: [Int]) -> [Int] {
        let normalizedForm = normalize(normalForm: normalForm)
        let invertedForm = invertForm(normalizedForm: normalizedForm)
        let normalInvertedForm = findNormalForm(pcSet: invertedForm)
        let normalizedInvertedForm = normalize(normalForm: normalInvertedForm)
        let sets = [normalizedForm, normalizedInvertedForm]
        let distances = findDistances(tiedSets: sets)
        let primeForm = findTieBreaker(ties: distances, originalSet: normalizedForm)
        return primeForm
    }
}
