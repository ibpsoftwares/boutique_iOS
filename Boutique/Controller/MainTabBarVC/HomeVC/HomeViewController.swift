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
     var sizeID : String
     var currency : String
    var categoryID : String
    var stock : String
    var sizeArr : NSArray
    init(name: String,price: String,image: String,id: String,oldPrice: String,brandName: String,wishlistID : String,sizeID : String,currency : String,categoryID: String,stock:String,sizeArr : NSArray) {
        self.name = name
        self.price = price
        self.image = image
        self.id = id
         self.oldPrice = oldPrice
         self.brandName = brandName
        self.wishlistID = wishlistID
        self.sizeID = sizeID
        self.currency = currency
        self.categoryID = categoryID
        self.stock = stock
        self.sizeArr = sizeArr
    }
}
class getoffer1 {
    var image: String
    var id: String
    
    init(image: String,id: String) {
        self.image = image
        self.id = id
        
    }
}
class getoffer2 {
    var image: String
    var id: String
    
    init(image: String,id: String) {
        self.image = image
        self.id = id
        
    }
}
@available(iOS 10.0, *)
class HomeViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,imageSliderDelegate{

    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet var collectionViewHeight1: NSLayoutConstraint!
    @IBOutlet weak var slideCollectionView: UICollectionView!
     @IBOutlet weak var slideCollectionView1: UICollectionView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var wishlistCountLabel: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
     @IBOutlet weak var bannerImg1: UIImageView!
    @IBOutlet weak var imgSlider: CLabsImageSlider!
    @IBOutlet weak var pageControl : UIPageControl!
    var screenheight : CGFloat!
    var product = [getProduct]()
    var emptyArray: NSArray! = []
    var product1 = [getProduct]()
    var product2 = [getProduct]()
    var productlocal = [getProduct]()
    var imgArr = [getoffer1]()
    var imgArr1 = [getoffer2]()
    var cartlist: [NSManagedObject] = []
    var saveProductData = [localDatabase]()
    //let urlImages = [String]()
    var wishListProduct = [getProductDetail]()
    var cartProduct = [getProductDetail]()
    var seletedIndex = NSInteger()
    var localImages =   ["one","two","three","four","five","six"]
    var imagesArray =   ["text1","tst1","tst2","tst3"]
    var urlImages = [String]()
    var wishlist: [NSManagedObject] = []
    var currency = String()
    private var cache = [UICollectionViewLayoutAttributes]()
    override func viewDidLoad() {
        super.viewDidLoad()

       Model.sharedInstance.lacalDataArr.removeAllObjects()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        var width = UIScreen.main.bounds.width
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//       // width = width - 10
//
//        layout.itemSize = CGSize(width: width / 2 , height:290)
//         self.collectionView.collectionViewLayout = layout
//         self.collectionView1.collectionViewLayout = layout
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
       
        self.collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        self.collectionView1.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
         self.slideCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        self.slideCollectionView.reloadData()
        self.slideCollectionView1.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        self.slideCollectionView1.reloadData()
      
        self.screenheight = self.view.frame.size.width
        imgSlider.sliderDelegate   =   self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        cache.removeAll()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView1.reloadData()
        collectionView1.collectionViewLayout.invalidateLayout()
        self.productlocal.removeAll()
        self.wishListProduct.removeAll()
        self.wishlist.removeAll()
        if Model.sharedInstance.userID != ""{
            //loginBtn.isHidden = true
            getCartViewAPI()
            getWishListAPI()
        }
        else{
            wishlistFromLocalDatabase()
            fetchCartData()
        }
        self.wishlistCountLabel.layer.cornerRadius = self.wishlistCountLabel.frame.size.height / 2
        self.wishlistCountLabel.clipsToBounds = true
         getProductImages()
        self.wishListProduct.removeAll()
        getProductAPI()
        
    }
   
    //MARK: Fetch Cart Data From Core Data
    func fetchCartData(){
        self.cartProduct.removeAll()
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
            self.wishlistCountLabel.isHidden  = false
            self.wishlistCountLabel.text  = (String)(self.cartlist.count)
            for row in 0...cartlist.count - 1{
                let person = cartlist[row]
                if (person.value(forKeyPath: "name") as! String) == ""{
                    
                }else{
                    self.cartProduct.append(getProductDetail.init(name: (person.value(forKeyPath: "name") as! String), id:  (person.value(forKeyPath: "id") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brand: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, cout: "1", sizeID: (person.value(forKeyPath: "size") as! String), categoryID: (person.value(forKeyPath: "categoryID") as! String), stock: (person.value(forKeyPath: "stock") as! String), clothID: ""))
                }
            }
        }
        else{
            print("no data...")
            self.wishlistCountLabel.isHidden  = true
        }
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
            for row in 0...self.wishlist.count - 1{
                let person = self.wishlist[row]
                self.productlocal.append(getProduct.init(name: (person.value(forKeyPath: "name") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String) , id:  (person.value(forKeyPath: "id") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brandName: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, sizeID: "", currency: "", categoryID: "", stock: "", sizeArr: emptyArray))
            }
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems![3] as! UITabBarItem
            tabItem.badgeValue = String(wishlist.count)
        }
        else{
            print("no data...")
            let tabItems = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabItems![3] as! UITabBarItem
            tabItem.badgeValue = nil
        }
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
        
        Webservice.apiPost(apiURl: "ViewCart/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                 self.wishlistCountLabel.isHidden = true
            }
            else{
                if ((response!.value(forKey: "items") != nil) ){
                    
                    for item in ((response)?.value(forKey: "items") as! NSArray) {
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1", sizeID: "", categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), stock: ((item as! NSDictionary).value(forKey: "stock") as! String), clothID: ((item as! NSDictionary).value(forKey: "cloth_id") as! String)))
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
        self.imgArr.removeAll()
        self.imgArr1.removeAll()
        Webservice.apiPost(apiURl: "getBannerImages", parameters:nil, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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

                let url = URL(string: ((response as! NSDictionary).value(forKey: "bannerImages") as! String))
                self.bannerImg.kf.indicatorType = .activity
                self.bannerImg.kf.setImage(with: url,placeholder: nil)
                //self.bannerImg1.kf.indicatorType = .activity
                //self.bannerImg1.kf.setImage(with: url,placeholder: nil)
                
                for item in (response?.value(forKey: "offer1") as! NSArray) {

                    self.imgArr.append(getoffer1.init(image: ((item as! NSDictionary).value(forKey: "image") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String)))
                   // self.urlImages.append(((item as! NSDictionary).value(forKey: "image") as! String))
                }

                for item in (response?.value(forKey: "offer2") as! NSArray) {
                    self.imgArr1.append(getoffer2.init(image: ((item as! NSDictionary).value(forKey: "image") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String)))
                }
                DispatchQueue.main.async(execute: {
                    //self.imgSlider.setUpView(imageSource: .Url(imageArray: self.localImages, placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)

                    self.slideCollectionView.reloadData()
                    self.slideCollectionView1.reloadData()
                    //self.imgSlider.setUpView(imageSource: .Url(imageArray: self.urlImages , placeHolderImage: UIImage (named: "placeHolder")), slideType: .Automatic(timeIntervalinSeconds: 2.0), isArrowBtnEnabled: true)
                    //print(self.localImages.count)
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
        self.product1.removeAll()
        self.product2.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        var parameter: Parameters = [:]
        
        if Model.sharedInstance.userID != "" {
            parameter = ["user_id": Model.sharedInstance.userID]
        }
        print(parameter)
        
        Webservice.apiPost(apiURl:"getAllCloths", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
          
            print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                if ((response!.value(forKey: "data1") != nil) ){
                for item in (response?.value(forKey: "data1") as! NSArray) {
                    
                    if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                       // print("empty")
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: "", brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String), sizeID: "", currency: ((item as! NSDictionary).value(forKey: "symbol") as! String), categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), stock: ((item as! NSDictionary).value(forKey: "total_stock") as! String), sizeArr: ((item as! NSDictionary).value(forKey: "size") as! NSArray)))
                    }
                    else {
                       // print("not null")
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "wishlist") as! String), sizeID: "", currency: ((item as! NSDictionary).value(forKey: "symbol") as! String), categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), stock: ((item as! NSDictionary).value(forKey: "total_stock") as! String), sizeArr: ((item as! NSDictionary).value(forKey: "size") as! NSArray)))
                    }
                    }
              
                    if Model.sharedInstance.userID == "" {
                        
                        if self.product.count > 0{
                            for row in 0...self.product.count - 1{
                                
                                if self.product.count <= self.productlocal.count {
                                    print("index :\(row)")
                                }
                                else{
                                    self.productlocal.append(getProduct.init(name: "", price: "" , image: "" , id:  "", oldPrice: "", brandName: "", wishlistID: "", sizeID: "", currency: "", categoryID: "", stock: "", sizeArr: self.emptyArray ))
                                }
                            }
                        }
                    
                    for section in 0...self.product.count - 1 {
                        
                        if let i = self.product.index(where: { $0.id == self.productlocal[section].id }) {
                            self.product[i].wishlistID = "1"
                            // return i
                           // print("Section: match found")
                        }
                        else{
                           // print("Section: match not found")
                        }
                    }
                }
                // split array into diff. category
                if self.product.count > 0{
                    for row in 0...self.product.count - 1{
                        
                        if row <= 5 {
                            self.product1.append(getProduct.init(name: self.product[row].name, price: self.product[row].price , image: self.product[row].image , id:  self.product[row].id, oldPrice: self.product[row].oldPrice, brandName: self.product[row].brandName, wishlistID: self.product[row].wishlistID, sizeID: "", currency: self.product[row].currency, categoryID: self.product[row].categoryID, stock: self.product[row].stock, sizeArr: self.product[row].sizeArr))
                        }
                        else{
                            self.product2.append(getProduct.init(name: self.product[row].name, price: self.product[row].price , image: self.product[row].image , id:  self.product[row].id, oldPrice: self.product[row].oldPrice, brandName: self.product[row].brandName, wishlistID: self.product[row].wishlistID, sizeID: "", currency: self.product[row].currency, categoryID: self.product[row].categoryID, stock: self.product[row].stock, sizeArr: self.product[row].sizeArr))
                        }
                    }
                }
              
                    // for cartdataLocal
                    if self.cartProduct.count > 0 {
                     for section in 0...self.cartProduct.count - 1 {
                        
                        for row in 0...self.product.count - 1 {
                            
                            if self.cartProduct[section].id == self.product[row].id{
                            
                           print(self.product[row].sizeArr)
                                for item in self.product[row].sizeArr {
                                    if (item as! NSDictionary).value(forKey: "size") as! String == self.cartProduct[section].sizeID {

                                        
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        let context = appDelegate.persistentContainer.viewContext
                                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cartlist")
                                        
                                      
                                        do {
                                            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                                            if results?.count != 0 { // Atleast one was returned
                                                
                                                // In my case, I only updated the first item in results
                                                results![section].setValue((item as! NSDictionary).value(forKey: "stock") as! String, forKey: "stock")
                                            }
                                        } catch {
                                            print("Fetch Failed: \(error)")
                                        }
                                        
                                        do {
                                            try context.save()
                                        }
                                        catch {
                                            print("Saving Core Data Failed: \(error)")
                                        }
                                    }
                                   //break;
                                }
                                
                            //print("match found")
                             
                            }else{
                               //  print(" not match found")
                            }
                            
                        }
                    
                    }
                    
                    }
                    // self.fetchCartData()
            
                DispatchQueue.main.async(execute: {
                   
                    let int: Int32 = Int32((self.product1.count) * 290 / 2 )
                    let cgfloat = CGFloat(int)
                    print(cgfloat)
                    let int1: Int32 = Int32((self.product2.count) * 290 / 2 )
                    let cgfloat1 = CGFloat(int1)
                    print(cgfloat1)
                    self.collectionViewHeight.constant = cgfloat + 15
                    self.collectionViewHeight1.constant = cgfloat1 + 220
                    self.collectionView1.reloadData()
                   self.collectionView.reloadData()
                    DispatchQueue.main.async(execute: {
                        SKActivityIndicator.dismiss()
                    })
                   // self.collectionView.collectionViewLayout.invalidateLayout()
                   // self.collectionView1.collectionViewLayout.invalidateLayout()
                })
            }
        else{
             Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
         }
            }
        })
    }
    
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return self.product1.count
        }
        else if collectionView == self.slideCollectionView {
            return self.imgArr.count
        }
        else if collectionView == self.collectionView1 {
            return self.product2.count
        }
        else if collectionView == self.slideCollectionView1 {
            return self.imgArr1.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
        
        if(collectionView == self.collectionView)
        {
                    cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
                    cell.backgroundColor = UIColor.white
                    cell.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
                    cell.layer.borderWidth = 0.5
                    let url = URL(string: self.product1[indexPath.row].image)
                    cell.productImg.kf.indicatorType = .activity
                    cell.productImg.kf.setImage(with: url,placeholder: UIImage(named: "placeHolder"))
            
                    cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product1[indexPath.row].oldPrice)"
                    var curr = String()
                    curr = self.product1[indexPath.row].currency
            
                    cell.currencyLabel.attributedText = NSAttributedString(html: "<span>\(curr)</span>")
                    Model.sharedInstance.currency = cell.currencyLabel.text!
                   // print(Model.sharedInstance.currency)
                    if self.product1[indexPath.row].stock == "0"{
                        cell.stockImg.isHidden = false
                    }else{
                        cell.stockImg.isHidden = true
                    }
            
                    if  self.product1[indexPath.row].oldPrice != "" {
                        cell.oldPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product1[indexPath.row].price)"
                        cell.crossLabel.isHidden = false
                    }
                    else{
                        cell.oldPriceLabel.isHidden = true
                        cell.crossLabel.isHidden = true
                        cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product1[indexPath.row].price)"
                    }
            
                    if self.product1[indexPath.row].wishlistID == "1"
                    {
                        cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
                    }
                    else{
            
                        cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
                    }
            
                    cell.brandNameLabel.text = self.product1[indexPath.row].name
            
            
                    cell.wishlistBtn.tag = indexPath.row
                    cell.wishlistBtn.addTarget(self,action:#selector(addToWishListAPI(sender:)), for: .touchUpInside)
        }
        else if(collectionView == self.slideCollectionView){
                 let cell : AddBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! AddBannerCollectionViewCell
                let url = URL(string: self.imgArr[indexPath.row].image)
                cell.recipeImg.kf.indicatorType = .activity
                cell.recipeImg.kf.setImage(with: url,placeholder: UIImage(named: "placeHolder"))
                return cell
        }
        else if(collectionView == self.slideCollectionView1){
            let cell : AddBannerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! AddBannerCollectionViewCell
            let url = URL(string: self.imgArr1[indexPath.row].image)
            cell.recipeImg.kf.indicatorType = .activity
            cell.recipeImg.kf.setImage(with: url,placeholder: UIImage(named: "placeHolder"))
            return cell
        }
        else if(collectionView == self.collectionView1){
           let cell : HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
            cell.backgroundColor = UIColor.white
            cell.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
            cell.layer.borderWidth = 0.5
            let url = URL(string: self.product2[indexPath.row].image)
            cell.productImg.kf.indicatorType = .activity
            cell.productImg.kf.setImage(with: url,placeholder: UIImage(named: "placeHolder"))

            cell.productNameLabel.text = self.product2[indexPath.row].name
            cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product2[indexPath.row].oldPrice)"
            var curr = String()
            curr = self.product2[indexPath.row].currency

            cell.currencyLabel.attributedText = NSAttributedString(html: "<span>\(curr)</span>")
            Model.sharedInstance.currency = cell.currencyLabel.text!
            //print(Model.sharedInstance.currency)

            if  self.product2[indexPath.row].oldPrice != "" {
                cell.oldPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product2[indexPath.row].price)"
                cell.crossLabel.isHidden = false
            }
            else{
                cell.oldPriceLabel.isHidden = true
                cell.crossLabel.isHidden = true
                cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product2[indexPath.row].price)"
            }

            if self.product2[indexPath.row].wishlistID == "1"
            {
                cell.wishlistBtn.setImage(UIImage (named: "heart"), for: .normal)
            }
            else{

                cell.wishlistBtn.setImage(UIImage (named: "emptyWishlist"), for: .normal)
            }
            if self.product2[indexPath.row].stock == "0"{
                cell.stockImg.isHidden = false
            }else{
                 cell.stockImg.isHidden = true
            }
            cell.brandNameLabel.text = self.product2[indexPath.row].brandName
            cell.wishlistBtn.tag = indexPath.row
            cell.wishlistBtn.addTarget(self,action:#selector(addToWishListAPI(sender:)), for: .touchUpInside)
            return cell
        }
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView ==  slideCollectionView{
            return CGSize(width:150 , height:150)
        }
        else if collectionView ==  slideCollectionView1{
            return CGSize(width:150 , height:150)
        }
        return CGSize(width:view.frame.width / 2 , height:290)
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

        if collectionView ==  slideCollectionView{
            return CGSize(width:150 , height:150)
        }
        else if collectionView ==  slideCollectionView1{
            return CGSize(width:150 , height:150)
        }
        return CGSize(width: view.frame.width / 2, height: 290 + 10)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        let sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        return sectionInset
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         if(collectionView == self.collectionView){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.productID = self.product1[indexPath.row].id
            productDetailVC.passDict.setValue(self.product1[indexPath.row].id, forKey: "id")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].name, forKey: "name")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].price, forKey: "price")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].image, forKey: "image")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].brandName, forKey: "brand")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].oldPrice, forKey: "oldPrice")
            productDetailVC.passDict.setValue(self.product1[indexPath.row].categoryID, forKey: "categoryID")
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
         else if(collectionView == self.collectionView1){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            productDetailVC.productID = self.product2[indexPath.row].id
            productDetailVC.passDict.setValue(self.product2[indexPath.row].id, forKey: "id")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].name, forKey: "name")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].price, forKey: "price")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].image, forKey: "image")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].brandName, forKey: "brand")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].oldPrice, forKey: "oldPrice")
            productDetailVC.passDict.setValue(self.product2[indexPath.row].categoryID, forKey: "categoryID")
            navigationController?.pushViewController(productDetailVC, animated: true)
         }
        else if(collectionView == self.slideCollectionView){
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            categoryViewController.checkStr = "true"
            categoryViewController.offerID = imgArr[indexPath.row].id
            navigationController?.pushViewController(categoryViewController, animated: true)
        }
         else if(collectionView == self.slideCollectionView1){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            categoryViewController.checkStr = "true"
            categoryViewController.offerID = imgArr1[indexPath.row].id
            navigationController?.pushViewController(categoryViewController, animated: true)
        }
        
        
    }
    @IBAction func cartBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }
    @IBAction func loginBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }
   
    // MARK: Add wishlist into coredata
    @available(iOS 10.0, *)
    func save(index : NSInteger) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Wishlist",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(self.product[index].id, forKeyPath: "id")
        person.setValue(self.product[index].name, forKeyPath: "name")
        person.setValue(self.product[index].price, forKeyPath: "price")
        person.setValue(self.product[index].oldPrice, forKeyPath: "oldPrice")
        person.setValue(self.product[index].brandName, forKeyPath: "brand")
        person.setValue(self.product[index].image, forKeyPath: "image")
        person.setValue(self.product[index].categoryID, forKeyPath: "categoryID")
        person.setValue("1", forKeyPath: "wishlistID")
         person.setValue(self.product[index].stock, forKeyPath: "stock")
       
        do {
            try managedContext.save()
            wishlist.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.product[seletedIndex].wishlistID = "1"
        wishlistFromLocalDatabase()
    }
    
    //MARK: addToWishListAPI Methods
    @objc func addToWishListAPI(sender:UIButton!){
        
        print(sender.tag)
        seletedIndex = sender.tag
        var parameter: Parameters = [:]
        
        if Model.sharedInstance.userID == "" {
          
            if sender.imageView?.image == UIImage (named: "emptyWishlist")
            {
                if #available(iOS 10.0, *) {
                    sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                    save(index : sender.tag)
                     wishlistFromLocalDatabase()
                } else {
                    // Fallback on earlier versions
                }
            }
           else  if sender.imageView?.image == UIImage (named: "heart") {
                
                for section in 0...self.product.count - 1 {
                    
                    if section == sender.tag{
                        sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
                        deleteRecords(index:sender.tag)
                       // self.productlocal.remove(at: sender.tag)
                    }else{
                       // self.productlocal.remove(at: section)
                    }
                
                print(product.count)
                    
                    
//                    if let i = self.product.index(where: { $0.id == self.productlocal[section].id }) {
//                        print(i)
//                        //self.product[i].wishlistID = "1"
//                        print("Section: match found")
//                        sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
//                        self.productlocal.remove(at: sender.tag)
//                    }
//                    else{
//                        self.product.remove(at: section)
//                       // self.productlocal.remove(at: section)
//                        print("Section: match not found")
//                    }
                }
                
            }
            
        }
        else{
            parameter = ["user_id": Model.sharedInstance.userID,"cloth_id": self.product[seletedIndex].id]
            print(parameter)
        if sender.imageView?.image == UIImage (named: "emptyWishlist")
        {

            Webservice.apiPost(apiURl:"addToWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                    return
                }
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                if ((response!["message"] as? [String:Any]) != nil){
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
                else{
                    sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
                    self.getWishListAPI()

                }
            })
        }
        else  if sender.imageView?.image == UIImage (named: "heart") {

            //            SKActivityIndicator.spinnerColor(UIColor.darkGray)
            //            SKActivityIndicator.show("Loading...")

            print(parameter)
            Webservice.apiPost(apiURl:"rmWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                    return
                }
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                if ((response!["message"] as? [String:Any]) != nil){
                    Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
                else{
                    sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
                    self.getWishListAPI()
                 }
              })
            }
        }
    }
    //MARK: DeleteItem from wishlist
    func deleteRecords(index:NSInteger){
        
//        for section in 0...self.product.count - 1 {
//            if self.product[section].wishlistID == ""{
//
//            }else{
//                self.product.remove(at: section)
//            }
//        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Wishlist")
        do {
            cartlist = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        print(cartlist)
        
        let strID = self.product[index].id
        
        for section in 0...self.cartlist.count - 1  {
            if strID == ((cartlist[section].value(forKey: "id")) as! String) {
                let note = cartlist[section]
                managedContext.delete(note)
            }
        }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        wishlistFromLocalDatabase()
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
        
        Webservice.apiPost(apiURl:"viewWishlist/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                //SKActivityIndicator.dismiss()
            })
            if ((response!["message"] as? [String:Any]) != nil){
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                
                if ((response!.value(forKey: "Wishlist") != nil) ){
                
                for item in (response!.value(forKey: "Wishlist") as! NSArray) {
                    print(item)
                    
                    self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1", sizeID: "", categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), stock: ((item as! NSDictionary).value(forKey: "total_stock") as! String), clothID: ((item as! NSDictionary).value(forKey: "cloth_id") as! String)))
                }
                Model.sharedInstance.badgeValue = (String)(self.wishListProduct.count)
               // if self.wishListProduct.count > 0 {
                    
                    let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabItems![3] as! UITabBarItem
                    tabItem.badgeValue = Model.sharedInstance.badgeValue
                //}
                DispatchQueue.main.async(execute: {
                    // self.tableView.reloadData()
                })
            }
                else{
                print("no data...")
                    let tabItems = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabItems![3] as! UITabBarItem
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
extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            // not sure which is more reliable: String.Encoding.utf16 or String.Encoding.unicode
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}




