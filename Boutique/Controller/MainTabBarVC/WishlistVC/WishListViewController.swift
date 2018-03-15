//
//  WishListViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Kingfisher
import SKActivityIndicatorView
import Alamofire
import CoreData

@available(iOS 10.0, *)
class WishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITabBarControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    var saveProductData = [getProduct]()
    var wishListArr = [getProductDetail]()
    var items = ["Casual Shirts", "Casual Shirts", "Casual Shirts", "Casual Shirts","Casual Shirts"]
     var wishListProduct = [getProductDetail]()
     var wishlist: [NSManagedObject] = []
    var addToCart: [NSManagedObject] = []
     var unique = [getProductDetail]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgLabel.isHidden = true
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.tableFooterView = UIView()
        self.cartCountLabel.layer.cornerRadius = self.cartCountLabel.frame.size.height / 2
        self.cartCountLabel.clipsToBounds = true
    
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
         self.wishListProduct.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
         self.wishListProduct.removeAll()
        if Model.sharedInstance.userID != "" {
            getWishListAPI()
        }
        else{
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
                    
                    self.wishListProduct.append(getProductDetail.init(name: (person.value(forKeyPath: "name") as! String), id: (person.value(forKeyPath: "id") as! String), price: (person.value(forKeyPath: "price") as! String), image: (person.value(forKeyPath: "image") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brand: (person.value(forKeyPath: "brand") as! String), wishlistID: (person.value(forKeyPath: "wishlistID") as! String), cout: ""))
                }
            }
            
          
            
        }
      
       // viewToCartAPI()
      
//        let dedupe = removeDuplicates(array: wishListProduct)
//        print(dedupe)
//        if dedupe.count > 0 {
//              self.wishListProduct.removeAll()
//            for row in 0...dedupe.count - 1{
//                self.wishListProduct.append(getProductDetail.init(name: dedupe[row].name, id: dedupe[row].id, price: dedupe[row].price, image: dedupe[row].image, oldPrice: dedupe[row].oldPrice, brand: dedupe[row].brand, wishlistID: dedupe[row].wishlistID, cout: ""))
//            }
//        }
        self.tableView.reloadData()
        let defaults = UserDefaults.standard
        if (defaults.value(forKey: "totalCartItem")) != nil {
            let count = (defaults.value(forKey: "totalCartItem"))
            var temp1 : String! // This is not optional.
            temp1 = (String)(describing: count!)
            print(temp1)
            self.cartCountLabel.text = temp1
        }
        else {
            self.cartCountLabel.text = ""
        }
    }
    func removeDuplicates(array: [getProductDetail]) -> [getProductDetail] {
        var encountered = Set<String>()
        var result: [getProductDetail] = []
        for value in array {
            if encountered.contains(value.id) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value.id)
                encountered.insert(value.name)
                encountered.insert(value.price)
                encountered.insert(value.oldPrice)
                encountered.insert(value.image)
                encountered.insert(value.wishlistID)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    //MARK: getWishListAPI Methods
    func getWishListAPI(){
        
        self.wishListProduct.removeAll()
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
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/viewWishlist/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
                
            })
            print(response!)
//            if ((response!["message"] as? [String:Any]) != nil){
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
            
                //else{
                 if ((response!.value(forKey: "Wishlist") != nil)){
                
                    for item in (response?.value(forKey: "Wishlist") as! NSArray) {
                        print(item)
                        
                        self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1"))
                    }
                    self.bgLabel.isHidden = true
                    Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
                    if self.wishListProduct.count > 0 {
                        self.cartCountLabel.text = (String)(self.wishListProduct.count)
                                let tabItems = self.tabBarController?.tabBar.items as NSArray!
                                let tabItem = tabItems![4] as! UITabBarItem
                                tabItem.badgeValue = Model.sharedInstance.badgeValue
                    }
                    
                    for var i in (0..<(self.wishListProduct.count)){
                        let total = (Int)(self.wishListProduct[i].price)!
                        print(total)
                        
                    }
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            else{
                    self.bgLabel.isHidden = false
                    let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabItems![4] as! UITabBarItem
                    tabItem.badgeValue = nil
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                 Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            
        }
    }
    
    @IBAction func cartBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }
    //MARK: TableView Delegate and Data Source
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Model.sharedInstance.userID == "" {
            return wishlist.count
        }else{
            return self.wishListProduct.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:WishListTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! WishListTableViewCell!
        
        cell.productImg.layer.cornerRadius = cell.productImg.frame.size.height / 2
        cell.productImg.clipsToBounds = true
        
         if Model.sharedInstance.userID == "" {
            
            if wishlist.count > 0{
            let person = wishlist[indexPath.row]
            let url = URL(string: (person.value(forKeyPath: "image") as? String)!)
            cell.productImg.kf.setImage(with: url,placeholder: nil)
            cell.productNameLabel.text = person.value(forKeyPath: "name") as? String
            let price: String? = person.value(forKeyPath: "price") as? String
            cell.productPriceLabel.text = "$\(price!)"
//                let url = URL(string: self.wishListProduct[indexPath.row].image)
//                cell.productImg.kf.setImage(with: url,placeholder: nil)
//                cell.productNameLabel.text = wishListProduct[indexPath.row].name
//                cell.productPriceLabel.text = "$\(wishListProduct[indexPath.row].price)"
            }
        }
         else{
            
            let url = URL(string: self.wishListProduct[indexPath.row].image)
            cell.productImg.kf.setImage(with: url,placeholder: nil)
            cell.productNameLabel.text = wishListProduct[indexPath.row].name
            cell.productPriceLabel.text = "$\(wishListProduct[indexPath.row].price)"
            
        }
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        cell.wishlistBtn.layer.cornerRadius = 2
        cell.wishlistBtn.layer.borderColor = UIColor (red: 237.0/255.0, green: 123.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        cell.wishlistBtn.tag = indexPath.row
        cell.wishlistBtn.addTarget(self,action:#selector(addToCartAPI(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Model.sharedInstance.userID != "" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.productID = self.wishListProduct[indexPath.row].id
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
        else{
            if wishlist.count > 0{
                let person = wishlist[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
                productDetailVC.productID = (person.value(forKeyPath: "id") as? String)!
                navigationController?.pushViewController(productDetailVC, animated: true)
            }
            }
        
        print("You tapped cell number \(indexPath.row).")
        
        
    }
    @objc func buttonClicked(sender:UIButton!) {
        
        print("\(sender.tag)")
        self.deleteItemFromWishlist(wishlistID: self.wishListProduct[sender.tag].id,tag:sender.tag)
        
    }
    //MARK: Remove item for wishlist
    func removeItem(index : NSInteger){
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedCon = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Cartlist",
                                                in: managedCon)!

        let cart = NSManagedObject(entity: entity,
                                     insertInto: managedCon)
        let data = wishlist[index]

        cart.setValue((data.value(forKeyPath: "id") as? String)!, forKeyPath: "id")
        cart.setValue((data.value(forKeyPath: "name") as? String)!, forKeyPath: "name")
        cart.setValue((data.value(forKeyPath: "price") as? String)!, forKeyPath: "price")
        cart.setValue((data.value(forKeyPath: "oldPrice") as? String)!, forKeyPath: "oldPrice")
        cart.setValue((data.value(forKeyPath: "brand") as? String)!, forKeyPath: "brand")
        cart.setValue((data.value(forKeyPath: "image") as? String)!, forKeyPath: "image")
        cart.setValue("1", forKeyPath: "wishlistID")
        print(cart)
        do {
            try managedCon.save()
            addToCart.append(cart)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let note = wishlist[index]
        managedContext.delete(note)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        
        //Code to Fetch New Data From The DB and Reload Table.
       
        let Context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            wishlist.removeAll()
            wishlist = try Context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
}
    //MARK: addToCartAPI Methods
    @objc func addToCartAPI(sender:UIButton!){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
    
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
            
            
            parameter = ["user_id": Model.sharedInstance.userID, "cloth_id": "clothID","quantity": "1"]
        }
        else{
            removeItem(index : sender.tag)
        }
        print(parameter)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/movetocart/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
               
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
//                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                   // self.wishListProduct.remove(at: sender.tag)
                    self.tableView.reloadData()
                    if self.wishListProduct.count > 0 {
                        Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
                        self.cartCountLabel.text = (String)(self.wishListProduct.count)
                        let tabItems = self.tabBarController?.tabBar.items as NSArray!
                        let tabItem = tabItems![4] as! UITabBarItem
                        tabItem.badgeValue = Model.sharedInstance.badgeValue
                    }
                    self.self.viewToCartAPI()
                    
                })
                //self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: viewToCartAPI Methods
    func viewToCartAPI(){
        if Model.sharedInstance.userID == ""{
            
        }
        else{
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        
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
                self.cartCountLabel.text = String((response!.value(forKey: "items") as! NSArray).count)
                
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
               // self.cartCountLabel.text = String((response!.value(forKey: "items") as! NSArray).count)
                 //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
     }
    }
 
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.viewToCartAPI()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: deleteItemFromWishlist Methods
    func deleteItemFromWishlist( wishlistID : String,tag: NSInteger){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": wishlistID
            ]
        print(parameters)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/rmwishlist/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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

                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                self.self.getWishListAPI()
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                self.self.getWishListAPI()
                
//                DispatchQueue.main.async(execute: {
//                    self.self.getWishListAPI()
////                    self.wishListProduct.remove(at: tag)
////                    self.tableView.reloadData()
////                    if self.wishListProduct.count > 0 {
////                        Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
////                        self.cartCountLabel.text = (String)(self.wishListProduct.count)
////                        let tabItems = self.tabBarController?.tabBar.items as NSArray!
////                        let tabItem = tabItems![4] as! UITabBarItem
////                        tabItem.badgeValue = Model.sharedInstance.badgeValue
////                        self.self.getWishListAPI()
////                    }
//                })
                
//                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
               // self.self.getWishListAPI()
                //self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
