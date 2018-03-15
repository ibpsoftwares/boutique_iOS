//
//  HomeViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//


//https://www.myntra.com/my/orders

import UIKit
import CLabsImageSlider
import Alamofire
import Kingfisher
import SKActivityIndicatorView
import CoreData

class getProduct {
    var name: String
    var price: String
    var image: String
    var id : String
    var oldPrice : String
    var brandName : String
    var wishlistID : String
    init(name: String,price: String,image: String,id: String,oldPrice: String,brandName: String,wishlistID : String) {
        self.name = name
        self.price = price
        self.image = image
        self.id = id
         self.oldPrice = oldPrice
         self.brandName = brandName
        self.wishlistID = wishlistID
    }
}
@available(iOS 10.0, *)
class HomeViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,imageSliderDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var wishlistCountLabel: UILabel!
     @IBOutlet weak var imgSlider: CLabsImageSlider!
     @IBOutlet weak var pageControl : UIPageControl!
    var screenheight : CGFloat!
    var product = [getProduct]()
    var productlocal = [getProduct]()
    
    var saveProductData = [localDatabase]()
    //let urlImages = [String]()
    var wishListProduct = [getProductDetail]()
    var cartProduct = [getProductDetail]()
    var seletedIndex = NSInteger()
//    var urlImages = ["http://www.kavyaboutique.in/images/contact-us.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    var localImages =   ["one","two","three","four","five","six"]
    var urlImages = [String]()
    var wishlist: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()

       Model.sharedInstance.lacalDataArr.removeAllObjects()
        
        //Getting user defaults
        let defaults = UserDefaults.standard
        
        //Checking if the data exists
        if defaults.data(forKey: "myKey") != nil {
            
            //Removing the Data
            defaults.removeObject(forKey: "myKey")
            
        }
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       // width = width - 10
        layout.itemSize = CGSize(width: width / 2 , height:290)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.collectionViewLayout = layout
       
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        
       // tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        //tableView.tableFooterView = UIView()
        //filterTableView.tableFooterView = UIView()
       // self.getProductAPI()
        self.screenheight = self.view.frame.size.width
        imgSlider.sliderDelegate   =   self
        //configurePageControl()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
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
            self.productlocal.append(getProduct.init(name: (person.value(forKeyPath: "name") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String) , id:  (person.value(forKeyPath: "id") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brandName: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String))
         }
        }
        self.wishlistCountLabel.layer.cornerRadius = self.wishlistCountLabel.frame.size.height / 2
        self.wishlistCountLabel.clipsToBounds = true
        getProductAPI()
        getCartViewAPI()
         getProductImages()
        self.wishListProduct.removeAll()
        getWishListAPI()
    }
   
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = localImages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        
        
        getProductImages()
       // self.getProductAPI()
    }
    //MARK: getCartViewAPI Methods
//    func getCartViewAPI(){
//
//        self.cartProduct.removeAll()
//        //SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        //SKActivityIndicator.show("Loading...")
//
//        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                return
//            }
//            DispatchQueue.main.async(execute: {
//                //SKActivityIndicator.dismiss()
//            })
//            print(response!)
//            if ((response!["message"] as? [String:Any]) != nil){
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
//            else{
//
//                if ((response!.value(forKey: "items") != nil) ){
//
//                    for item in ((response)?.value(forKey: "items") as! NSArray) {
//                        print(item)
//
//                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1"))
//                    }
//
//                    self.wishlistCountLabel.text  = (String)(self.cartProduct.count)
//                }
//            }
//        }
//    }
    
    
    //MARK: getCartViewAPI Methods
    func getCartViewAPI(){
        self.cartProduct.removeAll()
               var parameter: Parameters = [:]
                if Model.sharedInstance.userID != "" {
                    parameter = ["user_id": Model.sharedInstance.userID]
                }
                else{
                    parameter = ["user_id":""]
                }
        
          print(parameter)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewCart/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                 self.wishlistCountLabel.isHidden = true
            }
            else{
                if ((response!.value(forKey: "items") != nil) ){
                    
                    for item in ((response)?.value(forKey: "items") as! NSArray) {
                        print(item)
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1"))
                    }
                    
                    self.wishlistCountLabel.text  = (String)(self.cartProduct.count)
                }
            }
        })
    }
    //MARK: getProductImages Methods
    func getProductImages (){
//        var parameter: Parameters = [:]
//
//        if Model.sharedInstance.userID != "" {
//            parameter = ["user_id": Model.sharedInstance.userID]
//        }
//        else{
//            parameter = ["user_id":""]
//        }
        
      //  print(parameter)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getBannerImages", parameters:nil, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
          //  print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{

                for item in (response?.value(forKey: "bannerImages") as! NSArray) {
                   // print(item)

                    self.urlImages.append(((item as! NSDictionary).value(forKey: "image") as! String))
                }

                print(self.urlImages)
                DispatchQueue.main.async(execute: {
                    //self.imgSlider.setUpView(imageSource: .Url(imageArray: self.localImages, placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)

                    self.imgSlider.setUpView(imageSource: .Url(imageArray: self.urlImages , placeHolderImage: UIImage (named: "placeHolder")), slideType: .Automatic(timeIntervalinSeconds: 2.0), isArrowBtnEnabled: true)
                    print(self.localImages.count)
                })
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        
        //imgSlider.setUpView(imageSource: .Local(imageArray: localImages),slideType: .ManualSwipe,isArrowBtnEnabled: true)
        //imgSlider.setUpView(imageSource: .Url(imageArray: urlImages, placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)
        // self.imgSlider.setUpView(imageSource: .Url(imageArray: self.localImages, placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)
    }
    
    func didMovedToIndex(index:Int)
    {
       // print("did moved at Index : ",index)
        // pageControl.currentPage = Int(index)
    }
 //MARK: getProductAPI Methods
    func getProductAPI (){
        
        self.product.removeAll()
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
        
        Webservice.apiPost(serviceName:"http://kftsoftwares.com/ecom/recipes/getAllCloths/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
                for item in (response?.value(forKey: "data1") as! NSArray) {
                    print(item)

                    if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                        print("empty")
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: "", brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String)))
                    }
                    else {
                        print("not null")
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String)))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                   // self.collectionView.reloadData()
                    
                })
                 if Model.sharedInstance.userID == "" {
                
                if self.product.count > 0{
                    for row in 0...self.product.count - 1{
                        
                        if self.product.count <= self.productlocal.count {
                            print("index :\(row)")
                        }
                        else{
                            self.productlocal.append(getProduct.init(name: "", price: "" , image: "" , id:  "", oldPrice: "", brandName: "", wishlistID: ""))
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
                
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                    self.insertElementAtIndex()
//                    self.collectionView.reloadData()
//
//                })
            }
        })
    }
    
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.count
       // return imgArr.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
   
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        cell.layer.borderWidth = 0.5
        
          //let id = self.product[indexPath.row].id
        if Model.sharedInstance.userID != "" {
          
//            let indexes = product.enumerated().filter {
//                $0.element.id.contains( productlocal[indexPath.row].id)
//                }.map{$0.offset}
//
//            print(indexes)
//
//
//             for item in indexes
//             {
//                if indexPath.item == item{
//
//                    cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
//                }
//
////                print(item)
////                let str : String = String(item)
////                print(str)
////            if (product[indexPath.row].id == str) {
////                cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
////            }
//            else{
//                cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
//            }
//
//
//            }
//            if product.contains( where: { $0.id == productlocal[indexPath.row].id}){
//             //if product[indexPath.row].id == productlocal[indexPath.row].id{
//                print("Object Added")
//                cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
//
//
//            } else {
//
//                print("Object already exists")
//               cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
//
//
//            }
       // }
            //}
//            for row in 0...wishlist.count - 1{
//                let person = wishlist[row]
//             let clothID: String? = person.value(forKeyPath: "id") as? String
//            if product.contains(where: { $0.id == clothID! }) {
//                cell.productImg.backgroundColor = UIColor.red
//            } else {
//               cell.productImg.backgroundColor = UIColor.green
//            }
//            }
            
            
            //for section in 0...product.count - 1 {
//                for row in 0...wishlist.count - 1{
//                    let person = wishlist[row]
//                   // print(person)
//                    let clothID: String? = person.value(forKeyPath: "id") as? String
//                   // print(clothID!)
//                   // print(self.product[indexPath.row].id)
//                        if id == clothID{
//                        print("Section: match found")
//                         cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
//                          cell.productImg.backgroundColor = UIColor.red
//                    }
//                    else{
//                        print("Section: match not found")
//
//                        cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
//                          cell.productImg.backgroundColor = UIColor.green
//                    }
//
//                }
           // }

       // }
//        else{
//
        }
        
        cell.productNameLabel.text = self.product[indexPath.row].name
        cell.originalPriceLabel.text = "$\(self.product[indexPath.row].price)"

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
       
        cell.brandNameLabel.text = self.product[indexPath.row].brandName
        let url = URL(string: self.product[indexPath.row].image)
        cell.productImg.kf.indicatorType = .activity
        cell.productImg.kf.setImage(with: url,placeholder: nil)

        cell.wishlistBtn.tag = indexPath.row
        cell.wishlistBtn.addTarget(self,action:#selector(addToWishListAPI(sender:)), for: .touchUpInside)
        
        return cell
    }
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailVC.productID = self.product[indexPath.row].id
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    @IBAction func cartBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }
   
   
    
//    @objc func addToWishListAPI(sender:UIButton!){
//
//        let parameter: Parameters = [
//            "user_id": Model.sharedInstance.userID,
//            "cloth_id": self.product[sender.tag].id
//        ]
//        if sender.imageView?.image == UIImage (named: "emptyWishlist")
//        {
////        SKActivityIndicator.spinnerColor(UIColor.darkGray)
////        SKActivityIndicator.show("Loading...")
//
//        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                return
//            }
//            DispatchQueue.main.async(execute: {
//             //   SKActivityIndicator.dismiss()
//            })
//            sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
//            print(response!)
//            if ((response!["message"] as? [String:Any]) != nil){
//                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
//            else{
//                self.getWishListAPI()
//               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
//         }
//        }
//        else  if sender.imageView?.image == UIImage (named: "heart") {
//
////            SKActivityIndicator.spinnerColor(UIColor.darkGray)
////            SKActivityIndicator.show("Loading...")
//
//            Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/rmwishlist/ZWNvbW1lcmNl/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//                  //  Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                  //  SKActivityIndicator.dismiss()
//                })
//                print(response!)
//                sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
//                if ((response!["message"] as? [String:Any]) != nil){
//                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//                }
//                else{
//                    self.getWishListAPI()
//                  //  Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//                }
//            }
//        }
//    }
    
    @available(iOS 10.0, *)
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
        person.setValue(self.product[seletedIndex].brandName, forKeyPath: "brand")
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
    
    
    
    
    //MARK: addToWishListAPI Methods
    @objc func addToWishListAPI(sender:UIButton!){
        
        seletedIndex = sender.tag
        var parameter: Parameters = [:]
        
        if Model.sharedInstance.userID == "" {
            //saveData()
           /// parameter = [
//                "user_id": Model.sharedInstance.userID,
//                "cloth_id": (self.product[sender.tag].id)
                 //   ]
            
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
                
//                let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//                let context = appDel.persistentContainer.viewContext
//                let index = sender.tag
//
//                context.delete(self.wishlist[index] as NSManagedObject)
//                self.wishlist.remove(at: index)
//
//                let _ : NSError! = nil
//                do {
//                    try context.save()
//                    self.tableView.reloadData()
//                } catch {
//                    print("error : \(error)")
//                }
                
                
                
                
                
                
                
//                Model.sharedInstance.lacalDataArr.remove(seletedIndex)
//                //Encoding array
//                let encodedArray : NSData = NSKeyedArchiver.archivedData(withRootObject:  Model.sharedInstance.lacalDataArr) as NSData
//
//                //Saving
//                let defaults = UserDefaults.standard
//                defaults.setValue(encodedArray, forKey:"myKey")
//                defaults.synchronize()
            }
            
        }
//        else{
//            parameter = ["user_id":""]
//
//            if sender.imageView?.image == UIImage (named: "emptyWishlist")
//            {
//                //saveData()
//                if #available(iOS 10.0, *) {
//                    save()
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//            else  if sender.imageView?.image == UIImage (named: "heart") {
//
//                self.product[sender.tag].wishlistID = "0"
//
//         }
//        }
//
//        print(parameter)
//
//        if sender.imageView?.image == UIImage (named: "emptyWishlist")
//        {
//
//            Webservice.apiPost(serviceName:"http://kftsoftwares.com/ecom/recipes/addToWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                print(response!)
//                if ((response!["message"] as? [String:Any]) != nil){
//                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//                }
//                else{
//                    sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
//                    self.getWishListAPI()
//
//                }
//            })
//        }
//        else  if sender.imageView?.image == UIImage (named: "heart") {
//
//            //            SKActivityIndicator.spinnerColor(UIColor.darkGray)
//            //            SKActivityIndicator.show("Loading...")
//
//            print(parameter)
//            Webservice.apiPost(serviceName:"http://kftsoftwares.com/ecom/recipes/rmWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                print(response!)
//                if ((response!["message"] as? [String:Any]) != nil){
//                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//                }
//                else{
//                    sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
//                    self.getWishListAPI()
//
//                }
//            })
//
//        }
    }
    
  
    //MARK: getWishListAPI Methods
    func getWishListAPI (){
        self.wishListProduct.removeAll()
        //SKActivityIndicator.spinnerColor(UIColor.darkGray)
        //SKActivityIndicator.show("Loading...")
        var parameter: Parameters = [:]
        
        if Model.sharedInstance.userID != "" {
            parameter = ["user_id": Model.sharedInstance.userID]
        }
        else{
            parameter = ["user_id":""]
        }
        
        print(parameter)
        
        Webservice.apiPost(serviceName:"http://kftsoftwares.com/ecom/recipes/viewWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                //SKActivityIndicator.dismiss()
            })
            print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                
                if ((response!.value(forKey: "Wishlist") != nil) ){
                
                for item in (response!.value(forKey: "Wishlist") as! NSArray) {
                    print(item)
                    
                    self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1"))
                }
                
                Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
                if self.wishListProduct.count > 0 {
                    
                    let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabItems![4] as! UITabBarItem
                    tabItem.badgeValue = Model.sharedInstance.badgeValue
                }
                
                for var i in (0..<(self.wishListProduct.count)){
                    let total = (Int)(self.wishListProduct[i].price)!
                    print(total)
                    
                }
                DispatchQueue.main.async(execute: {
                    // self.tableView.reloadData()
                })
            }
                else{
                print("no data...")
                    let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabItems![4] as! UITabBarItem
                    tabItem.badgeValue = nil
                }
            }
        })
    }
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        self.getWishListAPI()
        self.present(alert, animated: true, completion: nil)
    }
}
 



