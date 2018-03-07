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

class WishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITabBarControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    
    var items = ["Casual Shirts", "Casual Shirts", "Casual Shirts", "Casual Shirts","Casual Shirts"]
     var wishListProduct = [getProductDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgLabel.isHidden = true
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.tableFooterView = UIView()
        self.cartCountLabel.layer.cornerRadius = self.cartCountLabel.frame.size.height / 2
        self.cartCountLabel.clipsToBounds = true
        
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowRadius = 10
         self.wishListProduct.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
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
        
        
        self.wishListProduct.removeAll()
        viewToCartAPI()
        getWishListAPI()
    }

    //MARK: getWishListAPI Methods
    func getWishListAPI(){
        
        self.wishListProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewWishlist/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
        return self.wishListProduct.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:WishListTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! WishListTableViewCell!
        
        cell.productImg.layer.cornerRadius = cell.productImg.frame.size.height / 2
        cell.productImg.clipsToBounds = true
        let url = URL(string: self.wishListProduct[indexPath.row].image)
        cell.productImg.kf.setImage(with: url,placeholder: nil)
        
        cell.productNameLabel.text = wishListProduct[indexPath.row].name
        cell.productPriceLabel.text = "$\(wishListProduct[indexPath.row].price)"
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
        print("You tapped cell number \(indexPath.row).")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailVC.productID = self.wishListProduct[indexPath.row].id
        navigationController?.pushViewController(productDetailVC, animated: true)
        
    }
    @objc func buttonClicked(sender:UIButton!) {
        
        print("\(sender.tag)")
        self.deleteItemFromWishlist(wishlistID: self.wishListProduct[sender.tag].id,tag:sender.tag)
        
    }
    
    //MARK: addToCartAPI Methods
    @objc func addToCartAPI(sender:UIButton!){
        
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": wishListProduct[sender.tag].id,
            "quantity": "1"
        ]
        
        print(parameters)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/movetocart/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if ((response!["message"] as? [String:Any]) == nil){
                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
               
                self.present(alert, animated: true, completion: nil)
            }
            else{
//                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
                
                DispatchQueue.main.async(execute: {
                    self.wishListProduct.remove(at: sender.tag)
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
