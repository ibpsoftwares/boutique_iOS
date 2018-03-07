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

class getSize {
    var size = NSArray()
    init(size: NSArray) {
       self.size = size
    }
}
class ProductDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,SKPhotoBrowserDelegate,CAAnimationDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
     @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var desriptionView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToWishlistBtn: UIButton!
    
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
    var imgArray = NSMutableArray()
    var sizeArray = NSMutableArray()
     var images = [SKPhotoProtocol]()
    var cartProduct = [getProductDetail]()
    var product = [getProductDetail]()
    var sizeArr = [getSize]()
    var count = NSInteger()
    var imgArr = NSMutableArray()
    var selectedIndex = NSInteger()
    
    var path : UIBezierPath?
    var layer: CALayer?
    var im = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgView.layer.shadowColor = UIColor.lightGray.cgColor
        imgView.layer.shadowOpacity = 1
        imgView.layer.shadowOffset = CGSize.zero
        imgView.layer.shadowRadius = 1
        
//        desriptionView.layer.shadowColor = UIColor.lightGray.cgColor
//        desriptionView.layer.shadowOpacity = 1
//        desriptionView.layer.shadowOffset = CGSize.zero
//        desriptionView.layer.shadowRadius = 1
        
        cartCountLabel.layer.cornerRadius = cartCountLabel.frame.size.height / 2
        cartCountLabel.clipsToBounds = true
        
//        smallSizeBtn.layer.cornerRadius = smallSizeBtn.frame.size.height / 2
//        smallSizeBtn.clipsToBounds = true
//        smallSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
//        smallSizeBtn.layer.borderWidth = 0.8
//
//        mediumSizeBtn.layer.cornerRadius = mediumSizeBtn.frame.size.height / 2
//        mediumSizeBtn.clipsToBounds = true
//        mediumSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
//        mediumSizeBtn.layer.borderWidth = 0.8
//
//        largeSizeBtn.layer.cornerRadius = largeSizeBtn.frame.size.height / 2
//        largeSizeBtn.clipsToBounds = true
//        largeSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
//        largeSizeBtn.layer.borderWidth = 0.8
//
//        exSizeBtn.layer.cornerRadius = exSizeBtn.frame.size.height / 2
//        exSizeBtn.clipsToBounds = true
//        exSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
//        exSizeBtn.layer.borderWidth = 0.8
//
//        doubleExSizeBtn.layer.cornerRadius = doubleExSizeBtn.frame.size.height / 2
//        doubleExSizeBtn.clipsToBounds = true
//        doubleExSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
//        doubleExSizeBtn.layer.borderWidth = 0.8
        
        addToCartBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 237.0/255.0, green: 123.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        
        addToWishlistBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
        
//        priceLabel.layer.cornerRadius = 2
//        priceLabel.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
        
        viewToCartAPI()
        print(count)
        SKCache.sharedCache.imageCache = CustomImageCache()
        let url = URL(string: "http://kftsoftwares.com/ecomm/app/webroot/img/products/1-24.png")
        let complated: SDWebImageCompletionBlock = { (image, error, cacheType, imageURL) -> Void in
            guard let url = imageURL?.absoluteString else { return }
            SKCache.sharedCache.setImage(image!, forKey: url)
        }
        
        
        self.getProductAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.cartCountLabel.text =  (String)(Model.sharedInstance.cartCount)
//        let defaults = UserDefaults.standard
//        if (defaults.value(forKey: "totalCartItem")) != nil {
//            let count = (defaults.value(forKey: "totalCartItem"))
//            var temp1 : String! // This is not optional.
//            temp1 = (String)(describing: count!)
//            print(temp1)
//            self.cartCountLabel.text = temp1
//        }
//        else {
//            self.cartCountLabel.isHidden = true
//        }
         viewToCartAPI()
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
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
        ]
        print(productID)
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getcloth/\(productID)/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "description") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: "", oldPrice: "", brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: "", cout: "1"))
                    }
                    else {
                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "description") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: "", oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brand: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: "", cout: "1"))
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
                print(self.sizeArr.count)
                print(self.sizeArr)
                self.count = self.imgArr.count
                print(self.imgArr.count)
                
                DispatchQueue.main.async(execute: {
                    self.nameLabel.text = self.product[0].name
                    //self.priceLabel.text = "$\(self.product[0].price)"
                    self.descriptionLabel.text = self.product[0].id
                    self.originalPriceLabel.text = "$\(self.product[0].price)"
                    
                    if  self.product[0].oldPrice != "" {
                        self.oldPriceLabel.text = self.product[0].oldPrice
                    }
                    else{
                        self.oldPriceLabel.isHidden = true
                    }
                    self.collectionView.reloadData()
                    self.sizeCollectionView.reloadData()
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
                cell.sizeBtn.setTitle(size, for: .normal)
                cell.sizeBtn.titleLabel?.textColor = UIColor.black
                cell.sizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
                cell.sizeBtn.layer.borderWidth = 0.8
                
                if selectedIndex == indexPath.row
                {
                    cell.sizeBtn.backgroundColor = UIColor (red: 43.0/255.0, green: 59.0/255.0, blue: 68.0/255.0, alpha: 1)
                    cell.sizeBtn.setTitleColor(UIColor.white, for: .normal)
                }
                else
                {
                    cell.sizeBtn.backgroundColor = UIColor.white
                    
                }
                cell.sizeBtn.tag = indexPath.row
                cell.sizeBtn.addTarget(self,action:#selector(selectSize(sender:)), for: .touchUpInside)
                return cell
        }
        return cell
    }
    @objc func selectSize(sender:UIButton!){
        self.selectedIndex = sender.tag
        self.sizeCollectionView.reloadData()
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        present(browser, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsetsMake(0, 0, 0,0)
        return sectionInset
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        
       addToCartAPI()
        
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
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        print(self.productID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.productID,
             "quantity": "1"
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
 

    //MARK: getCartViewAPI Methods
    func viewToCartAPI() {
    self.cartProduct.removeAll()
       // SKActivityIndicator.spinnerColor(UIColor.darkGray)
       // SKActivityIndicator.show("Loading...")
        let requestString = "http://kftsoftwares.com/ecom/recipes/ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/"
        Alamofire.request(requestString,method: .post, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                DispatchQueue.main.async(execute: {
                   // SKActivityIndicator.dismiss()
                })
      
                let product = response.result.value as! NSDictionary
                print(product)
                if ((product.value(forKey: "items") != nil)){
                    
                    for item in ((product ).value(forKey: "items") as! NSArray) {
                        print(item)
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image1") as! String), brand: "", wishlistID: "", cout: "1"))
                    }
//                        let defaults = UserDefaults.standard
//                        defaults.set(self.cartProduct.count, forKey: "totalCartItem")
//                        defaults .synchronize()
                       // Model.sharedInstance.cartCount = self.cartProduct.count
                        self.cartCountLabel.text = (String)(self.cartProduct.count)
                    
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                }
                else{
                   
//                    DispatchQueue.main.async(execute: {
//                        self.collectionView.reloadData()
//                    })
                   // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((response.result.value as! NSDictionary).value(forKey: "message") as! String))
                }
                
                break
                
            case .failure(_):
                print("Failure : \(String(describing: response.result.error))")
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                break
                
            }
        }
    }
    @IBAction func btnAddToWishList(_ sender: UIButton) {
        
        addToWishListAPI()
        
    }
    //MARK: addToWishListAPI Methods
    func addToWishListAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        print(self.productID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.productID
        ]
        print(parameters)
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
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

