//
//  SetTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import UIKit
import CoreData

class SetTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var savedSet: NSManagedObject!
    
    var axis = ""
    var axisPoints = [[0,6]]
    
    let axisOptions = ["0 - 6","0/1 - 6/7","1 - 7","1/2 - 7/8","2 - 8","2/3 - 8/9","3 - 9","3/4 - 9/10","4 - 10","4/5 - 10/11","5 - 11","5/6 - 11/0"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func setCancelUnwindAction(unwindSegue: UIStoryboardSegue) {}
    
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
        performSegue(withIdentifier: "setToDetail", sender: nil)
    }
    
    // MARK: - Parameters
    
    var networkManager: NetworkManager!
    var setViewModel: SetViewModel!
    
    var normalLabel: String?
    var primeLabel: String?
    var forteLabel: String?
    var intervalLabel: String?
    
    var setIndex: Int?
    
    var normalForm: [Int]?
    var primeForm: [Int]?
    
    var workingSet = [Int]()
    
    var listOfSets: ListSets?
    
    // MARK: - IBOutlets
    
    @IBOutlet var normalFormLabel: UILabel!
    @IBOutlet var primeFormLabel: UILabel!
    @IBOutlet var forteNumberLabel: UILabel!
    @IBOutlet var intervalClassVectorLabel: UILabel!
    
    @IBOutlet var showAxisSwitch: UISwitch!
    @IBOutlet var pcCircleView: PCCircle!
    @IBOutlet var searchField: UITextField!
    @IBOutlet var rotateLeftButton: UIButton!
    @IBOutlet var rotateRightButton: UIButton!
//    @IBOutlet var setTextField: UITextView!
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
        if searchField.text!.contains("0") {
            searchField.text = self.searchField.text!.filter { $0 != "0" }
        } else {
            self.searchField.text! += "0"
        }
        setViewModel.tapFunction(pc: 0, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    
    @IBAction func PC1Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("1") {
            searchField.text = self.searchField.text!.filter { $0 != "1" }
        } else {
            self.searchField.text! += "1"
        }
        setViewModel.tapFunction(pc: 1, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
            
        }
    }
    @IBAction func PC2Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("2") {
            searchField.text = self.searchField.text!.filter { $0 != "2" }
        } else {
            self.searchField.text! += "2"
        }
        setViewModel.tapFunction(pc: 2, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC3Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("3") {
            searchField.text = self.searchField.text!.filter { $0 != "3" }
        } else {
            self.searchField.text! += "3"
        }
        setViewModel.tapFunction(pc: 3, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC4Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("4") {
            searchField.text = self.searchField.text!.filter { $0 != "4" }
        } else {
            self.searchField.text! += "4"
        }
        setViewModel.tapFunction(pc: 4, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC5Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("4") {
            searchField.text = self.searchField.text!.filter { $0 != "4" }
        } else {
            self.searchField.text! += "4"
        }
        setViewModel.tapFunction(pc: 5, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC6Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("6") {
            searchField.text = self.searchField.text!.filter { $0 != "6" }
        } else {
            self.searchField.text! += "6"
        }
        setViewModel.tapFunction(pc: 6, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC7Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("7") {
            searchField.text = self.searchField.text!.filter { $0 != "7" }
        } else {
            self.searchField.text! += "7"
        }
        setViewModel.tapFunction(pc: 7, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC8Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("8") {
            searchField.text = self.searchField.text!.filter { $0 != "8" }
        } else {
            self.searchField.text! += "8"
        }
        setViewModel.tapFunction(pc: 8, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC9Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("9") {
            searchField.text = self.searchField.text!.filter { $0 != "9" }
        } else {
            self.searchField.text! += "9"
        }
        setViewModel.tapFunction(pc: 9, workingSet: self.workingSet)
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
        
    }
    @IBAction func PC10Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("t") {
            searchField.text = self.searchField.text!.filter { $0 != "t" }
        } else {
            self.searchField.text! += "t"
        }
        setViewModel.tapFunction(pc: 10, workingSet: self.workingSet)
        
        setViewModel.workingSet.bind { workingSet in
            self.update(set: workingSet, axisPoints: self.axisPoints)
        }
    }
    @IBAction func PC11Recognizer(_ sender: UITapGestureRecognizer) {
        if searchField.text!.contains("e") {
            searchField.text = self.searchField.text!.filter { $0 != "e" }
        } else {
            self.searchField.text! += "e"
        }
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
//            self.setViewModel.setDescription.bind { text in
//                self.setTextField.text = text
//            }
        }
        title = "Set"
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
//        self.setViewModel.setDescription.bind { text in
//            self.setTextField.text = text
//        }
        self.setViewModel.normalFormLabel.bind { text in
            self.normalFormLabel.text = "\(text)"
        }
        self.setViewModel.primeFormLabel.bind { text in
            self.primeFormLabel.text = "\(text)"
        }
        self.setViewModel.forteLabel.bind { text in
            self.forteNumberLabel.text = "\(text)"
        }
        self.setViewModel.intervalLabel.bind { text in
            self.intervalClassVectorLabel.text = "\(text)"
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setToDetail" {
            let detailVC = segue.destination as! DetailTableViewController
            detailVC.mainTitleText = "Save"
            detailVC.contentLabelText = "Set:"
            detailVC.contentFieldText = makeText(setList: self.workingSet)
            detailVC.pieceField?.placeholder = "Enter name of piece (if applicable)..."
            detailVC.pieceLabelText = "Piece Information:"
            detailVC.notesLabelText = "Additional Notes:"
            detailVC.notesFieldText = ""
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.bounds
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 30
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return 5
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SetTableViewController: UITextFieldDelegate {
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }
    
}
