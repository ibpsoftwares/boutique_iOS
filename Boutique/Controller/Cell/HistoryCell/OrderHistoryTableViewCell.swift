//
//  OrderHistoryTableViewCell.swift
//  Boutique
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

     @IBOutlet weak var orderIDLabel: UILabel!
     @IBOutlet weak var orderDateLabel: UILabel!
     @IBOutlet weak var amountLabel: UILabel!
     @IBOutlet weak var deliveryLabel: UILabel!
     @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
