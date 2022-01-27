//
//  SetViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/22/22.
//

import Foundation

class SetViewModel {
    
    var pcCircleView: PCCircle!
    
    var startSet: [Int]?
    
    var setIndex: Binder<Int?> = Binder(nil)
    var searchField = Binder("")
    var listOfSets: Binder<ListSets?> = Binder(nil)
    var workingSet: Binder<[Int]> = Binder([])
    var primeForm: Binder<[Int]> = Binder([])
    var setDescription = Binder("")
    
    init(set: [Int]) {
        self.startSet = set
    }
    
    func calculate(set: String) {
        let rowArray = set.map(String.init)
        var workingRow = [Int]()
        for i in rowArray {
            if i == "t" || i == "a" {
                workingRow.append(10)
            } else if i == "e" || i == "b" {
                workingRow.append(11)
            } else {
                workingRow.append(Int(i)!)
            }
        }
        let newNormal = findNormalForm(pcSet: workingRow)
        print("FROM VIEW MODEL \(newNormal)")
        self.pcCircleView.setShape = newNormal
        self.workingSet.value = newNormal
        self.searchField.value = ""
    }
    
    func invert(workingSet: [Int]) {
        let invertedForm = invertForm(normalizedForm: workingSet)
        let newNormal = findNormalForm(pcSet: invertedForm)
        self.workingSet.value = newNormal
    }
    
    func rotateLeft(set: [Int]) {
        var rotatedSet = [Int]()
        for i in set {
            switch i {
            case 0:
                rotatedSet.append(11)
            default:
                rotatedSet.append(i-1)
            }
        }
        self.workingSet.value = rotatedSet
        
    }
    
    func rotateRight(set: [Int]) {
        var rotatedSet = [Int]()
        for i in set {
            switch i {
            case 11:
                rotatedSet.append(0)
            default:
                rotatedSet.append(i+1)
            }
        }
        self.workingSet.value = rotatedSet

    }
    
    func compliment(set: [Int]) {
        let pcList = [0,1,2,3,4,5,6,7,8,9,10,11]
        let compliment = pcList.filter { !set.contains($0) }
        if compliment.count >= 2 {
            let normCompliment = findNormalForm(pcSet: compliment)
            self.workingSet.value = normCompliment
        }
    }
    
    func tapFunction(pc: Int, workingSet: [Int]) {
        var compSet = workingSet
        if compSet.contains(pc) {
            let newNormal = compSet.filter { return $0 != pc }
            if newNormal.count >= 2 {
                let reduceNormal = findNormalForm(pcSet: newNormal)
                pcCircleView.setShape = reduceNormal
                self.workingSet.value = reduceNormal
            } else {
                self.workingSet.value = newNormal
            }
        } else {
            compSet.append(pc)
            if compSet.count >= 2 {
                let newNormal = findNormalForm(pcSet: compSet)
                pcCircleView.setShape = newNormal
                self.workingSet.value = newNormal
            } else {
                self.workingSet.value = compSet
            }
        }
    }
    
    func populateText(workingSet: [Int]) {
        print("called populate text")
        guard let index = listOfSets.value?.pcSets.firstIndex(where: { $0.primeForm == findPrimeForm(normalForm: workingSet) }) else { return }
        self.setIndex.value = index
        print("FROM MODEL \(index)")
        if workingSet.count > 10 {
            let primeForm = findPrimeForm(normalForm: workingSet)
            var primeDisplay = "("
            for i in primeForm {
                if i == 10 {
                    primeDisplay += "t"
                } else if i == 11 {
                    primeDisplay += "e"
                } else if i != 10 || i != 11 {
                    primeDisplay += "\(i)"
                }
            }
            primeDisplay += ")"
            let normalForm = findNormalForm(pcSet: workingSet)
            var normDisplay = "["
            for i in normalForm {
                
                if i == 10 {
                    normDisplay += "t"
                } else if i == 11 {
                    normDisplay += "e"
                } else if i != 10 || i != 11 {
                    normDisplay += "\(i)"
                }
            }
            normDisplay += "]"
            
            self.setDescription.value = """
    Normal form: \(normDisplay)
    Prime form: \(primeDisplay)
    """
        } else {
            let forteNumber = listOfSets.value?.pcSets[setIndex.value ?? 0].forteNumber
            let primeForm = listOfSets.value?.pcSets[setIndex.value ?? 0].primeForm
            var primeDisplay = "("
            for i in primeForm! {
                if i == 10 {
                    primeDisplay += "t"
                } else if i == 11 {
                    primeDisplay += "e"
                } else if i != 10 || i != 11 {
                    primeDisplay += "\(i)"
                }
            }
            primeDisplay += ")"
            let intervalVector = listOfSets.value?.pcSets[setIndex.value ?? 0].intervalVector
            let normalForm = findNormalForm(pcSet: self.workingSet.value)
            var normDisplay = "["
            for i in normalForm {
                
                if i == 10 {
                    normDisplay += "t"
                } else if i == 11 {
                    normDisplay += "e"
                } else if i != 10 || i != 11 {
                    normDisplay += "\(i)"
                }
            }
            normDisplay += "]"
            self.setDescription.value = """
Normal form: \(normDisplay)
Prime form: \(primeDisplay)
Forte number: \(forteNumber!)
Interval class vector: \(intervalVector!)
"""
        }
    }
    
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
