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
import CoreData

@available(iOS 10.0, *)
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
    var cartlist: [NSManagedObject] = []
    var checkoutlist: [Dictionary<String, AnyObject>] = []
     var quantitylist: [Dictionary<String, AnyObject>] = []
    var quanity = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        count = 1
        checkoutView.isHidden = false
        tableView.tableFooterView = UIView()
        checkoutButton.layer.borderWidth = 0.5
       // checkoutButton.layer.borderColor = UIColor.secondary.cgColor
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //fetchCartDetails()
        self.cartProduct.removeAll()
        //self.tabBarController?.tabBar.isHidden = true
        if Model.sharedInstance.userID != "" {
            getCartViewAPI()
        }else{
            fetchCartData()
            //deleteRecords()
        }
    }
    
    
    func deleteRecords() -> Void {
            
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cartlist")
        do {
            cartlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print(cartlist.count)
        for row in 0...cartlist.count - 1{
            let note = cartlist[row]
            managedContext.delete(note)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
                }
            }
         fetchCartData()
         }
  
    
    
    //MARK: Fetch Cart Data From Core Data
    func fetchCartData(){
        self.cartProduct.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cartlist")
        do {
            cartlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print(cartlist.count)
        self.itemsCountLabel.text =  "Total (0)"
        self.totalPriceLabel.text = String("$\(0)")
        if cartlist.count > 0{
            
            for row in 0...cartlist.count - 1{
                let person = cartlist[row]
                if (person.value(forKeyPath: "name") as! String) == ""{
                    
                }else{
                    self.cartProduct.append(getProductDetail.init(name: (person.value(forKeyPath: "name") as! String), id:  (person.value(forKeyPath: "id") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brand: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, cout: "1", sizeID: (person.value(forKeyPath: "size") as! String)))
                }
            }
        
        self.itemsCountLabel.text =  "Total (\(self.cartProduct.count))"
        for var i in (0..<(self.cartProduct.count)){
            let total = (Int)(self.cartProduct[i].price)!
            print(total)
            self.totalPrice += total
            self.totalPriceLabel.text = String("$\(self.totalPrice)")
            Model.sharedInstance.totalPrice = Double(self.totalPrice)
        }
     }
         self.tableView.reloadData()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: getCartViewAPI Methods
    func getCartViewAPI(){
        self.cartProduct.removeAll()
        self.totalPrice = 0
        self.cartProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
                var parameter: Parameters = [:]
        
                if Model.sharedInstance.userID != "" {
                    parameter = ["user_id": Model.sharedInstance.userID]
                }
                else{
                    parameter = ["user_id":""]
                }
        
          print(parameter)
        
        Webservice.apiPost(apiURl: "viewCart/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                        

                        if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                           self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cart_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "id") as! String), brand: "", wishlistID: "", cout: "1", sizeID: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "size") as! String)))
                        }
                        else {
                            self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cart_id") as! String), price: ((item as! NSDictionary).value(forKey: "offer_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "id") as! String), brand: "", wishlistID: "", cout: "1", sizeID: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "size") as! String)))
                        }
                        
//                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cart_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "id") as! String), brand: "", wishlistID: "", cout: "1", sizeID: (((item as! NSDictionary).value(forKey: "size") as! NSDictionary).value(forKey: "size") as! String)))
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
                        Model.sharedInstance.totalPrice = Double(self.totalPrice)
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
       
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.height / 2
        cell.thumbImageView.clipsToBounds = true
        
        cell.nameLabel.text = cartProduct[indexPath.row].name
        cell.priceLabel.text = "\(Model.sharedInstance.currency)\(cartProduct[indexPath.row].price)"
        let url = URL(string: self.cartProduct[indexPath.row].image)
        cell.thumbImageView.kf.setImage(with: url,placeholder: nil)
        cell.sizeLabel.text = cartProduct[indexPath.row].sizeID
        let qqq = cell.qty.text!
        
        let dictPoint = [
            "quantity": qqq
        ]
        print(dictPoint)
       quantitylist.append(dictPoint as [String : AnyObject])
        cell.removeButton.tag = indexPath.row
         cell.removeButton.addTarget(self,action:#selector(remove(sender:)), for: .touchUpInside)
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
        quantitylist.removeAll()
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
        Model.sharedInstance.totalPrice = Double(self.totalPrice)
        self.tableView.reloadData()
        return count
    }
    
   @objc func subBtn(sender: AnyObject) -> Int {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! CartCell!
        quantitylist.removeAll()
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
            Model.sharedInstance.totalPrice = Double(self.totalPrice)
        }
    self.tableView.reloadData()
        return count
    }
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 10.0, *) {
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.productID = self.cartProduct[indexPath.row].id
            navigationController?.pushViewController(productDetailVC, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func remove(sender:UIButton!) {
        if Model.sharedInstance.userID != "" {
            self.deleteItemFromCart(cartID: self.cartProduct[sender.tag].id, sizeID: self.cartProduct[sender.tag].oldPrice)
        }
        else{
             if cartlist.count > 0{
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let note = cartlist[sender.tag]
            managedContext.delete(note)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        }
         self.fetchCartData()
    }
    
    //MARK: deleteItemFromCart Methods
    func deleteItemFromCart( cartID : String,sizeID: String){
        
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
            parameter = ["user_id": Model.sharedInstance.userID, "cloth_id": cartID,"size_id": sizeID]
        }
        print(parameter)
        
        Webservice.apiPost(apiURl: "rmcart/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            else
            {
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                self.getCartViewAPI()
            }
        }
    }
    
    @IBAction func checkout(_ sender: UIButton) {
    
        if Model.sharedInstance.userID != "" {
            
            self.checkout()
        }
        else{
        
        let alertController = UIAlertController(title: "Please Login!", message: "", preferredStyle: UIAlertControllerStyle.alert)
//        alertController.addTextField { (textField : UITextField) -> Void in
//            textField.placeholder = "Enter Email..."
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(abcViewController, animated: true)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    }
    func checkout(){
        
        if cartProduct.count > 0{
            for row in 0...cartProduct.count - 1{
                
                let dictPoint = [
                    "cart_id": self.cartProduct[row].id,
                    "quantity": (quantitylist[row] as NSDictionary).value(forKey: "quantity") as! String
                ]
                
                print(dictPoint)
                checkoutlist.append(dictPoint as [String : AnyObject])
                
            }
        }
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let params: [String:Any] = ["checkout_data":toJSonString(data: checkoutlist),
                                    "user_id": Model.sharedInstance.userID]
        
        print(params)
        
        
        Webservice.apiPost(apiURl: "checkout/", parameters: params, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (response?.value(forKey: "message") as! String) == "Unable to process"{
                
            }
            else{
                if (response?.value(forKey: "shippingDetails")  != nil){
                    //(((((response?.value(forKey: "shippingDetails")) as! NSArray).object(at: 0)) as! NSDictionary).value(forKey: "address") as! String)
                    if (((response?.value(forKey: "shippingDetails")) as! NSArray).count)  == 0{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let abcViewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
                        self.navigationController?.pushViewController(abcViewController, animated: true)
                    }else{
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let abcViewController = storyboard.instantiateViewController(withIdentifier: "AddPaymentViewController") as! AddPaymentViewController
                        abcViewController.userData = ((((response?.value(forKey: "shippingDetails")) as! NSArray).object(at: 0)) as! NSDictionary)
                        abcViewController.totalPrice = self.totalPriceLabel.text!
                        self.navigationController?.pushViewController(abcViewController, animated: true)
                    }
                }
            }
        }
    }
    func toJSonString(data : Any) -> String {
        
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
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




