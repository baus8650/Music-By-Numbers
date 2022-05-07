//
//  SettingsTableViewController.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/6/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var colorTarget: Int?
    var picker: UIColorPickerViewController?
    var defaults: UserDefaults?
    
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
        print("matrix cell")
        
        defaults?.set(.blue, forKey: "CircleShapeColor")
        print("circle shape")
        
        defaults?.set(.red, forKey: "AxisLineColor")
        print("axis color")
        
        matrixColorSwatch.backgroundColor = defaults?.color(forKey: "MatrixCellColor") ?? .blue
        shapeColorSwatch.backgroundColor = defaults?.color(forKey: "CircleShapeColor") ?? .red
        axisColorSwatch.backgroundColor = defaults?.color(forKey: "AxisLineColor") ?? .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = UIColorPickerViewController()
        picker?.delegate = self
        defaults = UserDefaults.standard
        matrixColorSwatch.backgroundColor = defaults?.color(forKey: "MatrixCellColor") ?? .blue
        shapeColorSwatch.backgroundColor = defaults?.color(forKey: "CircleShapeColor") ?? .red
        axisColorSwatch.backgroundColor = defaults?.color(forKey: "AxisLineColor") ?? .red
        title = "Settings"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 3
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
