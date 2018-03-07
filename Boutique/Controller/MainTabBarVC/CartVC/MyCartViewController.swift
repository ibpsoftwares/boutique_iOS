//
//  MyCartViewController.swift
//  Boutique
//
//  Created by Apple on 24/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

//
//  CartViewController.swift
//  SpreeiOS
//
//  Created by Bharat Gupta on 07/06/16.
//  Copyright © 2016 Vinsol. All rights reserved.
//

import UIKit
import Kingfisher
import SKActivityIndicatorView
import Alamofire

class MyCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum STATE {
        case Loading
        case Empty
        case Filled
    }
    var isLoading = true
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutView: UIView!
    
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    var count = Int()
    var cartProduct = [getProductDetail]()
    var totalPrice = Int()
     var currentQty = 1
    let minQty = 1
    let maxQty = 20
    var check : Bool = false
    var lblCount = String()
    var lblprice = String()
    var selectIndex = NSInteger()
    override func viewDidLoad() {
        super.viewDidLoad()
        count = 1
        checkoutView.isHidden = false
        tableView.tableFooterView = UIView()
        checkoutButton.layer.borderWidth = 0.5
       // checkoutButton.layer.borderColor = UIColor.secondary.cgColor
        getCartViewAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fetchCartDetails()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: getCartViewAPI Methods
    func getCartViewAPI(){
        
        self.totalPrice = 0
        self.cartProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                
                if ((response!.value(forKey: "items") != nil) ){
                    
                    for item in ((response)?.value(forKey: "items") as! NSArray) {
                        print(item)
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1"))
                    }
                    let defaults = UserDefaults.standard
                    defaults.set(self.cartProduct.count, forKey: "totalCartItem")
                    defaults .synchronize()
                    Model.sharedInstance.cartCount = self.cartProduct.count
                    for var i in (0..<(self.cartProduct.count)){
                        let total = (Int)(self.cartProduct[i].price)!
                        print(total)
                        self.totalPrice += total
                        self.totalPriceLabel.text = String("$\(self.totalPrice)")
                    }
                    DispatchQueue.main.async(execute: {
                        self.itemsCountLabel.text =  "Total (\(self.cartProduct.count))"
                        self.tableView.reloadData()
                    })
                }
                else {
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "totalCartItem")
                    defaults.synchronize()
                     self.tableView.reloadData()
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let url = URL(string: self.cartProduct[indexPath.row].image)
        cell.thumbImageView.kf.setImage(with: url,placeholder: nil)
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.height / 2
        cell.thumbImageView.clipsToBounds = true
        
        cell.nameLabel.text = cartProduct[indexPath.row].name
        cell.priceLabel.text = "\(cartProduct[indexPath.row].price)"
        
        cell.removeButton.tag = indexPath.row
         cell.removeButton.addTarget(self,action:#selector(remove(sender:)), for: .touchUpInside)
        cell.itemQuantityStepper?.tag = indexPath.row
        cell.itemQuantityStepper?.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        
        cell.incrementQty.addTarget(self,action:#selector(addBtn(sender:)), for: .touchUpInside)
        cell.incrementQty.tag = indexPath.row
        
        cell.decrementQty.addTarget(self,action:#selector(subBtn(sender:)), for: .touchUpInside)
        cell.decrementQty?.tag = indexPath.row
        return cell
    }
    
    
    @objc func addBtn(sender: AnyObject) -> Int {
        
        let indexPath = IndexPath(item: sender.tag, section: 0) // This defines what indexPath is which is used later to define a cell
        let cell = tableView.cellForRow(at: indexPath) as! CartCell! // This is where the magic happens - reference to the cell
        
        count = Int((cell?.qty.text)!)!
        print(count)
        
        count = 1 + count
        print(count)
        
        let myDouble = Double(self.cartProduct[sender.tag].price)
        print(myDouble!)
        totalPrice -= Int(myDouble!)
        print(totalPrice)
        let qyt = Double(count)
        let total = myDouble! * qyt
        print(total)
        lblprice = String(format: "%.0f", total)
        cell?.priceLabel.text = String(format: "%.0f", total)
        cell?.qty.text = "\(count)" // Once you have the reference to the cell, just use the traditional way of setting up the objects inside the cell.
        
        print(totalPrice)
        self.totalPrice += Int(total)
        self.totalPriceLabel.text = String("$\(self.totalPrice)")
        
        return count
    }
    
   @objc func subBtn(sender: AnyObject) -> Int {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! CartCell!
        
        if count == 1 {
            print("Count zero")
            count = 1
            let myDouble = Double(self.cartProduct[sender.tag].price)
            print(myDouble!)
            let qyt = Double(count)
            let total = myDouble! * qyt
            print(total)
            lblprice = String(format: "%.0f", total)
            cell?.priceLabel.text = String(format: "%.0f", total)
            cell?.qty.text = "\(count)"
            print(count)

//            print(totalPrice)
//            self.totalPrice = Int(total)
            self.totalPriceLabel.text = String("$\(self.totalPrice)")
        } else {
            count = count - 1
            let myDouble = Double(self.cartProduct[sender.tag].price)
            print(myDouble!)
            let qyt = Double(count)
            let total = myDouble! * qyt
            print(total)
            lblprice = String(format: "%.0f", total)
            cell?.priceLabel.text = String(format: "%.0f", total)
            cell?.qty.text = "\(count)"
            print(count)
            
            print(totalPrice)
            self.totalPrice -= Int(total)
            self.totalPriceLabel.text = String("$\(self.totalPrice)")
        }
   
        return count
    }
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        
        
        print(stepper.tag)
         print("You tapped cell number \(stepper.value).")
        
        check = true
        
        lblCount = String(format: "%.0f", stepper.value)
        print(lblCount)
       
        
        let myDouble = Double(self.cartProduct[stepper.tag].price)
        print(myDouble!)
        
        let total = myDouble! * stepper.value
        print(total)
        lblprice = String(format: "%.0f", total)
//        tableView.reloadData()
        let indexPath = IndexPath(item: stepper.tag, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .none)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailVC.productID = self.cartProduct[indexPath.row].id
        navigationController?.pushViewController(productDetailVC, animated: true)
        
    }
    @objc func remove(sender:UIButton!) {
        self.deleteItemFromCart(cartID: self.cartProduct[sender.tag].id)
    }
    //MARK: deleteItemFromCart Methods
    func deleteItemFromCart( cartID : String) {
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": cartID
            ]
        print(parameters)
        let url = "http://kftsoftwares.com/ecom/recipes/rmcart/ZWNvbW1lcmNl/"
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                debugPrint(response)
                
//                DispatchQueue.main.async(execute: {
//                    self.tableView.reloadData()
//                })
                self.showAlert(msg: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
                
                //self.showAlert(msg: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
                
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                print(error)
            }
        }
    }
    
    @IBAction func checkout(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.getCartViewAPI()
//        DispatchQueue.main.async(execute: {
//            self.getCartViewAPI()
//        })
        self.present(alert, animated: true, completion: nil)
    }
}




