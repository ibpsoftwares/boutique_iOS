//
//  AddPaymentViewController.swift
//  Boutique
//
//  Created by Apple on 24/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AddPaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var taxPriceLabel: UILabel!
    @IBOutlet weak var shipmentPriceLabel: UILabel!
    @IBOutlet weak var promoPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet weak var cashOnDeliveryButton: UIButton!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var cardExpiryDateLabel: UILabel!
    var totalPrice = String()
     var deliveryCharge = String()
    var userData = NSDictionary()
     @IBOutlet weak var tableView: UITableView!
     var checkCash : Bool = false
     var checkCard : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(Model.sharedInstance.totalPrice)
        itemPriceLabel.text = String(Model.sharedInstance.totalPrice)
        deliveryCharge = (UserDefaults.standard.value(forKey: "deliveryCharges") as! String)
        let result = Int(Model.sharedInstance.totalPrice) + Int(deliveryCharge)!
        print(result)
        shipmentPriceLabel.text = "0.0"
        //taxPriceLabel.text = "0.0"
        //discountLabel.text = "- 0.0"
        totalPriceLabel.text = String("\(Model.sharedInstance.currency)\(result)")
        self.shipmentPriceLabel.text = deliveryCharge
        Model.sharedInstance.totalAmt = totalPriceLabel.text!
         self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "addressCell")
        tableView.tableFooterView = UIView()
        
        print(userData)
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
    
    //MARK: TableView Delegate and Data Source
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell:AddressTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "addressCell") as! AddressTableViewCell!
        
        cell.homeLabel.text = ((userData ).value(forKey: "username") as! String)
        cell.mobileNoLabel.text = ((userData ).value(forKey: "contact1") as! String)
        let addr = ((userData ).value(forKey: "address") as! String)
        let local = ((userData ).value(forKey: "locality") as! String)
         let city = ((userData ).value(forKey: "city") as! String)
        let state = ((userData ).value(forKey: "state") as! String)
        let addressType = ((userData ).value(forKey: "addressType") as! String)
        let adddress = "\(addr) ,\(local) ,\(city) ,\(state)"
        print(adddress)
        cell.addressLabel.text = adddress
        cell.addressType.text = "(\(addressType))"
       cell.editBtn.addTarget(self,action:#selector(edit(sender:)), for: .touchUpInside)
        return cell
    }
    
 @objc func edit(sender:UIButton!){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let abcViewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
    abcViewController.userData = userData
    navigationController?.pushViewController(abcViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }

    @IBAction func completeOrder(_ sender: UIButton) {
        
        if checkCard {
            Model.sharedInstance.paymentType = "card"
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
        else if checkCash {
            Model.sharedInstance.paymentType = "cod"
            self.orderDetailAPI(amount: Model.sharedInstance.totalAmt, userID: Model.sharedInstance.userID, paymentType: Model.sharedInstance.paymentType)
           
        }
        else {
            Alert.showAlertMessage(vc: self, titleStr:"Alert!", messageStr: "Choose Payment Method")
        }
    }
    
    func orderDetailAPI(amount: String,userID: String,paymentType:String){
        
        var myString = amount
        myString.remove(at: myString.startIndex)
     //   print(myString)
        
        let parameters = [
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
            
            print(response!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            self.navigationController?.pushViewController(abcViewController, animated: true)
        }
    }
    
    @IBAction func setCreditCardPaymentMode(_ sender: UIButton) {
        checkCash = false
        checkCard = true
        creditCardButton.setImage(UIImage.init(named: "CheckFilled"), for: .normal)
        cashOnDeliveryButton.setImage(UIImage.init(named: "CheckUnfilled"), for: .normal)
    }
    @IBAction func setCashOnDeliveryPaymentMode(_ sender: UIButton) {
        checkCash = true
        checkCard = false
        cashOnDeliveryButton.setImage(UIImage.init(named: "CheckFilled"), for: .normal)
         creditCardButton.setImage(UIImage.init(named: "CheckUnfilled"), for: .normal)
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
