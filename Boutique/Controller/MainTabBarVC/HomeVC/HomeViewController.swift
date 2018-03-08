//
//  HomeViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CLabsImageSlider
import Alamofire
import Kingfisher
import SKActivityIndicatorView

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
    //let urlImages = [String]()
    var wishListProduct = [getProductDetail]()
    var cartProduct = [getProductDetail]()
    
//    var urlImages = ["http://www.kavyaboutique.in/images/contact-us.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    var localImages =   ["one","two","three","four","five","six"]
    var urlImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
        self.product.removeAll()
        getProductAPI()
        
        
        self.wishlistCountLabel.layer.cornerRadius = self.wishlistCountLabel.frame.size.height / 2
        self.wishlistCountLabel.clipsToBounds = true
     

       // getCartViewAPI()
         getProductImages()
        self.wishListProduct.removeAll()
       // getWishListAPI()
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
    func getCartViewAPI(){
        
        self.cartProduct.removeAll()
        //SKActivityIndicator.spinnerColor(UIColor.darkGray)
        //SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
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
        }
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
            print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{

                for item in (response?.value(forKey: "bannerImages") as! NSArray) {
                    print(item)

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
        print("did moved at Index : ",index)
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
        
        Webservice.apiPost(serviceName:"http://kftsoftwares.com/ecom/recipes/getallcloths/", parameters:parameter, headers: nil, completionHandler: { (response:NSDictionary?, error:NSError?) in
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
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: "", brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "Wishlist") as! String)))
                    }
                    else {
                        print("not null")
                        self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "offer_price") as! String), brandName: ((item as! NSDictionary).value(forKey: "brand") as! String), wishlistID: ((item as! NSDictionary).value(forKey: "Wishlist") as! String)))
                    }
                    
                    
                }
                
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                    self.collectionView.reloadData()
                })
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
   
   
    //MARK: addToWishListAPI Methods
    @objc func addToWishListAPI(sender:UIButton!){
        
        let parameter: Parameters = [
            "user_id": Model.sharedInstance.userID,
            "cloth_id": self.product[sender.tag].id
        ]
        if sender.imageView?.image == UIImage (named: "emptyWishlist")
        {
//        SKActivityIndicator.spinnerColor(UIColor.darkGray)
//        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
             //   SKActivityIndicator.dismiss()
            })
            sender.setImage(UIImage(named: "heart"), for: UIControlState.normal)
            print(response!)
            if ((response!["message"] as? [String:Any]) != nil){
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
            else{
                self.getWishListAPI()
               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
         }
        }
        else  if sender.imageView?.image == UIImage (named: "heart") {
            
//            SKActivityIndicator.spinnerColor(UIColor.darkGray)
//            SKActivityIndicator.show("Loading...")
            
            Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/rmwishlist/ZWNvbW1lcmNl/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                  //  Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                    return
                }
                DispatchQueue.main.async(execute: {
                  //  SKActivityIndicator.dismiss()
                })
                print(response!)
                sender.setImage(UIImage(named: "emptyWishlist"), for: .normal)
                if ((response!["message"] as? [String:Any]) != nil){
                    //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
                else{
                    self.getWishListAPI()
                  //  Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
                }
            }
        }
    }
    
    //MARK: getWishListAPI Methods
    func getWishListAPI() {
        self.wishListProduct.removeAll()
       // SKActivityIndicator.spinnerColor(UIColor.darkGray)
       // SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewWishlist/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
               // SKActivityIndicator.dismiss()
            })
            print(response!)
//             if (response?.value(forKey: "message") as! String == "Wishlist Empty"){
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
           
                if ((response!.value(forKey: "Wishlist") != nil) )
                {
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
               // Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
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
}
 



