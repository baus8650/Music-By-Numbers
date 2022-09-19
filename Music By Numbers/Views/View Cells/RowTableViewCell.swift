//
//  RowTableViewCell.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 1/31/22.
//

import UIKit

class RowTableViewCell: UITableViewCell {

    var delegate: ClickDelegate?
    var cellIndexRow: Int?
    var cellIndexSection: Int?
    @IBOutlet var rowDate: UILabel!
    
    @IBOutlet var rowLabel: UILabel!
    @IBAction func infoPressed(_ sender: Any) {
        delegate?.clicked(row: cellIndexRow!, section: cellIndexSection!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
