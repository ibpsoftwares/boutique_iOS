//
//  LoginViewController.swift
//  Boutique
//
//  Created by Apple on 12/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//


// https://gaana.com/artist/arijit-singh
import UIKit
import Alamofire
import SKActivityIndicatorView
import Stripe
class LoginViewController: UIViewController {

    var paymentContext =  STPPaymentContext()
    
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
     @IBOutlet var btnSignUP: UIButton!
    var objectModel = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let rupee = "\u{20AC}"
        print(rupee)
       
        self.navigationController?.navigationBar.isHidden = true
        self.btnSignUP.layer.borderWidth = 1
        self.btnSignUP.layer.cornerRadius = 19
        self.btnSignUP.layer.borderColor = UIColor (red: 43.0/255.0, green: 59.0/255.0, blue: 68.0/255.0, alpha: 1).cgColor
        
       // self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.cornerRadius = 19
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        
        textEmail.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        textPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        textPassword.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //MARK: loginAPI Methods
//    func loginAPI(){
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
//        let parameters: Parameters = [
//            "email": self.textEmail.text!,
//            "password": self.textPassword.text!
//        ]
//
//        print(parameters)
//        let url = "http://kftsoftwares.com/ecom/recipes/login/ZWNvbW1lcmNl/"
//
//        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
//            switch response.result {
//
//            case .success:
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                debugPrint(response)
//
//                if (response.result.value as! NSDictionary).value(forKey: "message") as! String == "Invalid Email or Password "{
//                    self.showAlert(msg: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
//                }
//                else{
//                    self.objectModel.userID = (response.result.value as! NSDictionary).value(forKey: "userid") as! String
//                    print(self.objectModel.userID)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
//                    self.navigationController?.pushViewController(abcViewController, animated: true)
//
//                }
//            case .failure(let error):
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                self.showAlert(msg: "Login Failed.Try Again..")
//                print(error)
//            }
//        }
//    }
//
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textEmail.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.textEmail.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
            
        else{
            loginMethod()
        }
    }
    
    //MARK: loginAPI Methods
    func loginMethod(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "email": self.textEmail.text!,
            "password": self.textPassword.text!
        ]
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/login/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (response?.value(forKey: "message") as! String) == "Invalid Email or Password "{
                 Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                self.objectModel.userID = (response?.value(forKey: "userid") as! String)
                print(self.objectModel.userID)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                self.navigationController?.pushViewController(abcViewController, animated: true)
                
            }
        }
    }
    
    //MARK: Button Actions
    @IBAction func BtnLogin(_ sender: UIButton) {
        textFieldValidation()
    }
    
    @IBAction func btnForgetPass(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Forget Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Enter Email..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func BtnsignUP(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
}
