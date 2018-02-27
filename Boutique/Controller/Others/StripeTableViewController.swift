//
//  StripeTableViewController.swift
//  Boutique
//
//  Created by Apple on 22/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class StripeTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let cardParams = STPCardParams()
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func donate(sender: AnyObject) {
        // Initiate the card
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2018
        cardParams.cvc = "123"
        
        STPAPIClient.shared().createToken(withCard: cardParams, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print(token)
                self.postStripeToken(token: token)
            }
        })
    }
    func postStripeToken(token:STPToken){
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
