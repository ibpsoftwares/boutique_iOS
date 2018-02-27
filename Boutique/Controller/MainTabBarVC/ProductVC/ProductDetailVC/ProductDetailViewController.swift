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

class ProductDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,SKPhotoBrowserDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
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
    var userid = Model()
    var productID = String()
    var imgArray = NSMutableArray()
     var images = [SKPhotoProtocol]()
   
    var product = [getProductDetail]()
    
    var count = NSInteger()
    var imgArr = NSMutableArray()
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
        
        smallSizeBtn.layer.cornerRadius = smallSizeBtn.frame.size.height / 2
        smallSizeBtn.clipsToBounds = true
        smallSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        smallSizeBtn.layer.borderWidth = 0.8
        
        mediumSizeBtn.layer.cornerRadius = mediumSizeBtn.frame.size.height / 2
        mediumSizeBtn.clipsToBounds = true
        mediumSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        mediumSizeBtn.layer.borderWidth = 0.8
        
        largeSizeBtn.layer.cornerRadius = largeSizeBtn.frame.size.height / 2
        largeSizeBtn.clipsToBounds = true
        largeSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        largeSizeBtn.layer.borderWidth = 0.8
        
        exSizeBtn.layer.cornerRadius = exSizeBtn.frame.size.height / 2
        exSizeBtn.clipsToBounds = true
        exSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        exSizeBtn.layer.borderWidth = 0.8
        
        doubleExSizeBtn.layer.cornerRadius = doubleExSizeBtn.frame.size.height / 2
        doubleExSizeBtn.clipsToBounds = true
        doubleExSizeBtn.layer.borderColor = UIColor (red: 204.0/255.0, green: 204.0/255.0, blue: 204/255.0, alpha: 1).cgColor
        doubleExSizeBtn.layer.borderWidth = 0.8
        
        addToCartBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 237.0/255.0, green: 123.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        
        addToWishlistBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
        
        priceLabel.layer.cornerRadius = 2
        priceLabel.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
        
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
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getcloth/\(productID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    
                    self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "description") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ""))
                    
                    for var i in (0..<(((response!.value(forKey: "cloth") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "images") as! NSArray).count){
                        
                        self.imgArray.add(((((response!.value(forKey: "cloth") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "images") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "image")!)
                        
                        self.imgArr.add(self.imgArray[i] as! String)
                        let photo = SKPhoto.photoWithImageURL(self.imgArray[i] as! String)
                        photo.shouldCachePhotoURLImage = true
                        self.images.append(photo)
                        
                    }
                    
                }
                self.count = self.imgArr.count
                print(self.imgArr.count)
                
                DispatchQueue.main.async(execute: {
                    self.nameLabel.text = self.product[0].name
                    self.priceLabel.text = "$\(self.product[0].price)"
                    self.descriptionLabel.text = self.product[0].id
                    self.collectionView.reloadData()
                })
            }
        }

    }
    
    
    //MARK: CollectionView Delegate and Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgArray.count;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProductDetailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProductDetailCollectionViewCell
          let url = URL(string: self.imgArray[indexPath.row] as! String)
                cell.productImg.kf.indicatorType = .activity
                cell.productImg.kf.setImage(with: url,placeholder: nil)
       
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        present(browser, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        return sectionInset
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {
        
       addToCartAPI()
       
    }
    //MARK: addToCartAPI Methods
  func addToCartAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        print(Model.sharedInstance.userID)
        print(self.productID)
        
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.productID
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
                Model.sharedInstance.cartCount = (response!.value(forKey: "items") as! NSArray).count
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
    
    @IBAction func btnSmall(_ sender: UIButton) {
        
        if sender.tag == 0{
            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
            sender.titleLabel?.textColor = UIColor.white
            sender.tag = 1
            self.mediumSizeBtn.backgroundColor = UIColor.white
            self.largeSizeBtn.backgroundColor = UIColor.white
            self.exSizeBtn.backgroundColor = UIColor.white
            self.doubleExSizeBtn.backgroundColor = UIColor.white
        }
        else{
            sender.backgroundColor = UIColor.white
            sender.tag = 0
        }
    }
    
    @IBAction func btnMedium(_ sender: UIButton) {
            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
            sender.titleLabel?.textColor = UIColor.white
            sender.tag = 1
            self.smallSizeBtn.backgroundColor = UIColor.white
            self.largeSizeBtn.backgroundColor = UIColor.white
            self.exSizeBtn.backgroundColor = UIColor.white
            self.doubleExSizeBtn.backgroundColor = UIColor.white
    }
    
    @IBAction func btnLarge(_ sender: UIButton) {
            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
            sender.titleLabel?.textColor = UIColor.white
            sender.tag = 1
            self.smallSizeBtn.backgroundColor = UIColor.white
            self.mediumSizeBtn.backgroundColor = UIColor.white
            self.exSizeBtn.backgroundColor = UIColor.white
            self.doubleExSizeBtn.backgroundColor = UIColor.white
    }
    
    @IBAction func btnExel(_ sender: UIButton) {
            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
            sender.titleLabel?.textColor = UIColor.white
            sender.tag = 1
            self.smallSizeBtn.backgroundColor = UIColor.white
            self.mediumSizeBtn.backgroundColor = UIColor.white
            self.largeSizeBtn.backgroundColor = UIColor.white
            self.doubleExSizeBtn.backgroundColor = UIColor.white

    }
    
    @IBAction func btnDoubleExel(_ sender: UIButton) {
            sender.backgroundColor = UIColor (red: 38.0/255.0, green: 60.0/255.0, blue: 69.0/255.0, alpha: 1)
            sender.titleLabel?.textColor = UIColor.white
            sender.tag = 1
            self.smallSizeBtn.backgroundColor = UIColor.white
            self.mediumSizeBtn.backgroundColor = UIColor.white
            self.exSizeBtn.backgroundColor = UIColor.white
            self.largeSizeBtn.backgroundColor = UIColor.white
 }
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

