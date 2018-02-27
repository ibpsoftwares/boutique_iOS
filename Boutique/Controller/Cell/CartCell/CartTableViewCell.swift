//
//  CartTableViewCell.swift
//  Boutique
//
//  Created by Apple on 16/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

     @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
     @IBOutlet weak var priceLabel: UILabel!
     @IBOutlet weak var sizeLabel: UILabel!
     @IBOutlet weak var size1Label: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var countStepper: UIStepper!
    @IBOutlet weak var qtyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
