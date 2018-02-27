//
//  SettingTableViewCell.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
