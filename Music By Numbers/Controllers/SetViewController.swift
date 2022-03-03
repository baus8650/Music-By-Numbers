//
//  SetViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/23/22.
//

import UIKit
import CoreData
//
class SetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var savedSet: NSManagedObject!
    
    var axis = ""
    var axisPoints = [[0,6]]
    
    let axisOptions = ["0 - 6","0/1 - 6/7","1 - 7","1/2 - 7/8","2 - 8","2/3 - 8/9","3 - 9","3/4 - 9/10","4 - 10","4/5 - 10/11","5 - 11","5/6 - 11/0"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return axisOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return axisOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        axis = axisOptions[row]
        var axes = [[Int]]()
        let separateAxis = axis.components(separatedBy: " - ")
        if separateAxis[0].contains("/") {
            for i in separateAxis {
                let local = i.components(separatedBy: "/")
                let localInt = local.map { Int($0)! }
                axes.append(localInt)
            }
        } else {
            var local = [Int]()
            for i in separateAxis {
                local.append(Int(i)!)
            }
            axes.append(local)
        }
        self.axisPoints = axes
        
        self.update(set: self.workingSet, axisPoints: axes)
        
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let detailVC = DetailViewController()
        detailVC.mainTitleText = "Save"
        detailVC.contentLabelText = "Set:"
        detailVC.contentFieldText = makeText(setList: self.workingSet)
        detailVC.pieceField?.placeholder = "Enter name of piece (if applicable)..."
        detailVC.pieceLabelText = "Piece Information:"
        detailVC.notesLabelText = "Additional Notes:"
        detailVC.notesFieldText = ""
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: - Parameters
    
    var networkManager: NetworkManager!
    var setViewModel: SetViewModel!

    var setIndex: Int?
    
    var normalForm: [Int]?
    var primeForm: [Int]?
    
    var workingSet = [Int]()
    
    var listOfSets: ListSets?
    
    // MARK: - IBOutlets
    
    @IBOutlet var showAxisSwitch: UISwitch!
    @IBOutlet var pcCircleView: PCCircle!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var rotateLeftButton: UIButton!
    @IBOutlet var rotateRightButton: UIButton!
    @IBOutlet var setTextField: UITextView!
    @IBOutlet var axisPicker: UIPickerView!
    
    // MARK: - IBActions
    
    @IBAction func showAxis(_ sender: UISwitch) {
       
            update(set: self.workingSet, axisPoints: self.axisPoints)
        
    }
    
    @IBAction func flipAcrossAxis(_ sender: Any) {
        
        flipOverAxis(set: self.workingSet, axis: self.axisPoints)
    }
    
    @IBAction func complimentButton(_ sender: UIButton) {
        setViewModel.compliment(set: self.workingSet)
        
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        showAxisSwitch.isOn = false
        self.setViewModel.clear()
        self.setViewModel.workingSet.bind { pcSet in
            self.workingSet = pcSet
            self.update(set: pcSet, axisPoints: self.axisPoints)
        }
        
        self.setViewModel.searchField.bind { text in
            self.searchField.text = text
        }
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        setViewModel?.calculate(set: searchField.text!)
        
        setViewModel?.workingSet.bind { [weak self] workingSet in
            self?.update(set: workingSet, axisPoints: self?.axisPoints ?? [[]])
        }
        
        self.setViewModel.searchField.bind { text in
            self.searchField.text = text
        }
        
//        setViewModel.setDescription.bind { [weak self] setText in
//            self?.setTextField.text = setText
//        }
        
    }
    
    @IBAction func inversionButton(_ sender: UIButton) {
        setViewModel.invert(workingSet: self.workingSet)
        
        setViewModel?.workingSet.bind { [weak self] workingSet in
            self?.update(set: workingSet, axisPoints: self?.axisPoints ?? [[]])
        }
    }
    @IBAction func rotateLeft(_ sender: UIButton) {
        setViewModel.rotateLeft(set: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        setViewModel.rotateRight(set: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    // MARK: - Gesture Recognizers

    @IBAction func PC0Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 0, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    @IBAction func PC1Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 1, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
            
        }
    }
    @IBAction func PC2Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 2, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC3Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 3, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC4Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 4, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC5Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 5, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC6Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 6, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC7Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 7, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC8Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 8, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC9Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 9, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC10Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 10, workingSet: self.workingSet)

        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    @IBAction func PC11Recognizer(_ sender: UITapGestureRecognizer) {
        setViewModel.tapFunction(pc: 11, workingSet: self.workingSet)

        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    // MARK: - Lifecyle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel = SetViewModel(set: self.workingSet)
        pcCircleView?.setShape = self.workingSet
        axisPicker.delegate = self
        networkManager = NetworkManager()
        networkManager.parseJSON { sets in
            self.listOfSets = sets
            self.setViewModel.listOfSets.value = sets
            self.setViewModel.populateText(workingSet: self.workingSet)
            self.setViewModel.setDescription.bind { text in
                self.setTextField.text = text
            }
        }
        
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update(set: self.workingSet, axisPoints: [[]])
        showAxisSwitch.isOn = false
    }
    
    // MARK: - Helper Functions
    
    func update(set: [Int], axisPoints: [[Int]]) {
        self.workingSet = set
        self.pcCircleView.setShape = set
        if showAxisSwitch.isOn {
        self.pcCircleView.axisPoints = axisPoints
        } else {
            self.pcCircleView.axisPoints = [[]]
        }
        self.setViewModel.populateText(workingSet: set)
        self.setViewModel.setDescription.bind { text in
            self.setTextField.text = text
        }
    }
    
    func flipOverAxis(set: [Int], axis: [[Int]]) {
        var flippedSet = [Int]()
        var firstHalf = [Int]()
        var secondHalf = [Int]()
        if axis.count == 1 {
            for i in 1...5 {
                firstHalf.append(mod(axis[0][0] + i, 12))
                secondHalf.append(mod(axis[0][1] + i, 12))
            }
            secondHalf.reverse()
        } else if axis.count == 2 {
            for i in 0...5 {
                firstHalf.append(mod(axis[0][1] + i, 12))
                secondHalf.append(mod(axis[1][1] + i, 12))
            }
            secondHalf.reverse()
        }
        
        for i in set {
            if firstHalf.contains(i) {
                let index = firstHalf.firstIndex(of: i)!
                
                flippedSet.append(secondHalf[index])
            } else if secondHalf.contains(i) {
                let index = secondHalf.firstIndex(of: i)!
                
                flippedSet.append(firstHalf[index])
            } else {
                flippedSet.append(i)
            }
        }
        
        
        
        update(set: flippedSet, axisPoints: axis)
        
//        if axis.count == 1 {
            
//            for i in set {
//                if i > axis[0][1] {
//                    flippedSet.append(axis[0][1] - (i - axis[0][1]))
//                } else if i < axis[0][1] {
//                    flippedSet.append(a)
//                }
//            }
//        }
        
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }

    func makeText(setList: [Int]) -> String {
        var normDisplay = "["
        for i in setList {
            if i == 10 {
                normDisplay += "t"
            } else if i == 11 {
                normDisplay += "e"
            } else if i != 10 || i != 11 {
                normDisplay += "\(i)"
            }
        }
        normDisplay += "]"
        return normDisplay
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
