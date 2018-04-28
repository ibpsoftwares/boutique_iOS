//
//  StripePaymentViewController.swift
//  Boutique
//
//  Created by Apple on 22/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import SKActivityIndicatorView

class StripePaymentViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var expireDateView: UIView!
    @IBOutlet weak var cvcView: UIView!
    @IBOutlet weak var amountView: UIView!
    
    let cardParams = STPCardParams()
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
        emailView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        emailView.layer.borderWidth = 0.8
        
        cardNumberView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cardNumberView.layer.borderWidth = 0.8
        
        expireDateView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        expireDateView.layer.borderWidth = 0.8
        
        cvcView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cvcView.layer.borderWidth = 0.8
        
        amountView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        amountView.layer.borderWidth = 0.8
        self.tabBarController?.tabBar.isHidden = true
        
        self.amountTextField.text = "\(String(Model.sharedInstance.totalPrice))"
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
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    @IBAction func next(sender: AnyObject) {
        // Initiate the card
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2018
        cardParams.cvc = "200"
        
        STPAPIClient.shared().createToken(withCard: cardParams, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print(token)
                
              //  self.showAlert(msg: "Token created: \(token)")
             
                self.postStripeToken(token: token)
            }
        })
    }
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Welcome to Stripe", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            self.navigationController?.pushViewController(abcViewController, animated: true)
            self.present(alert, animated: true, completion: nil)
    }
    
    func postStripeToken(token:STPToken){
        let parameters: Parameters = [
            "token": ("\(token.tokenId)"),
            "amount": "200",
//            "currency": "usd",
//            "description": "testRun"
        ]
        print(parameters)
         let headers = ["Authorization":"Bearer ZWNvbW1lcmNl"]
        //let url = "https://thawing-inlet-46474.herokuapp.com/charge.php"
        let url = "http://kftsoftwares.com/ecomm/recipes/payment/"
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl: "payment/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (((response?.value(forKey: "customer_array") as! NSDictionary).value(forKey: "status") as! String)  == "succeeded"){
                
                self.orderDetailAPI(amount: Model.sharedInstance.totalAmt, userID: Model.sharedInstance.userID, paymentType: Model.sharedInstance.paymentType)
            }
            else{
                if (response?.value(forKey: "customer_array")  != nil){
                    
                    }else{
                        
                    }
                }
            }
        }
        
    func orderDetailAPI(amount: String,userID: String,paymentType:String){
        
        var myString = amount
        myString.remove(at: myString.startIndex)
        print(myString)
        let parameters: Parameters = [
            "user_id": userID,
            "amount": myString,
             "paymentType": paymentType,
        ]
        print(parameters)
        Webservice.apiPost(apiURl: "orderDetail/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            self.navigationController?.pushViewController(abcViewController, animated: true)
            }
        }
    }
        
        
//        Alamofire.request(url, method:.post, parameters:parameters, headers:headers).responseJSON { response in
//            switch response.result {
//
//            case .success:
//
//                debugPrint(response)
//                print(response.request!) // original URL request
//                print(response.response!) // URL response
//                print(response.data!) // server data
//                print(response.result)
////                if (((((response.value(forKey: "customer_array")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "address") as! String) == ""{
////
////                }
//
//            case .failure(let error):
//
//                print(error)
//            }
//        }
    


