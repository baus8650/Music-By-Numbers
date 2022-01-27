//
//  SetViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import UIKit

class SetViewController: UIViewController {
    
    // MARK: - Parameters
    
    var networkManager: NetworkManager!
    var setViewModel: SetViewModel!

    var setIndex: Int?
    
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
    
    var listOfSets: ListSets? {
        didSet {
            
            guard let index = listOfSets?.pcSets.firstIndex(where: { $0.primeForm == setViewModel.findPrimeForm(normalForm: workingSet) }) else { return }
            setIndex = index

            populateText(workingSet: workingSet, setIndex: index)
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var pcCircleView: PCCircle!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var rotateLeftButton: UIButton!
    @IBOutlet var rotateRightButton: UIButton!
    @IBOutlet var setTextField: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func complimentButton(_ sender: UIButton) {
        setViewModel.compliment(set: self.workingSet)
        
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    
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
    
    @IBAction func calculateButton(_ sender: UIButton) {
        setViewModel?.calculate(set: searchField.text!)
        
        setViewModel?.searchField.bind { [weak self] search in
            self?.searchField.text = search
        }
        
        setViewModel?.workingSet.bind { [weak self] workingSet in
            self?.update(set: workingSet)
        }
        
    }
    
    @IBAction func inversionButton(_ sender: UIButton) {
        setViewModel.invert(workingSet: self.workingSet)
        
        setViewModel?.workingSet.bind { [weak self] workingSet in
            self?.update(set: workingSet)
        }
    }
    @IBAction func rotateLeft(_ sender: UIButton) {
        setViewModel.rotateLeft(set: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        setViewModel.rotateRight(set: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    
    // MARK: - Gesture Recognizers

    @IBAction func PC0Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 0, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    
    @IBAction func PC1Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 1, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
            
        }
    }
    @IBAction func PC2Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 2, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC3Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 3, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC4Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 4, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC5Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 5, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC6Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 6, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC7Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 7, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC8Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 8, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC9Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 9, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
        
    }
    @IBAction func PC10Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 10, workingSet: self.workingSet)

        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    @IBAction func PC11Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 11, workingSet: self.workingSet)

        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet)
        }
    }
    
    // MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel = SetViewModel(set: workingSet)
        pcCircleView?.setShape = workingSet
        
        networkManager = NetworkManager()
        networkManager.parseJSON { sets in
            self.listOfSets = sets
        }
        
        searchField.delegate = self
    }
    
    // MARK: - Helper Functions
    
    func update(set: [Int]) {
        self.workingSet = set
        self.pcCircleView.setShape = set
        self.setViewModel.populateText(workingSet: set)
        self.setViewModel.setDescription.bind { text in
            self.searchField.text = text
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

extension SetViewController: UITextFieldDelegate {
    
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
}
