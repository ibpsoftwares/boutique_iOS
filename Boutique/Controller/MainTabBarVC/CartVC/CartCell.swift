//
//  CartCell.swift
//  SpreeiOS
//
//  Created by Bharat Gupta on 07/06/16.
//  Copyright © 2016 Vinsol. All rights reserved.
//

import UIKit

protocol CartCellDelegate {
    func removeLineItem(id: Int)
    func changeQtyOfLineItem(id: Int, to qty: Int)
}

class CartCell: UITableViewCell {

    let minQty = 1
    let maxQty = 20

    var currentQty = 1

    var delegate: CartCellDelegate?
   
    var downloadTask: URLSessionDownloadTask?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var incrementQty: UIButton!
    @IBOutlet weak var decrementQty: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var qty: UILabel!
  
    @IBOutlet weak var itemQuantityStepper:UIStepper?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var quantity:Int {
        get {
            if (self.itemQuantityStepper != nil) {
                return Int(self.itemQuantityStepper!.value)
            }
            
            return 0
        }
        
        set {
            self.setItemQuantity(quantity)
        }
        
    }
    
//    @IBAction func stepperValueChanged(_ sender: AnyObject){
//        let value = Int(itemQuantityStepper!.value)
//        setItemQuantity(value)
//        
//    }
    
    func setItemQuantity(_ quantity: Int) {
        let itemQuantityText = "\(quantity)"
        qtyLabel?.text = itemQuantityText
       
     
//        let myString = priceLabel.text!
//        let price = Int(myString)
//         print(price!)
//        priceLabel.text = "\(((quantity) * price!))"
        
        itemQuantityStepper?.value = Double(quantity)
        
        // Notify delegate, if there is one, too...
        //        if (delegate != nil) {
        //            delegate?.cartTableViewCellSetQuantity(self, quantity: quantity)
        //        }
        
    }
}
