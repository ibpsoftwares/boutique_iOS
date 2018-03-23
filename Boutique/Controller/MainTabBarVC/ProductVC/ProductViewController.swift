//
//  ProductViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SKActivityIndicatorView
import CoreData

class Product{
    var price : Double = 0.0
    var name: String = ""
    var id : String
    var image: String
    var oldPrice: String
    var brand: String
    var wishlistID : String
    init(price:Double, name:String,id : String,image: String,oldPrice: String,brand:String,wishlistID:String) {
        self.price = price
        self.name = name
        self.id = id
        self.image = image
        self.oldPrice = oldPrice
        self.brand = brand
        self.wishlistID = wishlistID
    }
}

class getProductDetail {
    var name: String
    var price: String
    var id : String
    var image: String
    var oldPrice: String
    var brand: String
    var wishlistID : String
    var cout: String
    var sizeID : String
    init(name: String,id : String,price: String,image: String,oldPrice: String,brand:String,wishlistID:String,cout: String,sizeID : String) {
        self.name = name
        self.id = id
        self.price = price
        self.image = image
        self.oldPrice = oldPrice
        self.brand = brand
         self.wishlistID = wishlistID
        self.cout = cout
        self.sizeID = sizeID
        
    }
}
class getPrice {
    var id: String
    var range_a :String
    var range_b : String
    init(id : String,range_a: String,range_b: String) {
        self.id = id
        self.range_a = range_a
        self.range_b = range_b
        
    }
}
@available(iOS 10.0, *)
class ProductViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate , UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    var searchActive : Bool = false
    var data :[String] = []
    var filtered:[String] = []
   var screenheight : CGFloat!
    var product = [getProductDetail]()
    var price = [getPrice]()
    var categoryID = String()
    var sortedArray = [Product]()
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideSortView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTableView: UITableView!
    var sortArr =  ["Price :High To Low","Price :Low To High","Newest First","Oldest First"]
    var filterArr =  ["Price : 100 To 500","Price : 500 To 1000","Price : 1000 To 2000","Price : 2000 To 5000"]
    var check : Bool = false
    var selectedSortIndex = String()
    var wishlist: [NSManagedObject] = []
    var productlocal = [getProduct]()
    var seletedIndex = NSInteger()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        filterTableView.register(UINib(nibName:"PriceTableViewCell", bundle: nil), forCellReuseIdentifier: "rangeCell")
        tableView.tableFooterView = UIView()
        filterTableView.tableFooterView = UIView()
        
        self.screenheight = self.view.frame.size.height
        
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       // width = width - 10
        layout.itemSize = CGSize(width: width / 2 , height:290)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.collectionViewLayout = layout
        
        getPriceAPI()
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewWillAppear(_ animated: Bool) {
       //  self.tabBarController?.tabBar.isHidden = false
        self.product.removeAll()
       
        self.productlocal.removeAll()
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
                self.productlocal.append(getProduct.init(name: (person.value(forKeyPath: "name") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String) , id:  (person.value(forKeyPath: "id") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brandName: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, sizeID: ""))
            }
        }
        
         self.getProductAPI()
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: getProductAPI Methods
     func getProductAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(categoryID)
       var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
            parameter = ["user_id": Model.sharedInstance.userID,"category_id":categoryID]
            
        }
        else{
            parameter = ["user_id":"","category_id":categoryID]
        }
        print(parameter)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getByCategory/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                
                if ((response!.value(forKey: "cloths") != nil) ){
                    
                    for item in (response!.value(forKey: "cloths") as! NSArray) {
                        print(item)
                        
                        
                        
                        self.data.append(((item as! NSDictionary).value(forKey: "title") as! String))
                        
                        if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                            print("empty")
                            self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: "", brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String), cout: "1", sizeID: ""))
                        }
                        else {
                            
                            self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String), cout: "1", sizeID: ""))
                            
                        }
                    }
                    if Model.sharedInstance.userID == "" {
                        
                        if self.product.count > 0{
                            for row in 0...self.product.count - 1{
                                
                                if self.product.count <= self.productlocal.count {
                                    print("index :\(row)")
                                }
                                else{
                                    self.productlocal.append(getProduct.init(name: "", price: "" , image: "" , id:  "", oldPrice: "", brandName: "", wishlistID: "", sizeID: ""))
                                }
                            }
                        }
                        
                        for section in 0...self.product.count - 1 {
                            
                            if let i = self.product.index(where: { $0.id == self.productlocal[section].id }) {
                                print(i)
                                self.product[i].wishlistID = "1"
                                // return i
                                print("Section: match found")
                            }
                            else{
                                print("Section: match not found")
                            }
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                }
                else {
                    self.showAlert(msg:(response!.value(forKey: "message") as! String))
                }
            }
        }
    }

    
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(check) {
            return sortedArray.count
        }
        return product.count;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cell.layer.borderWidth = 0.5
        
        if(check){
           
            if  self.sortedArray[indexPath.row].oldPrice != "" {
                cell.oldPriceLabel.text = self.sortedArray[indexPath.row].oldPrice
            }
            else{
                cell.oldPriceLabel.isHidden = true
                cell.crossLabel.isHidden = true
            }
            if self.sortedArray[indexPath.row].wishlistID == "1"
            {
                cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
            }
            else{
                
                cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
            }
            cell.wishlistBtn.tag = indexPath.row
            cell.wishlistBtn.addTarget(self,action:#selector(addToWishListAPI(sender:)), for: .touchUpInside)
            cell.productNameLabel.text = self.sortedArray[indexPath.row].name
            cell.originalPriceLabel.text = (String)(self.sortedArray[indexPath.row].price)
            let url = URL(string: self.sortedArray[indexPath.row].image)
            cell.productImg.kf.setImage(with: url,placeholder: nil)
        } else {
        
        if  self.product[indexPath.row].oldPrice != "" {
            cell.oldPriceLabel.text = self.product[indexPath.row].oldPrice
        }
        else{
            cell.oldPriceLabel.isHidden = true
            cell.crossLabel.isHidden = true
        }
        if self.product[indexPath.row].wishlistID == "1"
        {
            cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
        }
        else{
            
            cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
        }
            cell.wishlistBtn.tag = indexPath.row
            cell.wishlistBtn.addTarget(self,action:#selector(addToWishListAPI(sender:)), for: .touchUpInside)
            cell.productNameLabel.text = self.product[indexPath.row].name
            cell.originalPriceLabel.text = self.product[indexPath.row].price
            let url = URL(string: self.product[indexPath.row].image)
            cell.productImg.kf.setImage(with: url,placeholder: nil)
        }
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return sectionInset
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if check {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.productID = self.sortedArray[indexPath.row].id
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.passDict.setValue(self.product[indexPath.row].id, forKey: "id")
            productDetailVC.passDict.setValue(self.product[indexPath.row].name, forKey: "name")
            productDetailVC.passDict.setValue(self.product[indexPath.row].price, forKey: "price")
            productDetailVC.passDict.setValue(self.product[indexPath.row].image, forKey: "image")
            productDetailVC.passDict.setValue(self.product[indexPath.row].brand, forKey: "brand")
            productDetailVC.passDict.setValue(self.product[indexPath.row].oldPrice, forKey: "oldPrice")
            productDetailVC.productID = self.product[indexPath.row].id
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    //MARK: addToWishListAPI Methods
    @objc func addToWishListAPI(sender:UIButton!){
        
        seletedIndex = sender.tag
        if Model.sharedInstance.userID == ""{
        if sender.imageView?.image == UIImage (named: "emptyWishlist")
        {
            //saveData()
            if #available(iOS 10.0, *) {
                sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                
                save()
            } else {
                // Fallback on earlier versions
            }
        }
        else  if sender.imageView?.image == UIImage (named: "heart") {
            
            sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
            self.productlocal.remove(at: sender.tag)
        }
    }
        else{
        
        let parameter: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.product[sender.tag].id
        ]
        if sender.imageView?.image == UIImage (named: "emptyWishlist")
        {
           // SKActivityIndicator.spinnerColor(UIColor.darkGray)
           // SKActivityIndicator.show("Loading...")

            Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToWishlist/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                    return
                }
                DispatchQueue.main.async(execute: {
                   // SKActivityIndicator.dismiss()
                })
                sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                print(response!)
                if ((response!["message"] as? [String:Any]) != nil){
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
                else{
                    //self.getWishListAPI()
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
            }
        }
        else  if sender.imageView?.image == UIImage (named: "heart") {

           // SKActivityIndicator.spinnerColor(UIColor.darkGray)
            //SKActivityIndicator.show("Loading...")

            Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/rmWishlist/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                    return
                }
                DispatchQueue.main.async(execute: {
                   // SKActivityIndicator.dismiss()
                })
                print(response!)
                sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
                if ((response!["message"] as? [String:Any]) != nil){
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
                else{
                   // self.getWishListAPI()
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
            }
          }
        }
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Wishlist",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(self.product[seletedIndex].id, forKeyPath: "id")
        person.setValue(self.product[seletedIndex].name, forKeyPath: "name")
        person.setValue(self.product[seletedIndex].price, forKeyPath: "price")
        person.setValue(self.product[seletedIndex].oldPrice, forKeyPath: "oldPrice")
        person.setValue(self.product[seletedIndex].brand, forKeyPath: "brand")
        person.setValue(self.product[seletedIndex].image, forKeyPath: "image")
        person.setValue("1", forKeyPath: "wishlistID")
        
        print(person)
        do {
            try managedContext.save()
            wishlist.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.product[seletedIndex].wishlistID = "1"
    }

    //MARK: SearchBar Delegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchItem(itemName : searchText)
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.collectionView.reloadData()
    }

     //MARK: searchItem Methods
    func searchItem(itemName : String){
        self.product.removeAll()
        self.data.removeAll()
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
                        "product_name": itemName
        ]
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getByCategory/\(categoryID)/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                for item in (response!.value(forKey: "cloths") as! NSArray) {
                    print(item)
                    
                    self.data.append(((item as! NSDictionary).value(forKey: "title") as! String))
                    
                    self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "category_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "Wishlist") as! String), cout: "1", sizeID: ""))
                    
                }
                
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
        }

    }
//    //MARK: searchItem Methods
//    func searchItem(itemName : String){
//        self.product.removeAll()
//        self.data.removeAll()
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
//        let parameters: Parameters = [
//            "product_name": itemName ,
//            ]
//
//        print(parameters)
//        let url = "http://kftsoftwares.com/ecom/recipes/getbycategory/\(categoryID)/ZWNvbW1lcmNl/"
//
//        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
//            switch response.result {
//
//            case .success:
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                if response.result.value != nil{
//
//                    let product = response.result.value as! NSDictionary
//                    for item in ((product ).value(forKey: "cloths") as! NSArray) {
//                        print(item)
//
//                        self.data.append(((item as! NSDictionary).value(forKey: "title") as! String))
//
//                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String)))
//
//                    }
//
//                    DispatchQueue.main.async(execute: {
//                        self.collectionView.reloadData()
//                    })
//                }
//                break
//            case .failure(let error):
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                print(error)
//            }
//        }
//    }
    
    @IBAction func btnSort(_ sender: UIButton) {
        self.slideSortView.isHidden = false
        self.tableView.isHidden = false
        if sender.tag  == 0{
            self.slideView.isHidden = true
            self.filterTableView.isHidden = false
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            self.slideSortView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideSortView)
            sender.tag = 1
        }
        else if sender.tag == 1{
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            self.slideSortView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideSortView)
            self.slideView.isHidden = true
            self.filterTableView.isHidden = true
            self.slideSortView.isHidden = true
             self.tableView.isHidden = true
            sender.tag = 0
        }
    }
    //MARK: sortAPIMethod Methods
    func sortAPIMethod(sortID : String){
        self.product.removeAll()
        self.data.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "category_id": categoryID,
            "sort_id": sortID
        ]
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/sort/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                for item in (response!.value(forKey: "cloths") as! NSArray) {
                    print(item)
                    
                    
                    self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image1") as! String), brand: "", wishlistID: "", cout: "1", sizeID: ""))
                    
                }
                DispatchQueue.main.async(execute: {
                    let transition = CATransition()
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionFromBottom
                    self.slideSortView.layer.add(transition, forKey: nil)
                    self.view .addSubview(self.slideSortView)
                    self.slideSortView.isHidden = true
                    self.tableView.isHidden = true
                    self.collectionView.reloadData()
                })
            }
        }

    }

    //MARK: TableView Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if tableView == self.tableView {
             return sortArr.count
        }
        else  if tableView == self.filterTableView {
             return price.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:CategoryTableViewCell?
        if tableView == self.tableView {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell!
            cell?.itemNameLabel.text = self.sortArr[indexPath.row]
        }
        
        if tableView == self.filterTableView {
            var priceCell:PriceTableViewCell?
            priceCell = self.filterTableView.dequeueReusableCell(withIdentifier: "rangeCell") as! PriceTableViewCell!
            priceCell?.rangeALabel.text = self.price[indexPath.row].range_a
            priceCell?.rangeBLabel.text = self.price[indexPath.row].range_b
             return priceCell!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            var priceCell:PriceTableViewCell?
           
            if indexPath.row == 0{
                 sortProductHighToLow()
                
            }
            if indexPath.row == 1{
                sortProductLowTOHigh()
            }
            if indexPath.row == 2{
                sortNewestProduct()
            }
//            priceCell?.selectImageView.image = UIImage (named: "check")
//            priceCell = self.filterTableView.dequeueReusableCell(withIdentifier: "rangeCell") as! PriceTableViewCell!
//            selectedSortIndex = (String)(indexPath.row)
//            sortAPIMethod(sortID: selectedSortIndex)
        }
        else if tableView == self.filterTableView {
//            var priceCell:PriceTableViewCell?
//            priceCell?.selectImageView.image = UIImage (named: "check")
//            priceCell = self.filterTableView.dequeueReusableCell(withIdentifier: "rangeCell") as! PriceTableViewCell!
//            self.filterByPrice(rangeID: self.price[indexPath.row].id)
            //sortedArray = self.product.filter($0.price as! Int < 1000)
            
            if indexPath.row == 0{
                
                sortedArray.removeAll()
                for i in 0 ..< product.count {
                    sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
                }
                
//                sortedArray = sortedArray.filter({
//                    $0.price > 1000
//                })
                print(sortedArray)
                let filtered = sortedArray.filter({ $0.price >= 1 && $0.price <= 1000 })
                print(filtered)
                sortedArray.removeAll()
                sortedArray = filtered
                check = true
                self.filterTableView.isHidden = true
                self.slideView.isHidden = true
                self.collectionView.reloadData()
            }
            if indexPath.row == 1{
                
                sortedArray.removeAll()
                for i in 0 ..< product.count {
                    sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
                }
                
                //                sortedArray = sortedArray.filter({
                //                    $0.price > 1000
                //                })
                print(sortedArray)
                let filtered = sortedArray.filter({ $0.price >= 1001 && $0.price <= 2000 })
                print(filtered)
                sortedArray.removeAll()
                sortedArray = filtered
                check = true
                self.filterTableView.isHidden = true
                self.slideView.isHidden = true
                self.collectionView.reloadData()
            }
            
            if indexPath.row == 2{
                
                sortedArray.removeAll()
                for i in 0 ..< product.count {
                    sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
                }
                
                //                sortedArray = sortedArray.filter({
                //                    $0.price > 1000
                //                })
                print(sortedArray)
                let filtered = sortedArray.filter({ $0.price >= 2001 && $0.price <= 5000 })
                print(filtered)
                sortedArray.removeAll()
                sortedArray = filtered
                check = true
                self.filterTableView.isHidden = true
                self.slideView.isHidden = true
                self.collectionView.reloadData()
            }
   
        }
    }
    
    //MARK: sortProductLowTOHigh in low to high order
    func sortProductLowTOHigh(){
     
        sortedArray.removeAll()
        for i in 0 ..< product.count {
            sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
        }
        
       print(sortedArray)
        self.slideSortView.isHidden = true
        self.tableView.isHidden = true
        sortedArray = sortedArray.sorted(by: {$0.price < $1.price})
        print(sortedArray)
        if sortedArray.count >  0{
            check = true
            self.collectionView.reloadData()
        }
        else {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Data not found!")
        }
    }
    //MARK: sortProductLowTOHigh in low to high order
    func sortProductHighToLow(){
        
        sortedArray.removeAll()
        for i in 0 ..< product.count {
            sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
        }
        
        print(sortedArray)
        self.slideSortView.isHidden = true
        self.tableView.isHidden = true
        sortedArray = sortedArray.sorted(by: {$0.price > $1.price})
        print(sortedArray)
        check = true
        self.collectionView.reloadData()
    }
    
    //MARK: newest product
    func sortNewestProduct(){
        
        sortedArray.removeAll()
        for i in 0 ..< product.count {
            sortedArray.append(Product.init(price: Double(product[i].price)!, name:  product[i].name, id: product[i].id, image: product[i].image, oldPrice: product[i].oldPrice, brand: product[i].brand, wishlistID: product[i].wishlistID))
        }
        
        print(sortedArray)
        self.slideSortView.isHidden = true
        self.tableView.isHidden = true
        sortedArray = sortedArray.sorted(by: {$0.id < $1.id})
        print(sortedArray)
        check = true
        self.collectionView.reloadData()
    }
    
    
    
    //MARK: filterByPrice Methods
    func filterByPrice(rangeID : String){
        
        self.product.removeAll()
        self.data.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "range_id": rangeID
            ]
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getbycategory/\(categoryID)/ZWNvbW1lcmNl/", parameters: parameters,headers:nil) { (response:NSDictionary?, error:NSError?) in
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
                if ((response!.value(forKey: "cloths") != nil) ){
                    
                    for item in (response!.value(forKey: "cloths") as! NSArray) {
                        print(item)
                        
                        self.data.append(((item as! NSDictionary).value(forKey: "title") as! String))
                        
                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image") as! String), brand: "", wishlistID: "", cout: "1", sizeID: ""))
                        
                    }
                    DispatchQueue.main.async(execute: {
                        let transition = CATransition()
                        transition.type = kCATransitionPush
                        transition.subtype = kCATransitionFromRight
                        self.slideView.layer.add(transition, forKey: nil)
                        self.view .addSubview(self.slideView)
                        self.slideView.isHidden = true
                        self.filterTableView.isHidden = true
                        self.collectionView.reloadData()
                    })
                }
                else {
                    self.showAlert(msg:(response!.value(forKey: "message") as! String))
                }
            }
        }
    }
        
  
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async(execute: {
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.slideView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideView)
            self.slideView.isHidden = true
            self.filterTableView.isHidden = true
            self.collectionView.reloadData()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnFilter(_ sender: UIButton) {
        self.tableView.isHidden = true
       // if sender.tag  == 0{
            self.slideView.isHidden = false
            self.filterTableView.isHidden = false
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            self.slideView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideView)
//            sender.tag = 1
//        }
//        else if sender.tag == 1{
//            let transition = CATransition()
//            transition.type = kCATransitionPush
//            transition.subtype = kCATransitionFromBottom
//            self.slideView.layer.add(transition, forKey: nil)
//            self.view .addSubview(self.slideView)
//            self.slideView.isHidden = true
//            self.filterTableView.isHidden = true
//            self.collectionView.reloadData()
//            sender.tag = 0
//        }
    }
    //MARK: getProductAPI Methods
//    func getPriceAPI() {
//
//        let requestString = "http://kftsoftwares.com/ecom/recipes/getpricerange/ZWNvbW1lcmNl/"
//        Alamofire.request(requestString,method: .post, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
//
//            switch(response.result) {
//            case .success(_):
//                DispatchQueue.main.async(execute: {
//                  //  SKActivityIndicator.dismiss()
//                })
//                if response.result.value != nil{
//
//                    let product = response.result.value as! NSDictionary
//                    for item in ((product ).value(forKey: "Price_range") as! NSArray) {
//                        print(item)
//
//
//                        self.price.append(getPrice.init(id: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "id") as! String, range_a: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "range_a") as! String, range_b: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "range_b") as! String))
//
//                    }
//
//                    DispatchQueue.main.async(execute: {
//                        self.filterTableView.reloadData()
//                    })
//
//                }
//                break
//
//            case .failure(_):
//                print("Failure : \(String(describing: response.result.error))")
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                break
//
//            }
//        }
//    }
    //MARK: getPriceAPI Methods
    func getPriceAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getPriceRange/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if ((response!.value(forKey: "Price_range") != nil) ){
                
                for item in (response!.value(forKey: "Price_range") as! NSArray) {
                    print(item)
                    
                    self.price.append(getPrice.init(id: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "id") as! String, range_a: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "range_a") as! String, range_b: ((item as! NSDictionary).value(forKey: "Price") as! NSDictionary).value(forKey: "range_b") as! String))
                }
                
                DispatchQueue.main.async(execute: {
                    self.filterTableView.reloadData()
                })
                DispatchQueue.main.async(execute: {
                    let transition = CATransition()
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionFromBottom
                    self.slideView.layer.add(transition, forKey: nil)
                    self.view .addSubview(self.slideView)
                    self.slideView.isHidden = true
                    self.filterTableView.isHidden = true
                    self.collectionView.reloadData()
                })
            }
           
        }
    }
    
}

