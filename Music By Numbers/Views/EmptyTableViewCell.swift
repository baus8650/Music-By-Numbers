//
//  EmptyTableViewCell.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 5/7/22.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet var emptyCellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
