//
//  ConfirmPasswordViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class ConfirmPasswordViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var oldPassView: UIView!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var oldPassText: UITextField!
    @IBOutlet weak var newPassText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
       
        emailView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        emailView.layer.borderWidth = 0.8
        
        oldPassView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        oldPassView.layer.borderWidth = 0.8
        
        newPassView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        newPassView.layer.borderWidth = 0.8
        
        confirmPassView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        confirmPassView.layer.borderWidth = 0.8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        
         textFieldValidation()
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.emailText.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.oldPassText.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Old Password")
        }
        else if (self.newPassText.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else if (self.confirmPassText.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Confirm Password")
        }
        else{
            if self.newPassText.text == self.confirmPassText.text{
                changePassword()
            }
            else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Password doesn't match!")
            }
        }
    }
    
    //MARK: deleteItemFromCart Methods
    func changePassword() {
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "password" : self.newPassText.text!
        ]
        print(parameters)
        let url = "http://kftsoftwares.com/ecom/recipes/changepassword/ZWNvbW1lcmNl/"
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                debugPrint(response)
                
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
                
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                     Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
                })
                print(error)
            }
        }
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
