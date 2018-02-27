//
//  ViewController.swift
//  Boutique
//
//  Created by Apple on 12/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    var paymentTextField: STPPaymentCardTextField! = nil
    var submitButton: UIButton! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        paymentTextField = STPPaymentCardTextField(frame: CGRect(x: 15, y: 30, width: view.frame.width - 30, height: 44))
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x: 15, y: 100, width: 100, height: 44)
        submitButton.isEnabled = false
        submitButton.setTitle("Submit", for: [])
        submitButton.addTarget(self, action: #selector(self.submitCard(_:)), for: .touchUpInside)
        view.addSubview(submitButton)

    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        submitButton.isEnabled = textField.isValid
    }
    
    @IBAction func submitCard(_ sender: AnyObject?) {
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
        let cardParams = paymentTextField.cardParams
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

