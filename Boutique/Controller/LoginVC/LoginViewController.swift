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
import CoreData

@available(iOS 10.0, *)
class LoginViewController: UIViewController {

    var paymentContext =  STPPaymentContext()
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
     @IBOutlet var btnSignUP: UIButton!
     @IBOutlet var lbl1: UILabel!
     @IBOutlet var lbl2: UILabel!
    var wishlistArr = String()
     var cartArr = [NSDictionary]()
   
    var wishlist: [NSManagedObject] = []
    var cartlist: [NSManagedObject] = []
    var cart = NSMutableArray()
    var size = [getPrice]()
     var myArray = NSMutableArray()
    var objectModel = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.navigationController?.navigationBar.isHidden = true
        self.btnSignUP.layer.borderWidth = 1
        self.btnSignUP.layer.cornerRadius = 19
        self.btnSignUP.layer.borderColor = UIColor (red: 43.0/255.0, green: 59.0/255.0, blue: 68.0/255.0, alpha: 1).cgColor
        
        self.btnLogin.layer.cornerRadius = 19
        
         self.lbl1.layer.cornerRadius = 5
         self.lbl2.layer.cornerRadius = 5
        
        textEmail.attributedPlaceholder = NSAttributedString(string: "Enter Email",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        
        textEmail.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        textPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor (red: 102.0/255.0, green:  102.0/255.0, blue:  102.0/255.0, alpha: 1)])
        textPassword.font = UIFont(name: "Montserrat SemiBold", size: 20)
        
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        print(uuid!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.cartArr.removeAll()
        self.wishlistArr.removeAll()
        wishlist.removeAll()
        cartlist.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            wishlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if wishlist.count > 0{
            for row in 0...wishlist.count - 1{
                let person = wishlist[row]
                let cartID = (person.value(forKeyPath: "id") as! String)
                print(cartID)
                wishlistArr.append(cartID + ",")
            }
        }
//        var str = wishlistArr
//        str.removeLast()
//        wishlistArr = str
        
        let Context = appDelegate.persistentContainer.viewContext
        
        let Request = NSFetchRequest<NSManagedObject>(entityName: "Cartlist")
        do {
            cartlist = try Context.fetch(Request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if cartlist.count > 0{
            for row in 0...cartlist.count - 1{
                let person = cartlist[row]
                
                //self.size.append(getPrice.init(id: (person.value(forKeyPath: "id") as! String), range_a: "1", range_b: "2"))
               
               let cartID = (person.value(forKeyPath: "id") as! String)
               print(cartID)
                
//                cartArr.append(cartID + ",")
                
                let jsonObject: NSMutableDictionary = NSMutableDictionary()
                jsonObject.setValue(cartID, forKey: "cloth_id")
                jsonObject.setValue("2", forKey: "size_id")
                
                myArray.add(jsonObject)
                
        }
        }
     print("\(myArray)")
        
        
//        var str1 = cartArr
//        str1.removeLast()
//        cartArr = str1
    }

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
    //MARK: Button Actions
    @IBAction func BtnLogin(_ sender: UIButton) {
        textFieldValidation()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: loginAPI Methods
    func loginMethod(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "email": self.textEmail.text!,
            "password": self.textPassword.text!
        ]
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecomm/recipes/login", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
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
                for item in (response!.value(forKey: "user") as! NSArray) {
                    print(item)
                    
                    if (item as! NSDictionary).value(forKey: "userid")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "userid")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "userid") as! String), forKey: "userid")
                    }
                    if (item as! NSDictionary).value(forKey: "userdetail_id")  is NSNull{
                       Model.sharedInstance.loginData.setValue("", forKey: "userdetail_id")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "userdetail_id") as! String), forKey: "userdetail_id")
                    }
                    if (item as! NSDictionary).value(forKey: "email")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "email")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "email") as! String), forKey: "email")
                    }
                    if (item as! NSDictionary).value(forKey: "contact")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "contact")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "contact") as! String), forKey: "contact")
                    }
                    if (item as! NSDictionary).value(forKey: "userName")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "userName")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "username") as! String), forKey: "userName")
                    }
                    if (item as! NSDictionary).value(forKey: "image")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "image")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "image") as! String), forKey: "image")
                    }
                    if (item as! NSDictionary).value(forKey: "dob")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "dob")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "dob") as! String), forKey: "dob")
                    }
                    if (item as! NSDictionary).value(forKey: "gender")  is NSNull{
                        Model.sharedInstance.loginData.setValue("", forKey: "gender")
                    }else{
                        Model.sharedInstance.loginData.setValue(((item as? NSDictionary)?.value(forKey: "gender") as! String), forKey: "gender")
                    }
                    
                    print(Model.sharedInstance.loginData)
                    self.objectModel.userID = ((item as! NSDictionary).value(forKey: "userid") as! String)
                    print(self.objectModel.userID)
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                self.navigationController?.pushViewController(abcViewController, animated: true)
              //  self.wishlistAndCart()
//                UserDefaults.standard.set("loginIn", forKey: "loggedIn")
//                UserDefaults.standard.synchronize()
//
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
//                self.navigationController?.pushViewController(abcViewController, animated: true)
                
            }
        }
    }
    
    
    //MARK: wishlistAndCart API Methods
    func wishlistAndCart(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
//        let parameters: [String: Any] = [
//            "user_id": Model.sharedInstance.userID,
//            "cart_id": cartArr ,
//             "wishlist_id": wishlistArr
//        ]
        let parameters: Parameters = [
            "cart": myArray,
            "user_id": "42"
        ]
        print(parameters)
    
//        let headers = ["Authorization":"Bearer ZWNvbW1lcmNl"]
//        Alamofire.request("http://kftsoftwares.com/ecom/recipes/sendmewishlistdatafortesting", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseString
//            { response in
//
//                print(response.result.value!)
//        }
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/sendmewishlistdatafortesting/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
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
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                self.navigationController?.pushViewController(abcViewController, animated: true)
               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
    }
    @IBAction func btnForgetPass(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Forget Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Enter Email..."
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            self.forgetPassAPI(email: textField.text!)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK: ForgetPassword API Method
    func forgetPassAPI(email: String){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "email": email,
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecomm/recipes/forgetpwd", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (response?.value(forKey: "message") as! String) == "Enter a valid mail"{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
    }
    
    @IBAction func BtnsignUP(_ sender: UIButton) {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
}
