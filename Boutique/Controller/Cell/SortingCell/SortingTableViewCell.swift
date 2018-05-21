//
//  SortingTableViewCell.swift
//  Boutique
//
//  Created by Apple on 08/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SortingTableViewCell: UITableViewCell {
@IBOutlet weak var itemNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
