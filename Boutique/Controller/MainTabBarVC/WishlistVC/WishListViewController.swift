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
    
    var items = ["Casual Shirts", "Casual Shirts", "Casual Shirts", "Casual Shirts","Casual Shirts"]
     var wishListProduct = [getProductDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "WishListTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.tableFooterView = UIView()
        self.cartCountLabel.layer.cornerRadius = self.cartCountLabel.frame.size.height / 2
        
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
        self.wishListProduct.removeAll()
        getWishListAPI()
        viewToCartAPI()
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
                        
                        self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Wishlist_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String)))
                    }
                    
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
        cell.wishlistBtn.tag = indexPath.row
        cell.wishlistBtn.addTarget(self,action:#selector(addToCartAPI(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func buttonClicked(sender:UIButton!) {
        
        print("\(sender.tag)")
        self.deleteItemFromWishlist(wishlistID: self.wishListProduct[sender.tag].id)
        
    }
    
    //MARK: addToCartAPI Methods
    @objc func addToCartAPI(sender:UIButton!){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": wishListProduct[sender.tag]
        ]
        
        print(parameters)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToCart/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                self.viewToCartAPI()
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
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
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                self.cartCountLabel.text = String((response!.value(forKey: "items") as! NSArray).count)
            }
        }
    }
    
 
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.getWishListAPI()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: deleteItemFromWishlist Methods
    func deleteItemFromWishlist( wishlistID : String){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "wishlist_id": wishlistID,
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
              //  self.getWishListAPI()
                self.showAlert(msg: (response?.value(forKey: "message") as! String))
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                self.showAlert(msg: (response?.value(forKey: "message") as! String))
//                self.getWishListAPI()
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
   
   
}
