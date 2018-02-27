//
//  PriceTableViewCell.swift
//  Boutique
//
//  Created by Apple on 23/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

     @IBOutlet weak var rangeALabel: UILabel!
     @IBOutlet weak var rangeBLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
