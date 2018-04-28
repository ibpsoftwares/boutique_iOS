////
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
class WishListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITabBarControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectSizeView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    @IBOutlet var crossBtn: UIButton!
    @IBOutlet var doneBtn: UIButton!
     @IBOutlet var sizeLabel: UILabel!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    var saveProductData = [getProduct]()
    var wishListArr = [getProductDetail]()
    var items = ["Casual Shirts", "Casual Shirts", "Casual Shirts", "Casual Shirts","Casual Shirts"]
     var wishListProduct = [getProductDetail]()
     var wishlist: [NSManagedObject] = []
    var addToCart: [NSManagedObject] = []
     var unique = [getProductDetail]()
     var sizeArr = [getSize]()
    var selectedIndex = NSInteger()
    var cartSelectedIndex = NSInteger()
    var size_id = String()
    var size = String()
    var cartlist: [NSManagedObject] = []
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgLabel.isHidden = true
        selectSizeView.layer.borderWidth = 1.0
        selectSizeView.layer.borderColor = UIColor.lightGray.cgColor
        selectedIndex = 200
        self.crossBtn.isHidden = true
        sizeLabel.isHidden = true
        doneBtn.isHidden = true
        self.selectSizeView.isHidden = true
        
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
  
    //MARK: Fetch Cart Data From Core Data
    func fetchCartData(){
        self.cartlist.removeAll()
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
        if cartlist.count > 0{
           self.cartCountLabel.text  = (String)(self.cartlist.count)
        }
        else{
            print("no data...")
           self.cartCountLabel.isHidden  = true
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchCartData()
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
                    
                    self.wishListProduct.append(getProductDetail.init(name: (person.value(forKeyPath: "name") as! String), id: (person.value(forKeyPath: "id") as! String), price: (person.value(forKeyPath: "price") as! String), image: (person.value(forKeyPath: "image") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brand: (person.value(forKeyPath: "brand") as! String), wishlistID: (person.value(forKeyPath: "wishlistID") as! String), cout: "", sizeID: ""))
                }
            }
        }
        self.tableView.reloadData()
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
        Webservice.apiPost(apiURl: "viewWishlist/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                        
                        self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1", sizeID: ""))
                    }
                    self.bgLabel.isHidden = true
                    Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
                    if self.wishListProduct.count > 0 {
                        self.cartCountLabel.text = (String)(self.wishListProduct.count)
                                let tabItems = self.tabBarController?.tabBar.items as NSArray!
                                let tabItem = tabItems![3] as! UITabBarItem
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
                    let tabItem = tabItems![3] as! UITabBarItem
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
        if Model.sharedInstance.userID != ""{
            self.deleteItemFromWishlist(wishlistID: self.wishListProduct[sender.tag].id,tag:sender.tag)
        }
        else{
            removeItem(index : sender.tag)
            wishlistFromLocalDatabase()
        }
    }
    @IBAction func btnDone(_ sender: UIButton){
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
                SKActivityIndicator.spinnerColor(UIColor.darkGray)
                SKActivityIndicator.show("Loading...")
                print(Model.sharedInstance.userID)
                parameter = ["user_id": Model.sharedInstance.userID, "cloth_id": "clothID","quantity": "1","size_id" : size_id ]
            
                //        else{
                //            removeItem(index : sender.tag)
                //        }
                print(parameter)
                
            Webservice.apiPost(apiURl: "movetocart/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                            
                            self.crossBtn.isHidden = true
                            self.sizeLabel.isHidden = true
                            self.doneBtn.isHidden = true
                            self.sizeCollectionView.isHidden = true
                            self.tableView.reloadData()
                            if self.wishListProduct.count > 0 {
                                Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
                                self.cartCountLabel.text = (String)(self.wishListProduct.count)
                                let tabItems = self.tabBarController?.tabBar.items as NSArray!
                                let tabItem = tabItems![3] as! UITabBarItem
                                tabItem.badgeValue = Model.sharedInstance.badgeValue
                            }
                            self.getWishListAPI()
                            
                        })
                        //self.present(alert, animated: true, completion: nil)
                    }
                }
            
            
        }
        else{
            if size == ""{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Select Size")
            }else{
                bottom()
                 moveToCart(index: cartSelectedIndex)
            }
        }
        print(parameter)
    }
    
    //MARK: Fetch Wishlist from lacal database
    func wishlistFromLocalDatabase(){
        
        self.wishListProduct.removeAll()
        self.wishlist.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            self.wishlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if self.wishlist.count > 0{
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems![3] as! UITabBarItem
            tabItem.badgeValue = String(wishlist.count)
            
        }else{
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems![3] as! UITabBarItem
            tabItem.badgeValue = nil
        }
    }
    
    //MARK: Remove item for wishlist
    func removeItem(index : NSInteger){
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let note = wishlist[index]
        managedContext.delete(note)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        
        //Code to Fetch New Data From The DB and Reload Table.
       
        let Context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            wishlist.removeAll()
            wishlist = try Context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    //MARK: MOVE To Cart in coredata
    func moveToCart(index: NSInteger){
        
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
        cart.setValue(size_id, forKeyPath: "sizeID")
        cart.setValue(size, forKeyPath: "size")
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
        
        self.crossBtn.isHidden = true
        self.sizeLabel.isHidden = true
        self.doneBtn.isHidden = true
        self.sizeCollectionView.isHidden = true
        self.sizeCollectionView.removeFromSuperview()
        //Code to Fetch New Data From The DB and Reload Table.
        
        let Context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            wishlist.removeAll()
            wishlist = try Context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
          fetchCartData()
        self.tableView.reloadData()
    }
    //MARK: addToCartAPI Methods
    
    @objc func addToCartAPI(sender:UIButton!){
        
        if Model.sharedInstance.userID == ""{
        cartSelectedIndex = sender.tag
        getItemSize(index: sender.tag)
    }
        else{
        var parameter: Parameters = [:]
            if size == ""{
                getItemSize(index: sender.tag)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Select Size")
            }
//            }else{
//
//                SKActivityIndicator.spinnerColor(UIColor.darkGray)
//                SKActivityIndicator.show("Loading...")
//                print(Model.sharedInstance.userID)
//               let sizeid = (((sizeArr[0].size[selectedIndex] as! NSDictionary).value(forKey: "Size") as! NSDictionary).value(forKey: "size_id") as! String)
//                parameter = ["user_id": Model.sharedInstance.userID, "cloth_id": "clothID","quantity": "1","size_id" : sizeid ]
//
//
//
////        else{
////            removeItem(index : sender.tag)
////        }
//        print(parameter)
//
//        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/movetocart/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                return
//            }
//            DispatchQueue.main.async(execute: {
//                SKActivityIndicator.dismiss()
//            })
//            print(response!)
//            if ((response!["message"] as? [String:Any]) != nil){
//                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
//
//                self.present(alert, animated: true, completion: nil)
//            }
//            else{
//
////                let alert = UIAlertController(title: "Alert", message: (response?.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
////                alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
//
//                DispatchQueue.main.async(execute: {
//                   // self.wishListProduct.remove(at: sender.tag)
//                    self.tableView.reloadData()
//                    if self.wishListProduct.count > 0 {
//                        Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
//                        self.cartCountLabel.text = (String)(self.wishListProduct.count)
//                        let tabItems = self.tabBarController?.tabBar.items as NSArray!
//                        let tabItem = tabItems![3] as! UITabBarItem
//                        tabItem.badgeValue = Model.sharedInstance.badgeValue
//                    }
//                    self.self.viewToCartAPI()
//
//                })
//                //self.present(alert, animated: true, completion: nil)
//            }
//        }
//      }
    }
    }
    
    func getItemSize(index: NSInteger){
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID == ""{
        let person = wishlist[index]
        let clothID = (person.value(forKeyPath: "id") as? String)!
         parameter = ["cloth_id":clothID]
        }
        else{
             parameter = ["cloth_id":wishListProduct[index].id]
        }
        print(parameter)
        Webservice.apiPost(apiURl: "getsize/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
              self.sizeArr.append(getSize.init(size: (response!.value(forKey: "sizes") as! NSArray)))
                print(self.sizeArr)
                 self.selectSizeView.isHidden = false
                self.crossBtn.isHidden = false
                self.sizeLabel.isHidden = false
                self.doneBtn.isHidden = false
                 self.Up()
                DispatchQueue.main.async(execute: {
                     self.selectSizeView.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                   self.sizeCollectionView.reloadData()
                })
            }
        }
    }
    
    func bottom()  {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.selectSizeView.layer.add(transition, forKey: nil)
        self.view .addSubview(self.selectSizeView)
        self.selectSizeView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func Up()  {
        self.tabBarController?.tabBar.isHidden = true
         self.selectSizeView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.selectSizeView.center.y -= self.view.bounds.height - (self.view.bounds.height - 200 )
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: Button Actions
    @IBAction func btnCross(_ sender: UIButton) {
//        self.crossBtn.isHidden = true
//        sizeLabel.isHidden = true
//        doneBtn.isHidden = true
//        self.sizeCollectionView.isHidden = true
       bottom()
    }
    //MARK: viewToCartAPI Methods
    func viewToCartAPI(){
        if Model.sharedInstance.userID == ""{
            
        }
        else{
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        
            Webservice.apiPost(apiURl: "ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
    //MARK: CollectionView Delegate & DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sizeArr.count > 0 {
             return self.sizeArr[0].size.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath as IndexPath) as! SizeCollectionViewCell
                cell.sizeBtn.layer.cornerRadius = cell.sizeBtn.frame.size.height / 2
                cell.sizeBtn.clipsToBounds = true
        
                let size = (((sizeArr[0].size[indexPath.row] as! NSDictionary).value(forKey: "Size") as! NSDictionary).value(forKey: "size") as! String)
                let value:String?
                value = size
                cell.sizeLabel.text = value
                cell.sizeLabel.textColor = UIColor.black
                cell.sizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
                cell.sizeBtn.layer.borderWidth = 0.8
        
                if selectedIndex == indexPath.row                {
                    cell.sizeBtn.backgroundColor = UIColor (red: 43.0/255.0, green: 59.0/255.0, blue: 68.0/255.0, alpha: 1)
                    cell.sizeLabel.textColor = UIColor.white
                   // selectedIndex = 200
                }
                else{
                    cell.sizeBtn.backgroundColor = UIColor.white
                    cell.sizeBtn.setTitleColor(UIColor.black, for: .normal)
                }
                cell.sizeBtn.tag = indexPath.row
                cell.sizeBtn.addTarget(self,action:#selector(selectSize(sender:)), for: .touchUpInside)
        
                return cell
    }
    @objc func selectSize(sender:UIButton!){
        self.selectedIndex = sender.tag
         size_id = (((sizeArr[0].size[selectedIndex] as! NSDictionary).value(forKey: "Size") as! NSDictionary).value(forKey: "id") as! String)
         size = (((sizeArr[0].size[selectedIndex] as! NSDictionary).value(forKey: "Size") as! NSDictionary).value(forKey: "size") as! String)
        self.sizeCollectionView.reloadData()
        
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
        
        Webservice.apiPost(apiURl: "rmwishlist/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
            }
        }
    }
    
}

