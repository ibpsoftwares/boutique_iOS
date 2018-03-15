//
//  AddPaymentViewController.swift
//  Boutique
//
//  Created by Apple on 24/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AddPaymentViewController: UIViewController {

    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var shipmentPriceLabel: UILabel!
    @IBOutlet weak var promoPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var cashOnDeliveryButton: UIButton!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var cardExpiryDateLabel: UILabel!
    
     var checkCash : Bool = false
     var checkCard : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(Model.sharedInstance.totalPrice)
        itemPriceLabel.text = String(Model.sharedInstance.totalPrice)
        shipmentPriceLabel.text = "0.0"
        taxPriceLabel.text = "0.0"
        discountLabel.text = "- 0.0"
        totalPriceLabel.text = String("$\(Model.sharedInstance.totalPrice)")
         self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @IBAction func completeOrder(_ sender: UIButton) {
        
        if checkCard {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
        else if checkCash {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
        else {
            Alert.showAlertMessage(vc: self, titleStr:"Alert!", messageStr: "Choose Payment Method")
        }
    }

    @IBAction func setCreditCardPaymentMode(_ sender: UIButton) {
        checkCash = false
        checkCard = true
        creditCardButton.setImage(UIImage.init(named: "CheckFilled"), for: .normal)
        cashOnDeliveryButton.setImage(UIImage.init(named: "CheckUnfilled"), for: .normal)
    }
    @IBAction func setCashOnDeliveryPaymentMode(_ sender: UIButton) {
        checkCash = true
        checkCard = false
        cashOnDeliveryButton.setImage(UIImage.init(named: "CheckFilled"), for: .normal)
         creditCardButton.setImage(UIImage.init(named: "CheckUnfilled"), for: .normal)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
