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
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardExpiryDateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func completeOrder(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }

    @IBAction func setCreditCardPaymentMode(_ sender: UIButton) {
       
    }
    @IBAction func setCashOnDeliveryPaymentMode(_ sender: UIButton) {
        
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
