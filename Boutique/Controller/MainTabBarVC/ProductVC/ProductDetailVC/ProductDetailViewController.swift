//
//  ProductDetailViewController.swift
//  Boutique
//
//  Created by Apple on 15/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SKPhotoBrowser
import SDWebImage
import SKActivityIndicatorView
import CoreData
class getSize {
    var size = NSArray()
    var size_id = NSArray()
    init(size: NSArray) {
       self.size = size
    }
}
class subCategory {
    var id : String
    var categoryID : String
    var name : String
    var image : String
    var originalPrice : String
    var offerPrice : String
    init(id: String,categoryID: String,name: String,image: String, originalPrice : String,offerPrice : String) {
        self.id = id
        self.categoryID = categoryID
        self.name = name
        self.image = image
        self.originalPrice = originalPrice
        self.offerPrice = offerPrice
    }
}
class getSingleProductDetail {
    var name: String
    var price: String
    var id : String
    var image: String
    var oldPrice: String
    var brand: String
    var wishlistID : String
    var cout: String
    var desc: String
    init(name: String,id : String,price: String,image: String,oldPrice: String,brand:String,wishlistID:String,cout: String,desc: String) {
        self.name = name
        self.id = id
        self.price = price
        self.image = image
        self.oldPrice = oldPrice
        self.brand = brand
        self.wishlistID = wishlistID
        self.cout = cout
        self.desc = desc
    }
}
@available(iOS 10.0, *)
class ProductDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,SKPhotoBrowserDelegate,CAAnimationDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
     @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var desriptionView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToWishlistBtn: UIButton!
    
    @IBOutlet var subCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var smallSizeBtn: UIButton!
    @IBOutlet weak var mediumSizeBtn: UIButton!
    @IBOutlet weak var largeSizeBtn: UIButton!
    @IBOutlet weak var exSizeBtn: UIButton!
    @IBOutlet weak var doubleExSizeBtn: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var crossLabel: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    
    var userid = Model()
    var productID = String()
    var sizeID = String()
     var check_SizeID = String()
    var passDict = NSMutableDictionary()
    var imgArray = NSMutableArray()
    var sizeArray = NSMutableArray()
     var images = [SKPhotoProtocol]()
    var cartProduct = [getProductDetail]()
    var product = [getSingleProductDetail]()
    var sizeArr = [getSize]()
    var subCat = [subCategory]()
    var count = NSInteger()
    var imgArr = NSMutableArray()
    var selectedIndex = NSInteger()
    var size_id = String()
    var size = String()
    var path : UIBezierPath?
    var layer: CALayer?
    var im = UIImageView()
    var wishlist: [NSManagedObject] = []
    var check : Bool = false
    var checkSub : Bool = false
     var duplicateCheck : Bool = false
    var productlocal = [getProduct]()
    var cartLocal = [getProduct]()
     var cartlist: [NSManagedObject] = []
    var subCategoryID = String()
    var subCategoryProductID = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 200
        // Do any additional setup after loading the view.
        check = true
        imgView.layer.shadowColor = UIColor.lightGray.cgColor
        imgView.layer.shadowOpacity = 1
        imgView.layer.shadowOffset = CGSize.zero
        imgView.layer.shadowRadius = 1
        
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.size.height / 2
        cartCountLabel.clipsToBounds = true
  
        addToCartBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 237.0/255.0, green: 123.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        
        addToWishlistBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
       
        //viewToCartAPI()
        print(self.passDict)
        SKCache.sharedCache.imageCache = CustomImageCache()
        let url = URL(string: "http://kftsoftwares.com/ecomm/app/webroot/img/products/1-24.png")
        let complated: SDWebImageCompletionBlock = { (image, error, cacheType, imageURL) -> Void in
            guard let url = imageURL?.absoluteString else { return }
            SKCache.sharedCache.setImage(image!, forKey: url)
        }
        self.tabBarController?.tabBar.isHidden = true
         self.subCategoryCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myCell")
        self.getProductAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = true
       
        if Model.sharedInstance.userID != "" {
             viewToCartAPI()
        }else{
            fetchWishlistFromCoreData()
            fetchCartData()
        }
        
    }
   
    //MARK: Fetch Cart Data From CoreData
    func fetchCartData(){
        cartLocal.removeAll()
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
            for row in 0...cartlist.count - 1{
                let person = cartlist[row]
                print(person)
                self.cartLocal.append(getProduct.init(name: (person.value(forKeyPath: "name") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String) , id:  (person.value(forKeyPath: "id") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brandName: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, sizeID:(person.value(forKeyPath: "sizeID") as! String), currency: "", categoryID: "" ))
            }
        }
        self.cartCountLabel.text  = (String)(self.cartlist.count)
    }
    
    //MARK: Fetch Wishlist from CoreData
    func fetchWishlistFromCoreData(){
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
                self.productlocal.append(getProduct.init(name: (person.value(forKeyPath: "name") as! String), price: (person.value(forKeyPath: "price") as! String) , image: (person.value(forKeyPath: "image") as! String) , id:  (person.value(forKeyPath: "id") as! String), oldPrice: (person.value(forKeyPath: "oldPrice") as! String), brandName: (person.value(forKeyPath: "brand") as! String), wishlistID: person.value(forKeyPath: "wishlistID") as! String, sizeID: "", currency: "", categoryID: ""))
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cartBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as! MyCartViewController
        navigationController?.pushViewController(abcViewController, animated: true)
    }
    
    //MARK: getProductAPI Methods
    func getProductAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        self.product.removeAll()
        self.sizeArr.removeAll()
        self.subCat.removeAll()
        self.imgArr.removeAllObjects()
        self.imgArray.removeAllObjects()
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
            if checkSub == true{
                 parameter = ["user_id": Model.sharedInstance.userID,"cloth_id" : self.subCategoryProductID,"category_id":self.subCategoryID]
            }else{
                 parameter = ["user_id": Model.sharedInstance.userID,"cloth_id" : productID,"category_id":self.passDict.value(forKey: "categoryID") as! String]
            }
           
        }
        else{
            if checkSub == true{
                parameter = ["user_id": "" , "cloth_id" : self.subCategoryProductID,"category_id":self.subCategoryID]
            }else{
               parameter = ["user_id": "" , "cloth_id" : self.passDict.value(forKey: "id") as! String,"category_id":self.passDict.value(forKey: "categoryID") as! String]
            }
        }
        
        print(parameter)
        
        Webservice.apiPost(apiURl: "getCloth", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                for item in (response!.value(forKey: "cloth") as! NSArray) {
                    
                    self.productID = ((item as! NSDictionary).value(forKey: "id") as! String)
                    
                    if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                        print("empty")
                       
                        self.product.append(getSingleProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: "", oldPrice: "", brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: "", cout: "1", desc: ((item as! NSDictionary).value(forKey: "description") as! String)))
                    }
                    else {
                        self.product.append(getSingleProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: "", oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: "", cout: "1", desc: ((item as! NSDictionary).value(forKey: "description") as! String)))
                    }

                    self.sizeArr.append(getSize.init(size: ((item as! NSDictionary).value(forKey: "size") as! NSArray)))
                   
                    for var i in (0..<(((response!.value(forKey: "cloth") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "images") as! NSArray).count){
                        
                        self.imgArray.add(((((response!.value(forKey: "cloth") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "images") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "image")!)
                        
                        self.imgArr.add(self.imgArray[i] as! String)
                        let photo = SKPhoto.photoWithImageURL(self.imgArray[i] as! String)
                        photo.shouldCachePhotoURLImage = true
                        self.images.append(photo)
                    }
                }
                
                if (response!.value(forKey: "relatedProducts") as! NSArray).count == 0 {
                    print("Data not found!..")
                    self.subCategoryHeight.constant = -80
                }
                else{
                for item in (response!.value(forKey: "relatedProducts") as! NSArray) {
                    
                    if (item as! NSDictionary).value(forKey: "offer_price")  is NSNull {
                        print("empty")
                        self.subCat.append(subCategory.init(id: ((item as! NSDictionary).value(forKey: "id") as! String), categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), name: ((item as! NSDictionary).value(forKey: "title") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), originalPrice: ((item as! NSDictionary).value(forKey: "original_price") as! String), offerPrice: ""))
                    }
                    else {
                        print("not null")
                        self.subCat.append(subCategory.init(id: ((item as! NSDictionary).value(forKey: "id") as! String), categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), name: ((item as! NSDictionary).value(forKey: "title") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), originalPrice: ((item as! NSDictionary).value(forKey: "original_price") as! String), offerPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String)))
                    }
                }
                }
                print(self.sizeArr)
                self.count = self.imgArr.count
                print(self.imgArr.count)
                
                DispatchQueue.main.async(execute: {
                    self.nameLabel.text = self.product[0].name
                    self.descriptionLabel.text = self.product[0].desc
                    self.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product[0].oldPrice)"
                    
                    if  self.product[0].oldPrice != "" {
                        self.oldPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product[0].price)"
                        self.crossLabel.isHidden = false
                    }
                    else{
                        self.oldPriceLabel.isHidden = true
                        self.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.product[0].price)"
                    }
                    self.collectionView.reloadData()
                    self.sizeCollectionView.reloadData()
                    self.subCategoryCollectionView.reloadData()
                })
            }
        }
    }
    
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return imgArray.count
        }
        else  if collectionView == self.sizeCollectionView {
            if imgArr.count > 0 {
                 return (sizeArr[0].size).count
            }
        }
        else  if collectionView == self.subCategoryCollectionView {
                return subCat.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = ProductDetailCollectionViewCell()
        
        if(collectionView == self.collectionView)
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductDetailCollectionViewCell
            let url = URL(string: self.imgArray[indexPath.row] as! String)
                cell.productImg.kf.indicatorType = .activity
                cell.productImg.kf.setImage(with: url,placeholder: nil)
            
        }
        else
            if(collectionView == self.sizeCollectionView)
            {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath as IndexPath) as! SizeCollectionViewCell
                cell.sizeBtn.layer.cornerRadius = cell.sizeBtn.frame.size.height / 2
                cell.sizeBtn.clipsToBounds = true
                let size = (((sizeArr[0].size)[indexPath.row] as! NSDictionary).value(forKey: "size") as! String)
                print(size)
                let value:String?
                value = size
                print(value!)
                cell.sizeLabel.text = value
                cell.sizeLabel.textColor = UIColor.black
                cell.sizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
                cell.sizeBtn.layer.borderWidth = 0.8
                
                if selectedIndex == indexPath.row                {
                    cell.sizeBtn.backgroundColor = UIColor (red: 43.0/255.0, green: 59.0/255.0, blue: 68.0/255.0, alpha: 1)
                    cell.sizeLabel.textColor = UIColor.white
                    selectedIndex = 200
                }
                else{
                    cell.sizeBtn.backgroundColor = UIColor.white
                    cell.sizeBtn.setTitleColor(UIColor.black, for: .normal)
                }
                cell.sizeBtn.tag = indexPath.row
                cell.sizeBtn.addTarget(self,action:#selector(selectSize(sender:)), for: .touchUpInside)
                return cell
        }
            else  if collectionView == self.subCategoryCollectionView {
               
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! HomeCollectionViewCell
                let url = URL(string: self.subCat[indexPath.row].image)
                cell.productImg.kf.indicatorType = .activity
                cell.wishlistBtn.isHidden = true
                cell.productImg.kf.setImage(with: url,placeholder: nil)
               // cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.subCat[indexPath.row].originalPrice)"
                if  self.subCat[indexPath.row].offerPrice != "" {
                    cell.oldPriceLabel.text = "\(Model.sharedInstance.currency)\(self.subCat[indexPath.row].originalPrice)"
                    cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.subCat[indexPath.row].offerPrice)"
                    cell.crossLabel.isHidden = false
                    cell.oldPriceLabel.isHidden = false
                }
                else{
                    cell.oldPriceLabel.isHidden = true
                    cell.crossLabel.isHidden = true
                    cell.originalPriceLabel.text = "\(Model.sharedInstance.currency)\(self.subCat[indexPath.row].originalPrice)"
                }
                cell.brandNameLabel.text = self.subCat[indexPath.row].name
                 return cell
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if collectionView ==  subCategoryCollectionView{
//            return CGSize(width:150 , height:150)
//        }
        return CGSize(width:175 , height:200)
    }
    @objc func selectSize(sender:UIButton!){
        self.selectedIndex = sender.tag
         size_id = ((sizeArr[0].size)[selectedIndex] as! NSDictionary).value(forKey: "id") as! String
         size = ((sizeArr[0].size)[selectedIndex] as! NSDictionary).value(forKey: "size") as! String
        self.sizeCollectionView.reloadData()
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == self.collectionView)
        {
            let browser = SKPhotoBrowser(photos: createWebPhotos())
            browser.initializePageIndex(indexPath.row)
            browser.delegate = self
            present(browser, animated: true, completion: nil)
        }
        else  if collectionView == self.subCategoryCollectionView {
            checkSub = true
            self.subCategoryID = self.subCat[indexPath.row].categoryID
            self.subCategoryProductID = self.subCat[indexPath.row].id
            getProductAPI()
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsetsMake(0, 0, 0,0)
        return sectionInset
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        
        if size_id == "" {
            Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Please Select Size !")
        }
        else{
        if Model.sharedInstance.userID != ""{
              addToCartAPI()
        }
        else{
            addToCartCoreData()
        }
        }
       // var rect = collectionView.rectForRow(at: sender.tag)
        //let sss = collectionView.
       // rect.origin.y -=  200
        var headRect = CGRect(x:self.collectionView.frame.size.width / 2,y:self.collectionView.frame.size.height / 2,width:150,height:150)
        headRect.origin.y = 20
        im.frame = CGRect(x:self.collectionView.frame.size.width / 2,y:self.collectionView.frame.size.height / 2,width:50,height:50)
        let url = URL(string: self.imgArray[sender.tag] as! String)
        im.kf.indicatorType = .activity
        im.kf.setImage(with: url,placeholder: nil)
    
       // im.image = UIImage.init(named: "heart")
        //self.view.addSubview(im)
        //startAnimation(headRect, iconView: im)
    }
    
    fileprivate func groupAnimation() {
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path!.cgPath
        animation.rotationMode = kCAAnimationRotateAuto
        
        let bigAnimation = CABasicAnimation(keyPath: "transform.scale")
        bigAnimation.duration = 0.5
        bigAnimation.fromValue = 1
        bigAnimation.toValue = 2
        bigAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let smallAnimation = CABasicAnimation(keyPath: "transform.scale")
        smallAnimation.beginTime = 0.5
        smallAnimation.duration = 1.5
        smallAnimation.fromValue = 2
        smallAnimation.toValue = 0.3
        smallAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, bigAnimation, smallAnimation]
        groupAnimation.duration = 2
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        layer?.add(groupAnimation, forKey: "groupAnimation")
    }
    
    
    fileprivate func startAnimation(_ rect: CGRect ,iconView:UIImageView) {
        if layer == nil {
            layer = CALayer()
            layer?.contents = iconView.layer.contents
            layer?.contentsGravity = kCAGravityResizeAspectFill
            layer?.bounds = rect
            layer?.cornerRadius = layer!.bounds.height * 0.5
            layer?.masksToBounds = true
           // layer?.position = CGPoint(x: iconView.center.x, y: rect.maxY)
            layer?.position = CGPoint(x: self.view.frame.size.width / 2, y:self.view.frame.size.height / 2)
            
            UIApplication.shared.keyWindow?.layer.addSublayer(layer!)
            path = UIBezierPath()
            path?.move(to: layer!.position)
            path?.addQuadCurve(to: CGPoint(x: self.view.frame.size.width - 35, y: 25), controlPoint: CGPoint(x: 10, y: 10))
            
        }
        groupAnimation()
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        if anim == layer?.animation(forKey: "groupAnimation") {
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
            layer = nil
            let goodCountAnimation = CATransition()
            goodCountAnimation.duration = 0.25
           
            
            let cartAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            cartAnimation.duration = 0.25
            cartAnimation.fromValue = -5
            cartAnimation.toValue = 5
            cartAnimation.autoreverses = true
            cartBtn.layer.add(cartAnimation, forKey: nil)
             self.im.removeFromSuperview()
        }
    }
    
    //MARK: addToCartAPI Methods
  func addToCartAPI(){
    if Model.sharedInstance.userID != "" {
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        print(self.productID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.productID,
            "quantity": "1",
            "size_id" : size_id
        ]
        
        print(parameters)
        
        Webservice.apiPost(apiURl: "addToCart/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
   
}
 
    //MARK: Add to cart in core data
    func addToCartCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    //&& (((sizeArr[0].size)[row] as! NSDictionary).value(forKey: "id") as! String) == sizeID
        if self.cartLocal.count > 0{
            for row in 0...self.cartLocal.count - 1{

                print(self.cartLocal[row].id)
                print(self.productID)
                print(self.cartLocal[row].sizeID)
                print(size)
                count = 0
                if (self.cartLocal[row].id == self.productID && self.cartLocal[row].sizeID == size_id ){
                   count = 1
                    break
                   Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Item Is Already Exits.")
                }
            }
                if(count == 1){
                    
                }
                else{
                        let managedCon = appDelegate.persistentContainer.viewContext
                        
                        let entity = NSEntityDescription.entity(forEntityName: "Cartlist",
                                                                in: managedCon)!
                        
                        let cart = NSManagedObject(entity: entity,
                                                   insertInto: managedCon)
                        cart.setValue(passDict.value(forKey: "id"), forKeyPath: "id")
                        cart.setValue(passDict.value(forKey: "name"), forKeyPath: "name")
                        cart.setValue(passDict.value(forKey: "price"), forKeyPath: "price")
                        cart.setValue(passDict.value(forKey: "oldPrice"), forKeyPath: "oldPrice")
                        cart.setValue(passDict.value(forKey: "brand"), forKeyPath: "brand")
                        cart.setValue(passDict.value(forKey: "image"), forKeyPath: "image")
                        cart.setValue(passDict.value(forKey: "categoryID"), forKeyPath: "categoryID")
                        cart.setValue(size_id, forKeyPath: "sizeID")
                        cart.setValue(size, forKeyPath: "size")
                        cart.setValue("1", forKeyPath: "wishlistID")
                        print(cart)
                        do {
                            try managedCon.save()
                            // addToCart.append(cart)
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                    }
                }
           // }
        }
        else{
            let managedCon = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Cartlist",
                                                    in: managedCon)!
            
            let cart = NSManagedObject(entity: entity,
                                       insertInto: managedCon)
            cart.setValue(passDict.value(forKey: "id"), forKeyPath: "id")
            cart.setValue(passDict.value(forKey: "name"), forKeyPath: "name")
            cart.setValue(passDict.value(forKey: "price"), forKeyPath: "price")
            cart.setValue(passDict.value(forKey: "oldPrice"), forKeyPath: "oldPrice")
            cart.setValue(passDict.value(forKey: "brand"), forKeyPath: "brand")
            cart.setValue(passDict.value(forKey: "image"), forKeyPath: "image")
            cart.setValue(passDict.value(forKey: "categoryID"), forKeyPath: "categoryID")
            cart.setValue(size_id, forKeyPath: "sizeID")
            cart.setValue(size, forKeyPath: "size")
            cart.setValue("1", forKeyPath: "wishlistID")
            print(cart)
            do {
                try managedCon.save()
                // addToCart.append(cart)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
//        if self.cartLocal.count > 0 {
//        for section in 0...self.cartLocal.count - 1 {
//
//            if let i = self.cartLocal.index(where: { $0.id == self.productID }) {
//                print(i)
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Item Is Already Exits.")
//             }
//            }
//        }
//        else{
//        let managedCon = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Cartlist",
//                                                in: managedCon)!
//
//        let cart = NSManagedObject(entity: entity,
//                                   insertInto: managedCon)
//        cart.setValue(passDict.value(forKey: "id"), forKeyPath: "id")
//        cart.setValue(passDict.value(forKey: "name"), forKeyPath: "name")
//        cart.setValue(passDict.value(forKey: "price"), forKeyPath: "price")
//        cart.setValue(passDict.value(forKey: "oldPrice"), forKeyPath: "oldPrice")
//        cart.setValue(passDict.value(forKey: "brand"), forKeyPath: "brand")
//        cart.setValue(passDict.value(forKey: "image"), forKeyPath: "image")
//        cart.setValue(size_id, forKeyPath: "sizeID")
//        cart.setValue(size, forKeyPath: "size")
//        cart.setValue("1", forKeyPath: "wishlistID")
//        print(cart)
//        do {
//            try managedCon.save()
//           // addToCart.append(cart)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
       fetchCartData()
        
}
    
    //MARK: getCartViewAPI Methods
    func viewToCartAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        self.cartProduct.removeAll()
        var parameter: Parameters = [:]
        if Model.sharedInstance.userID != "" {
            parameter = ["user_id": Model.sharedInstance.userID]
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
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                 if ((response!.value(forKey: "items") != nil) ){
                for item in (response!.value(forKey: "items") as! NSArray) {
                    
                    self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brand: "", wishlistID: "", cout: "1", sizeID: "", categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String)))
                }
            }
                DispatchQueue.main.async(execute: {
                     self.cartCountLabel.text  = (String)(self.cartProduct.count)
                   self.collectionView.reloadData()
                })
            }
        }
    }
    
    @IBAction func btnAddToWishList(_ sender: UIButton) {
        addToWishListAPI()
    }
    
    //MARK: addToWishListAPI Methods
    func addToWishListAPI(){
        if Model.sharedInstance.userID != "" {
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        print(self.productID)
          var parameters: Parameters = [:]
        parameters = ["user_id": Model.sharedInstance.userID,"cloth_id": self.productID]
        print(parameters)
        
            Webservice.apiPost(apiURl: "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
        }else{
              save()
        }
    }
    @available(iOS 10.0, *)
    //MARK: Add item wishlist in core data
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        for section in 0...self.productlocal.count - 1 {
            
            if let i = self.productlocal.index(where: { $0.id == self.productID }) {
                print(i)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Item Is Already Exits.")
            }
            else{
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Wishlist",
                                                        in: managedContext)!
                
                let person = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                person.setValue(self.product[0].id, forKeyPath: "id")
                person.setValue(self.product[0].name, forKeyPath: "name")
                person.setValue(self.product[0].price, forKeyPath: "price")
                person.setValue(self.product[0].oldPrice, forKeyPath: "oldPrice")
                person.setValue(self.product[0].brand, forKeyPath: "brand")
                person.setValue(self.imgArray[0] as! String, forKeyPath: "image")
                person.setValue("1", forKeyPath: "wishlistID")
                print(person)
                do {
                    try managedContext.save()
                    wishlist.append(person)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                fetchWishlistFromCoreData()
            }
        }
    }
//    //MARK: addToWishListAPI Methods
//    func addToWishListAPI(){
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
//        print(Model.sharedInstance.userID)
//        print(self.productID)
//
//        let parameters: Parameters = [
//            "user_id": Model.sharedInstance.userID,
//            "cloth_id": self.productID
//        ]
//        print(parameters)
//        let url = "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/"
//
//        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
//            switch response.result {
//
//            case .success:
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                debugPrint(response)
//                self.showAlert(msg: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
//            case .failure(let error):
//                DispatchQueue.main.async(execute: {
//                    SKActivityIndicator.dismiss()
//                })
//                self.showAlert(msg: "product not found.")
//                print(error)
//            }
//        }
//    }
    
//    @IBAction func btnSmall(_ sender: UIButton) {
//
//        if sender.tag == 0{
//            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
//            sender.titleLabel?.textColor = UIColor.white
//            sender.tag = 1
//            self.mediumSizeBtn.backgroundColor = UIColor.white
//            self.largeSizeBtn.backgroundColor = UIColor.white
//            self.exSizeBtn.backgroundColor = UIColor.white
//            self.doubleExSizeBtn.backgroundColor = UIColor.white
//        }
//        else{
//            sender.backgroundColor = UIColor.white
//            sender.tag = 0
//        }
//    }
//
//    @IBAction func btnMedium(_ sender: UIButton) {
//            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
//            sender.titleLabel?.textColor = UIColor.white
//            sender.tag = 1
//            self.smallSizeBtn.backgroundColor = UIColor.white
//            self.largeSizeBtn.backgroundColor = UIColor.white
//            self.exSizeBtn.backgroundColor = UIColor.white
//            self.doubleExSizeBtn.backgroundColor = UIColor.white
//    }
//
//    @IBAction func btnLarge(_ sender: UIButton) {
//            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
//            sender.titleLabel?.textColor = UIColor.white
//            sender.tag = 1
//            self.smallSizeBtn.backgroundColor = UIColor.white
//            self.mediumSizeBtn.backgroundColor = UIColor.white
//            self.exSizeBtn.backgroundColor = UIColor.white
//            self.doubleExSizeBtn.backgroundColor = UIColor.white
//    }
//
//    @IBAction func btnExel(_ sender: UIButton) {
//            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
//            sender.titleLabel?.textColor = UIColor.white
//            sender.tag = 1
//            self.smallSizeBtn.backgroundColor = UIColor.white
//            self.mediumSizeBtn.backgroundColor = UIColor.white
//            self.largeSizeBtn.backgroundColor = UIColor.white
//            self.doubleExSizeBtn.backgroundColor = UIColor.white
//
//    }
//
//    @IBAction func btnDoubleExel(_ sender: UIButton) {
//            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
//            sender.titleLabel?.textColor = UIColor.white
//            sender.tag = 1
//            self.smallSizeBtn.backgroundColor = UIColor.white
//            self.mediumSizeBtn.backgroundColor = UIColor.white
//            self.exSizeBtn.backgroundColor = UIColor.white
//            self.largeSizeBtn.backgroundColor = UIColor.white
// }
}
// MARK: - SKPhotoBrowserDelegate

@available(iOS 10.0, *)
extension ProductDetailViewController {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

// MARK: - private
@available(iOS 10.0, *)
private extension ProductDetailViewController {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<count).map { (i: Int) -> SKPhotoProtocol in
            //            let photo = SKPhoto.photoWithImageURL("https://placehold.jp/150\(i)x150\(i).png", holder: UIImage(named: "image0.jpg")!)
            let photo = SKPhoto.photoWithImageURL(self.imgArr[i] as! String)
            //photo.caption = caption[i%10]
            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }
}
extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
class CustomImageCache: SKImageCacheable {
    var cache: SDImageCache
    
    init() {
        let cache = SDImageCache(namespace: "com.suzuki.custom.cache")
        self.cache = cache!
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        guard let image = cache.imageFromDiskCache(forKey: key) else { return nil }
        
        return image
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.store(image, forKey: key)
    }
    
    func removeImageForKey(_ key: String) {
    }
}

