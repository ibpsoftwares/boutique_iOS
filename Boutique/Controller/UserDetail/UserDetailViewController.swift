//
//  UserDetailViewController.swift
//  Boutique
//
//  Created by Apple on 21/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var nameView: UIView!
     @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressView1: UIView!
     @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var zipCodeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var textName: UITextField!
    var countryName = [NSMutableArray]()
    var picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countryView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        countryView.layer.borderWidth = 0.8
       // countryView.layer.cornerRadius = 2
        
        nameView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        nameView.layer.borderWidth = 0.8
        //nameView.layer.cornerRadius = 2
        
        addressView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        addressView.layer.borderWidth = 0.8
        //addressView.layer.cornerRadius = 2
        
        addressView1.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        addressView1.layer.borderWidth = 0.8
        //addressView1.layer.cornerRadius = 2
        
        cityView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cityView.layer.borderWidth = 0.8
        //cityView.layer.cornerRadius = 2
        
        zipCodeView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        zipCodeView.layer.borderWidth = 0.8
        //zipCodeView.layer.cornerRadius = 2
        
        phoneNumberView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        phoneNumberView.layer.borderWidth = 0.8
        //phoneNumberView.layer.cornerRadius = 2
        
        emailView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        emailView.layer.borderWidth = 0.8
       // emailView.layer.cornerRadius = 2
        
        
        picker = UIPickerView(frame: CGRect(x:0, y:0, width:view.frame.width,height: 200))
        picker.backgroundColor = .white
        
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        //self.view.addSubview(picker)
        textName.inputView = picker
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
        textName.inputAccessoryView = toolBar
        
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
        print(self.countryName)
//        let codeForCountryDictionary: [NSObject : AnyObject] = NSDictionary(objects: countryCodes, forKeys: countries as! [NSCopying]) as [NSObject : AnyObject]
//
//        print(codeForCountryDictionary)
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
    @IBAction func btnNext(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
        navigationController?.pushViewController(abcViewController, animated: true)
        
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
        self.textName.text = (((self.countryName as NSArray).object(at: 0) as! NSArray)[row] as! String)
    }
    //MARK:- TextFiled Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         picker.isHidden = false
        self.textName.becomeFirstResponder()
    }
    
    @objc func doneClick() {
        
         self.view.endEditing(true)
    }
    @objc func cancelClick() {
       // picker.isHidden = true
         self.view.endEditing(true)
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
