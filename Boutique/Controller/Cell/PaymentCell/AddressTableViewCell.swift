//
//  AddressTableViewCell.swift
//  Boutique
//
//  Created by Apple on 24/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
