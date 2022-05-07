//
//  SetViewModel.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/22/22.
//

import Foundation

class SetViewModel {
    
    var startSet: [Int]?
    
    var setIndex: Binder<Int?> = Binder(nil)
    var searchField = Binder("")
    var listOfSets: Binder<ListSets?> = Binder(nil)
    var workingSet: Binder<[Int]> = Binder([])
    var primeForm: Binder<[Int]> = Binder([])
    var setDescription = Binder("")
    var normalFormLabel = Binder("")
    var primeFormLabel = Binder("")
    var forteLabel = Binder("")
    var intervalLabel = Binder("")
    
    init(set: [Int]) {
        self.workingSet.value = set
        
    }
    
    func calculate(set: String) {
        let rowArray = set.map(String.init)
        var workingRow = [Int]()
        for i in rowArray {
            if i != " " {
                if i == "t" || i == "a" {
                    workingRow.append(10)
                } else if i == "e" || i == "b" {
                    workingRow.append(11)
                } else {
                    workingRow.append(Int(i)!)
                }
            }
        }
        let newNormal = findNormalForm(pcSet: workingRow)
        self.workingSet.value = newNormal
        self.searchField.value = ""
        populateText(workingSet: self.workingSet.value)
    }
    
    func clear() {
        self.workingSet.value = [Int]()
        self.setDescription.value = ""
        self.searchField.value = ""
    }
    
    func invert(workingSet: [Int]) {
        let invertedForm = invertForm(normalizedForm: workingSet)
        let newNormal = findNormalForm(pcSet: invertedForm)
        self.workingSet.value = newNormal
        populateText(workingSet: self.workingSet.value)
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
        populateText(workingSet: self.workingSet.value)
        
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
        populateText(workingSet: self.workingSet.value)
    }
    
    func compliment(set: [Int]) {
        let pcList = [0,1,2,3,4,5,6,7,8,9,10,11]
        let compliment = pcList.filter { !set.contains($0) }
        if compliment.count >= 2 {
            let normCompliment = findNormalForm(pcSet: compliment)
            self.workingSet.value = normCompliment
        }
        populateText(workingSet: self.workingSet.value)
    }
    
    func tapFunction(pc: Int, workingSet: [Int]) {
        var compSet = workingSet
        if compSet.contains(pc) {
            let newNormal = compSet.filter { return $0 != pc }
            if newNormal.count >= 2 {
                let reduceNormal = findNormalForm(pcSet: newNormal)
                self.workingSet.value = reduceNormal
            } else {
                self.workingSet.value = newNormal
            }
        } else {
            compSet.append(pc)
            if compSet.count >= 2 {
                let newNormal = findNormalForm(pcSet: compSet)
                self.workingSet.value = newNormal
            } else {
                self.workingSet.value = compSet
            }
        }
        populateText(workingSet: self.workingSet.value)
    }
    
    func populateText(workingSet: [Int]) {
        
        if workingSet.count < 2 {
            
            self.setDescription.value = """
Normal form:
Prime form:
Forte number:
Interval class vector:
"""
            return
        }
        if workingSet.count > 10 {
            let primeForm = findPrimeForm(normalForm: workingSet)
            var primeDisplay = "("
            for i in primeForm {
                if i == 10 {
                    primeDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
                } else if i == 11 {
                    primeDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
                } else if i != 10 || i != 11 {
                    primeDisplay += "\(i)"
                }
            }
            primeDisplay += ")"
            let normalForm = findNormalForm(pcSet: workingSet)
            var normDisplay = "["
            for i in normalForm {
                
                if i == 10 {
                    normDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
                } else if i == 11 {
                    normDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
                } else if i != 10 || i != 11 {
                    normDisplay += "\(i)"
                }
            }
            normDisplay += "]"
            
            self.setDescription.value = """
    Normal form: \(normDisplay)
    Prime form: \(primeDisplay)
    """
        } else if workingSet.count >= 2 {
            guard let index = listOfSets.value?.pcSets.firstIndex(where: { $0.primeForm == findPrimeForm(normalForm: workingSet) }) else { return }
            self.setIndex.value = index
            let forteNumber = listOfSets.value?.pcSets[setIndex.value ?? 0].forteNumber
            let primeForm = listOfSets.value?.pcSets[setIndex.value ?? 0].primeForm
            var primeDisplay = "("
            for i in primeForm! {
                if i == 10 {
                    primeDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
                } else if i == 11 {
                    primeDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
                } else if i != 10 || i != 11 {
                    primeDisplay += "\(i)"
                }
            }
            primeDisplay += ")"
            let intervalVector = listOfSets.value?.pcSets[setIndex.value ?? 0].intervalVector
            let normalForm = findNormalForm(pcSet: workingSet)
            var normDisplay = "["
            for i in normalForm {
                
                if i == 10 {
                    normDisplay += UserDefaults.standard.string(forKey: "Ten") ?? "t"
                } else if i == 11 {
                    normDisplay += UserDefaults.standard.string(forKey: "Eleven") ?? "e"
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
            self.normalFormLabel.value = normDisplay
            self.primeFormLabel.value = primeDisplay
            self.forteLabel.value = forteNumber!
            self.intervalLabel.value = intervalVector!
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

    func findNewTieBreaker(ties: [[Int]: [Int]]) -> [Int] {
        var sets = [[Int]]()
//        var primeForm: [Int]?
        for (key, _) in ties {
            sets.append(key)
        }
        
        if sets.count == 1 {
            var normalForm = [Int]()
            for i in sets[0] {
                if i < 12 {
                    normalForm.append(i)
                } else {
                    normalForm.append(i-12)
                }
            }
            
            return normalForm
        }
        
        for i in 1..<sets[0].count {
            if sets[0][i] < sets[1][i] {
                var normalForm = [Int]()
                for i in sets[0] {
                    if i < 12 {
                        normalForm.append(i)
                    } else {
                        normalForm.append(i-12)
                    }
                }
                
                return normalForm
            } else if sets[1][i] < sets[0][i] {
                var normalForm = [Int]()
                for i in sets[1] {
                    if i < 12 {
                        normalForm.append(i)
                    } else {
                        normalForm.append(i-12)
                    }
                }
                return normalForm
            }
        }
        print("THIS SHOULD NEVER BE CALLED!!!!")
        var normalForm = [Int]()
        for i in sets[0] {
            if i < 12 {
                normalForm.append(i)
            } else {
                normalForm.append(i-12)
            }
        }
        
        return normalForm
//        return primeForm
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
        tiedSets = nil
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
                if tiedSets == nil {
                    tiedSets = [[Int]]()
                    tiedSets!.append(localSet)
                    tiedSets!.append(workingSet)
                } else {
//                tiedSets = [[Int]]()
                    tiedSets!.append(localSet)
                    tiedSets!.append(workingSet)
                }
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
        let primeForm = findNewTieBreaker(ties: distances)//, originalSet: normalizedForm)
        return primeForm
    }
}
