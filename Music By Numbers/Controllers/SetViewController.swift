//
//  SetViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import UIKit

class SetViewController: UIViewController {

    var normalForm: [Int]?
    var primeForm: [Int]?
    var workingSet = [Int]()
    
    var setViewModel: SetViewModel!
    
    @IBOutlet var searchField: UITextField!
    @IBOutlet var rotateLeftButton: UIButton!
    @IBOutlet var rotateRightButton: UIButton!
    @IBOutlet var pcCircleView: PCCircle!
    @IBAction func complimentButton(_ sender: UIButton) {
        compliment(workingSet: self.workingSet)
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        self.workingSet = [Int]()
        pcCircleView.setShape = self.workingSet
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
        var newNormal = setViewModel.findNormalForm(pcSet: workingRow)
        
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

        setViewModel = SetViewModel()
        pcCircleView?.setShape = workingSet

    }
    
    func rotate(workingSet: [Int], sender: UIButton) {
        if sender == rotateRightButton {
            var rotatedSet = [Int]()
            for i in workingSet {
                switch i {
                case 0:
                    rotatedSet.append(1)
                case 1:
                    rotatedSet.append(2)
                case 2:
                    rotatedSet.append(3)
                case 3:
                    rotatedSet.append(4)
                case 4:
                    rotatedSet.append(5)
                case 5:
                    rotatedSet.append(6)
                case 6:
                    rotatedSet.append(7)
                case 7:
                    rotatedSet.append(8)
                case 8:
                    rotatedSet.append(9)
                case 9:
                    rotatedSet.append(10)
                case 10:
                    rotatedSet.append(11)
                case 11:
                    rotatedSet.append(0)
                default:
                    print("unexpected PC")
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
                case 1:
                    rotatedSet.append(0)
                case 2:
                    rotatedSet.append(1)
                case 3:
                    rotatedSet.append(2)
                case 4:
                    rotatedSet.append(3)
                case 5:
                    rotatedSet.append(4)
                case 6:
                    rotatedSet.append(5)
                case 7:
                    rotatedSet.append(6)
                case 8:
                    rotatedSet.append(7)
                case 9:
                    rotatedSet.append(8)
                case 10:
                    rotatedSet.append(9)
                case 11:
                    rotatedSet.append(10)
                default:
                    print("unexpected PC")
                }
            }
            self.workingSet = rotatedSet
            self.pcCircleView.setShape = self.workingSet
        }
    }

    func compliment(workingSet: [Int]) {
        var pcList = [0,1,2,3,4,5,6,7,8,9,10,11]
        let compliment = pcList.filter { !workingSet.contains($0) }
        self.workingSet = compliment
        self.pcCircleView.setShape = self.workingSet
    }
    
    func invert(workingSet: [Int]) {
        var invertedForm = setViewModel.invertForm(normalizedForm: workingSet)
        var newNormal = setViewModel.findNormalForm(pcSet: invertedForm)
        self.workingSet = newNormal
        self.pcCircleView.setShape = self.workingSet
    }
    
    func tapFunction(pc: Int, workingSet: [Int]) {
        var compSet = workingSet
        if compSet.contains(pc) {
            var newNormal = compSet.filter { return $0 != pc }
            
            var reduceNormal = setViewModel.findNormalForm(pcSet: newNormal)
            pcCircleView.setShape = reduceNormal
            self.workingSet = reduceNormal
        } else {
            compSet.append(pc)
            if compSet.count >= 2 {
                var newNormal = setViewModel.findNormalForm(pcSet: compSet)
                pcCircleView.setShape = newNormal
                self.workingSet = newNormal
            }
        }
    }
    
}
