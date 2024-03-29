//
//  SettingsTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import StoreKit
import UIKit

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var colorTarget: Int?
    var picker: UIColorPickerViewController?
    var defaults: UserDefaults?
    var coreDataActions: CoreDataActions?
    
    // MARK: - IBOutlets
    
    @IBOutlet var pitchClassVariable: UISegmentedControl!
    @IBOutlet var matrixColorSwatch: UIView! {
        didSet{
            matrixColorSwatch.layer.borderWidth = 1
        }
    }
    
    @IBOutlet var shapeColorSwatch: UIView! {
        didSet{
            shapeColorSwatch.layer.borderWidth = 1
        }
    }
    
    @IBOutlet var axisColorSwatch: UIView! {
        didSet{
            axisColorSwatch.layer.borderWidth = 1
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func toLibrary(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func pitchClassVariableChanged(_ sender: Any) {
        switch pitchClassVariable.selectedSegmentIndex {
        case 0:
            defaults?.set("t", forKey: "Ten")
            defaults?.set("e", forKey: "Eleven")
        case 1:
            defaults?.set("a", forKey: "Ten")
            defaults?.set("b", forKey: "Eleven")
        default:
            break
        }
    }
    
    @IBAction func matrixCellColorSelect(_ sender: Any) {
        colorTarget = 0
        self.present(picker!, animated: true, completion: nil)
    }
    
    @IBAction func pcCircleShapeSelect(_ sender: Any) {
        colorTarget = 1
        self.present(picker!, animated: true, completion: nil)
    }
    
    @IBAction func pcAxisSelect(_ sender: Any) {
        colorTarget = 2
        self.present(picker!, animated: true, completion: nil)
    }
    
    @IBAction func resetColors(_ sender: Any) {
        defaults?.set(.blue, forKey: "MatrixCellColor")
        defaults?.set(.blue, forKey: "CircleShapeColor")
        defaults?.set(.red, forKey: "AxisLineColor")
        matrixColorSwatch.backgroundColor = defaults?.color(forKey: "MatrixCellColor") ?? .blue
        shapeColorSwatch.backgroundColor = defaults?.color(forKey: "CircleShapeColor") ?? .blue
        axisColorSwatch.backgroundColor = defaults?.color(forKey: "AxisLineColor") ?? .red
    }
    
    @IBAction func clearRows(_ sender: Any) {
        let ac = UIAlertController(title: "Clear Request", message: "Are you sure you want to clear all saved rows? This action cannot be undone.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) -> Void in
            self.coreDataActions?.deleteAllRows()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func clearSets(_ sender: Any) {
        let ac = UIAlertController(title: "Clear Request", message: "Are you sure you want to clear all saved sets? This action cannot be undone.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) -> Void in
            self.coreDataActions?.deleteAllSets()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func clearAll(_ sender: Any) {
        let ac = UIAlertController(title: "Clear Request", message: "Are you sure you want to clear all saved rows and sets? This action cannot be undone.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (action) -> Void in
            self.coreDataActions?.deleteAllEntries()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func leaveReview(_ sender: Any) {
        guard let scene = view.window?.windowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = UIColorPickerViewController()
        picker?.delegate = self
        defaults = UserDefaults.standard
        matrixColorSwatch.backgroundColor = defaults?.color(forKey: "MatrixCellColor") ?? .blue
        shapeColorSwatch.backgroundColor = defaults?.color(forKey: "CircleShapeColor") ?? .blue
        axisColorSwatch.backgroundColor = defaults?.color(forKey: "AxisLineColor") ?? .red
        title = "Settings"
        coreDataActions = CoreDataActions()
    }
    
    // MARK: - Tableview Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 3
        case 3:
            return 1
        default:
            return 0
        }
    }
    
}

extension SettingsTableViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        switch colorTarget {
        case 0:
            defaults?.set(viewController.selectedColor, forKey: "MatrixCellColor")
            matrixColorSwatch.backgroundColor = defaults?.color(forKey: "MatrixCellColor")!
            
        case 1:
            defaults?.set(viewController.selectedColor, forKey: "CircleShapeColor")
            shapeColorSwatch.backgroundColor = defaults!.color(forKey: "CircleShapeColor")
        case 2:
            defaults?.set(viewController.selectedColor, forKey: "AxisLineColor")
            axisColorSwatch.backgroundColor = defaults!.color(forKey: "AxisLineColor")
        default:
            print("Nothing")
        }
        
    }
}

extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
        
    }
    
}


