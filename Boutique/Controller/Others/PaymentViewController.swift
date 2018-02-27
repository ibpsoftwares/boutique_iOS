//
//  PaymentViewController.swift
//  Boutique
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class PaymentViewController: UIViewController,STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var payButtonOutlet: UIButton!
    let paymentTextField = STPPaymentCardTextField()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentTextField.frame = CGRect(x:15, y:199,width:  300, height:44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
       
       // payButtonOutlet.isHidden = true;
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
            payButtonOutlet.isHidden = false;
        
    }

   @IBAction func payButtonAction(sender: AnyObject) {
    
    
        let card = paymentTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print(token)
                self.chargeUsingToken(token: token)
            }
        })
    }
    
    
    
    func chargeUsingToken(token:STPToken){
        let parameters: Parameters = [
            "stripeToken": ("\(token.tokenId)"),
             "amount": "200",
             "currency": "usd",
              "description": "testRun"
        ]
        
        print(parameters)
        let url = "https://thawing-inlet-46474.herokuapp.com/charge.php"
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
            switch response.result {
                
            case .success:
                
                debugPrint(response)
                print(response.request!) // original URL request
                print(response.response!) // URL response
                print(response.data!) // server data
                print(response.result)
               
            case .failure(let error):
               
                print(error)
            }
        }
    }
   
}
