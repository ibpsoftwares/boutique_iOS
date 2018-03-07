//
//  SignUpViewController.swift
//  Boutique
//
//  Created by Apple on 12/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var bgImg: UIImageView!
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var textUserName: UITextField!
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPasssword: UITextField!
    @IBOutlet var textConPasssword: UITextField!
    var picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
         self.btnSignUp.layer.cornerRadius = 19
//        self.userImg.layer.cornerRadius = self.userImg.frame.size.height / 2
//        self.userImg.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.connected(_:)))
        self.userImg.isUserInteractionEnabled = true
        self.userImg.addGestureRecognizer(tapGestureRecognizer)
        
        textUserName.attributedPlaceholder = NSAttributedString(string: "Enter UserName",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        
        textUserName.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        textEmail.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        textPasssword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        textPasssword.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        textConPasssword.attributedPlaceholder = NSAttributedString(string: "Enter Confirm Password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        textConPasssword.font = UIFont(name: "Montserrat SemiBold", size: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textUserName.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter UserName")
        }
        else if (self.textEmail.text?.isEmpty)! {
            
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.textPasssword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else if (self.textConPasssword.text?.isEmpty)! {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Confirm Password")
        }
        else{
            if self.textPasssword.text == self.textConPasssword.text{
                signupAPI()
            }
            else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Password doesn't match!")
            }
        }
    }
    //MARK: signupAPI Methods
    func signupAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username": self.textUserName.text!,
            "email": self.textEmail.text!,
            "password": self.textPasssword.text!
        ]
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/Signup", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
               self.showAlert(msg: (response?.value(forKey: "message") as! String))
            }
        }
    }
    
//    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
            self.navigationController?.pushViewController(abcViewController, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: Button Actions
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backHaveAcc(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnsignUP(_ sender: UIButton) {
        
        textFieldValidation()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
//        navigationController?.pushViewController(abcViewController, animated: true)
    }
    
    @objc func connected(_ sender:AnyObject){
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.userImg.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.bgImg.image = UIImage (named: "")
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
