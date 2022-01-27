//
//  SetViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import UIKit

class SetViewController: UIViewController, UITextFieldDelegate {
    
    var normalForm: [Int]?
    var primeForm: [Int]? {
        didSet {
            if primeForm!.count >= 2 {
                guard let index = listOfSets?.pcSets.firstIndex(where: { $0.primeForm == self.primeForm }) else { return }
                setIndex = index
                
                populateText(workingSet: self.primeForm!, setIndex: index)
            }
        }
    }
    var workingSet = [Int]() {
        didSet {
            if workingSet.count >= 2 {
                guard let index = listOfSets?.pcSets.firstIndex(where: { $0.primeForm == setViewModel.findPrimeForm(normalForm: workingSet) }) else { return }
                setIndex = index
                
                populateText(workingSet: workingSet, setIndex: index)
            }
        }
    }
    var setIndex: Int?
    var listOfSets: ListSets? {
        didSet {
            
            guard let index = listOfSets?.pcSets.firstIndex(where: { $0.primeForm == setViewModel.findPrimeForm(normalForm: workingSet) }) else { return }
            setIndex = index

            populateText(workingSet: workingSet, setIndex: index)
        }
    }
    
    var setViewModel: SetViewModel!
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var rotateLeftButton: UIButton!
    @IBOutlet var rotateRightButton: UIButton!
    @IBOutlet var pcCircleView: PCCircle!
    @IBAction func complimentButton(_ sender: UIButton) {
        compliment(workingSet: self.workingSet)
    }
    
    @IBOutlet var setTextField: UITextView!
    @IBAction func clearButton(_ sender: UIButton) {
        self.workingSet = [Int]()
        pcCircleView.setShape = self.workingSet
        setTextField.text! = """
Normal form:
Prime form:
Forte number:
Interval class vector:
"""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let rowArray = searchField.text!.map(String.init)
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
        let newNormal = setViewModel.findNormalForm(pcSet: workingRow)
        
        self.workingSet = newNormal
        self.pcCircleView.setShape = self.workingSet
        searchField.text! = ""
        searchField.resignFirstResponder()
        return true
    }

    @IBAction func PC0Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 0, workingSet: self.workingSet)
    }
    
    @IBAction func PC1Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 1, workingSet: self.workingSet)
    }
    @IBAction func PC2Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 2, workingSet: self.workingSet)
        
    }
    @IBAction func PC3Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 3, workingSet: self.workingSet)
        
    }
    @IBAction func PC4Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 4, workingSet: self.workingSet)
        
    }
    @IBAction func PC5Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 5, workingSet: self.workingSet)
        
    }
    @IBAction func PC6Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 6, workingSet: self.workingSet)
        
    }
    @IBAction func PC7Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 7, workingSet: self.workingSet)
        
    }
    @IBAction func PC8Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 8, workingSet: self.workingSet)
        
    }
    @IBAction func PC9Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 9, workingSet: self.workingSet)
        
    }
    @IBAction func PC10Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 10, workingSet: self.workingSet)
        
    }
    @IBAction func PC11Recognizer(_ sender: UITapGestureRecognizer) {
        tapFunction(pc: 11, workingSet: self.workingSet)
        
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        
        let rowArray = searchField.text!.map(String.init)
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
        let newNormal = setViewModel.findNormalForm(pcSet: workingRow)
        
        self.workingSet = newNormal
        self.pcCircleView.setShape = self.workingSet
        searchField.text! = ""
    }
    
    @IBAction func inversionButton(_ sender: UIButton) {
        invert(workingSet: self.workingSet)
    }
    @IBAction func rotateLeft(_ sender: UIButton) {
        rotate(workingSet: self.workingSet, sender: rotateLeftButton)
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        rotate(workingSet: self.workingSet, sender: rotateRightButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchField.delegate = self
        setViewModel = SetViewModel()
        pcCircleView?.setShape = workingSet
        parseJSON("SetClasses")

        
    }
    
    func rotate(workingSet: [Int], sender: UIButton) {
        if sender == rotateRightButton {
            var rotatedSet = [Int]()
            for i in workingSet {
                switch i {
                case 11:
                    rotatedSet.append(0)
                default:
                    rotatedSet.append(i+1)
                }
            }
            self.workingSet = rotatedSet
            self.pcCircleView.setShape = self.workingSet
        } else if sender == rotateLeftButton {
            var rotatedSet = [Int]()
            for i in workingSet {
                switch i {
                case 0:
                    rotatedSet.append(11)
                default:
                    rotatedSet.append(i-1)
                }
            }
            self.workingSet = rotatedSet
            self.pcCircleView.setShape = self.workingSet
        }
    }
    
    func compliment(workingSet: [Int]) {
        let pcList = [0,1,2,3,4,5,6,7,8,9,10,11]
        let compliment = pcList.filter { !workingSet.contains($0) }
        if compliment.count >= 2 {
            let normCompliment = setViewModel.findNormalForm(pcSet: compliment)
            self.workingSet = normCompliment
            self.pcCircleView.setShape = self.workingSet
        }
    }
    
    func invert(workingSet: [Int]) {
        let invertedForm = setViewModel.invertForm(normalizedForm: workingSet)
        let newNormal = setViewModel.findNormalForm(pcSet: invertedForm)
        self.workingSet = newNormal
        self.pcCircleView.setShape = self.workingSet
    }
    
    func tapFunction(pc: Int, workingSet: [Int]) {
        var compSet = workingSet
        if compSet.contains(pc) {
            let newNormal = compSet.filter { return $0 != pc }
            if newNormal.count >= 2 {
                let reduceNormal = setViewModel.findNormalForm(pcSet: newNormal)
                pcCircleView.setShape = reduceNormal
                self.workingSet = reduceNormal
            } else {
                self.workingSet = newNormal
            }
        } else {
            compSet.append(pc)
            if compSet.count >= 2 {
                let newNormal = setViewModel.findNormalForm(pcSet: compSet)
                pcCircleView.setShape = newNormal
                self.workingSet = newNormal
            } else {
                self.workingSet = compSet
            }
        }
    }
    
    
    
    func parseJSON(_ name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            
            let response = try? JSONDecoder().decode(ListSets.self, from: data)
            listOfSets = response
            //            print(listOfSets?.pcSets[0].primeForm)
        } catch {
            debugPrint(error)
        }
    }
    
    func populateText(workingSet: [Int], setIndex: Int) {
        if workingSet.count > 10 {
            let primeForm = setViewModel.findPrimeForm(normalForm: workingSet)
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
            let normalForm = setViewModel.findNormalForm(pcSet: workingSet)
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
            
            setTextField.text! = """
    Normal form: \(normDisplay)
    Prime form: \(primeDisplay)
    """
        } else {
            let forteNumber = listOfSets?.pcSets[setIndex].forteNumber
            let primeForm = listOfSets?.pcSets[setIndex].primeForm
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
            let intervalVector = listOfSets?.pcSets[setIndex].intervalVector
            let normalForm = setViewModel.findNormalForm(pcSet: self.workingSet)
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
            setTextField.text! = """
Normal form: \(normDisplay)
Prime form: \(primeDisplay)
Forte number: \(forteNumber!)
Interval class vector: \(intervalVector!)
"""
        }
    }
    
    
}
