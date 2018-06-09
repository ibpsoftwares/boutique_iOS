//
//  UserDetailViewController.swift
//  Boutique
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

@available(iOS 10.0, *)
class UserDetailViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var nameView: UIView!
     @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var localityView: UIView!
     @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var commercialButton: UIButton!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textZipCode: UITextField!
    @IBOutlet weak var textMobile: UITextField!
    @IBOutlet weak var textLocality: UITextField!
    @IBOutlet weak var textState: UITextField!
    var countryName = [NSMutableArray]()
    var picker = UIPickerView()
    @IBOutlet weak var btnSaturday: UIButton!
    @IBOutlet weak var btnSunday: UIButton!
     @IBOutlet weak var checkSatImgView: UIImageView!
     @IBOutlet weak var checkSanImgView: UIImageView!
    var userData = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        countryView.layer.borderWidth = 0.8
       // countryView.layer.cornerRadius = 2
        
        btnSaturday.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        btnSaturday.layer.borderWidth = 0.8
        
        btnSunday.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        btnSunday.layer.borderWidth = 0.8
        
        nameView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        nameView.layer.borderWidth = 0.8
        
        addressTextView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        addressTextView.layer.borderWidth = 0.8
     
        cityView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cityView.layer.borderWidth = 0.8
        
        zipCodeView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        zipCodeView.layer.borderWidth = 0.8
        
        phoneNumberView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        phoneNumberView.layer.borderWidth = 0.8
     
        localityView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        localityView.layer.borderWidth = 0.8
        
        stateView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        stateView.layer.borderWidth = 0.8
        
        picker = UIPickerView(frame: CGRect(x:0, y:0, width:view.frame.width,height: 220))
        picker.backgroundColor = .gray
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        //self.view.addSubview(picker)
        textCountry.inputView = picker
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textCountry.inputAccessoryView = toolBar
        
        picker.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        let countryCodes: [AnyObject] = NSLocale.isoCountryCodes as [AnyObject]
        
        let countries: NSMutableArray = NSMutableArray(capacity: countryCodes.count)
        
        for countryCode in countryCodes {
            let identifier: String = NSLocale.localeIdentifier(fromComponents: NSDictionary(object: countryCode, forKey: NSLocale.Key.countryCode as NSCopying) as! [String : String])
            let country: String = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            countries.add(country)
            
        }
        self.countryName.append(countries)
        //print(self.countryName)
//        let codeForCountryDictionary: [NSObject : AnyObject] = NSDictionary(objects: countryCodes, forKeys: countries as! [NSCopying]) as [NSObject : AnyObject]
//
//        print(codeForCountryDictionary)
        print(userData)
        
       
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func setHometMode(_ sender: UIButton) {
        
        homeButton.setImage(UIImage.init(named: "fillImg"), for: .normal)
        commercialButton.setImage(UIImage.init(named: "emptyImg"), for: .normal)
    }
    @IBAction func setCommercialMode(_ sender: UIButton) {
        commercialButton.setImage(UIImage.init(named: "fillImg"), for: .normal)
        homeButton.setImage(UIImage.init(named: "emptyImg"), for: .normal)
    }
    @IBAction func setSaturdayMode(_ sender: UIButton) {
        sender.backgroundColor = UIColor.white
        checkSatImgView.image = UIImage(named: "check")
        checkSanImgView.image = UIImage(named: "")
    }
    @IBAction func setSundayMode(_ sender: UIButton) {
         sender.backgroundColor = UIColor.white
        checkSanImgView.image = UIImage(named: "check")
        checkSatImgView.image = UIImage(named: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if ( userData.count > 0){
            self.textCountry.text = ((userData as NSDictionary).value(forKey: "country") as! String)
            self.textName.text = ((userData as NSDictionary).value(forKey: "username") as! String)
            self.textCity.text = ((userData as NSDictionary).value(forKey: "city") as! String)
            self.textState.text = ((userData as NSDictionary).value(forKey: "state") as! String)
            self.textZipCode.text = ((userData as NSDictionary).value(forKey: "zip_code") as! String)
            self.addressTextView.text = ((userData as NSDictionary).value(forKey: "address") as! String)
            self.textLocality.text = ((userData as NSDictionary).value(forKey: "locality") as! String)
            self.textMobile.text = ((userData as NSDictionary).value(forKey: "contact1") as! String)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: UIButton) {
        
        userDetailsAPI()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let abcViewController = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
//        navigationController?.pushViewController(abcViewController, animated: true)
        
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ((self.countryName as NSArray).object(at: 0) as! NSArray).count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (((self.countryName as NSArray).object(at: 0) as! NSArray)[row] as! String)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textCountry.text = (((self.countryName as NSArray).object(at: 0) as! NSArray)[row] as! String)
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
         picker.isHidden = false
        self.textCountry.becomeFirstResponder()
    }
    
    @objc func doneClick() {
        
         self.view.endEditing(true)
    }
    @objc func cancelClick() {
       // picker.isHidden = true
         self.view.endEditing(true)
    }
    
    //MARK: userDetails Methods
    func userDetailsAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "address": self.addressTextView.text!,
            "city": self.textCity.text!,
            "country" : textCountry.text!,
            "state" : textState.text!,
            "userdetail_id": (Model.sharedInstance.loginData.value(forKey: "userdetail_id") as! String),
            "availability": "saturday"+","+"sunday",
            "zip_code" : textZipCode.text!,
            "user_id" :Model.sharedInstance.userID,
            "contact" : textMobile.text!,
            "username" : textName.text!,
            "locality" : textLocality.text!,
            "addressType" : "Home"
        ]
        print(parameters)
        Webservice.apiPost(apiURl: "shippingDetail/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
            abcViewController.userData = ((((response?.value(forKey: "shippingDetails")) as! NSArray).object(at: 0)) as! NSDictionary)
            self.navigationController?.pushViewController(abcViewController, animated: true)
            if (response?.value(forKey: "message") as! String) == "Invalid Email or Password "{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                
            }
        }
    }
    

}
