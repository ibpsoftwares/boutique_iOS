//
//  ProfileViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    var picker = UIImagePickerController()
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var genderView: UIView!
    var arrayGender = [String]()
     @IBOutlet weak var textName: UITextField!
     @IBOutlet weak var textEmail: UITextField!
     @IBOutlet weak var textPhoneNumber: UITextField!
     @IBOutlet weak var textDOB: UITextField!
     @IBOutlet weak var textGender: UITextField!
    var pickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        arrayGender = ["Male","Female"]
        
        profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
        profileImg.clipsToBounds = true
        profileImg.layer.borderColor = UIColor (red: 20.0/255.0, green: 99.0/255.0, blue: 130.0/255.0, alpha: 1).cgColor
        profileImg.layer.borderWidth = 2
        
        emailView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        emailView.layer.borderWidth = 0.8
        
        userNameView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        userNameView.layer.borderWidth = 0.8
        
        phoneView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        phoneView.layer.borderWidth = 0.8
        
        dobView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        dobView.layer.borderWidth = 0.8
        
        genderView.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        genderView.layer.borderWidth = 0.8
        
      
        pickerView = UIPickerView(frame: CGRect(x:0, y:0, width:view.frame.width,height: 200))
        pickerView.backgroundColor = .white
        
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        //self.view.addSubview(picker)
        textGender.inputView = pickerView
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
        textGender.inputAccessoryView = toolBar
        
        if Model.sharedInstance.userID != ""{
             setProfile()
        }
    }
    func setProfile(){
        
        self.textEmail.text = (Model.sharedInstance.loginData.value(forKey: "email") as! String)
        self.textName.text = (Model.sharedInstance.loginData.value(forKey: "userName") as! String)
           // profileImg.image = Model.sharedInstance.loginData.value(forKey: "image") as! String
        self.textPhoneNumber.text = (Model.sharedInstance.loginData.value(forKey: "contact") as! String)
        self.textDOB.text = (Model.sharedInstance.loginData.value(forKey: "dob") as! String)
        self.textGender.text = (Model.sharedInstance.loginData.value(forKey: "gender") as! String)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPhotoSelect(_ sender: UIButton) {
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
        self.profileImg.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - Pickerview method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.textGender.text = arrayGender[row]
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textGender {
            pickerView.isHidden = false
            self.textGender.becomeFirstResponder()
        }
        else if textField == textDOB {
            self.textDOB.becomeFirstResponder()
           let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            self.textDOB.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        }
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
         self.textDOB.text = dateFormatter.string(from: sender.date)
    }
    @objc func doneClick() {
        
        self.view.endEditing(true)
    }
    @objc func cancelClick() {
        // picker.isHidden = true
        self.view.endEditing(true)
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        
        test()
       // upload(username: textName.text!, email: textEmail.text!, contact: textPhoneNumber.text!, dob: self.textDOB.text!, gender: textGender.text!)
    }
    
    
    func test(){
        
        let params = [
            "email": (Model.sharedInstance.loginData.value(forKey: "email") as! String),
            "contact": textPhoneNumber.text!,
            "id": (Model.sharedInstance.loginData.value(forKey: "userid") as! String),
            "dob": textDOB.text!,
            "userdetail_id": (Model.sharedInstance.loginData.value(forKey: "userdetail_id") as! String),
            "username": (Model.sharedInstance.loginData.value(forKey: "userName") as! String),
            "gender": textGender.text!
        ]
        print(params)
        let header = ["Authorization":"Bearer ZWNvbW1lcmNl"]
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            
            for (key, value) in params {
                multipartFormData.append((value ).data(using: .utf8)!, withName: key)
            }
            
            DispatchQueue.main.async {
                if  let imageData = UIImageJPEGRepresentation(self.profileImg.image!, 0.2) {
                    multipartFormData.append(imageData, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
                }
            }
           
        },
                         usingThreshold:UInt64.init(),
                         to:"http://kftsoftwares.com/ecomm/recipes/updateProfile",
                         method:.post,
                         headers:header,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseString(completionHandler: { response in
                                    print("success", response.result.value!)
                                })
                            case .failure(let encodingError):
                                print("en eroor :", encodingError)
                            }
        })
        
    }
}
