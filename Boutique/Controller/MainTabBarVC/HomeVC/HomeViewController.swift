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
    init(name: String,price: String,image: String,id: String,oldPrice: String,brandName: String) {
        self.name = name
        self.price = price
        self.image = image
        self.id = id
         self.oldPrice = oldPrice
         self.brandName = brandName
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
    
//    var urlImages = ["http://www.kavyaboutique.in/images/contact-us.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    var localImages =   ["one","two","three","four","five","six"]
    var urlImages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowRadius = 10
        
        
        
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
        self.getProductAPI()
        self.screenheight = self.view.frame.size.width
        imgSlider.sliderDelegate   =   self
        //configurePageControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.wishlistCountLabel.layer.cornerRadius = self.wishlistCountLabel.frame.size.height / 2
        self.wishlistCountLabel.clipsToBounds = true
        let defaults = UserDefaults.standard
        if (defaults.value(forKey: "totalCartItem")) != nil {
            let count = (defaults.value(forKey: "totalCartItem"))
            var temp1 : String! // This is not optional.
            temp1 = (String)(describing: count!)
            print(temp1)
            self.wishlistCountLabel.text = temp1
        }
        else {
           self.wishlistCountLabel.text = ""
        }
        
        
         print(Model.sharedInstance.cartCount)
        if Model.sharedInstance.cartCount > 0{
              self.wishlistCountLabel.text = (String)(Model.sharedInstance.cartCount)
        }
        
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
   
    //MARK: getProductImages Methods
    func getProductImages() {
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        let requestString = "http://kftsoftwares.com/ecom/recipes/get_banner_images/ZWNvbW1lcmNl/"
        
        Alamofire.request(requestString,method: .post, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                if response.result.value != nil{
                    
                    let product = response.result.value as! NSDictionary
                    
                    for item in ((product ).value(forKey: "bannerImages") as! NSArray) {
                        print(item)
                        
                        self.urlImages.append(((item as! NSDictionary).value(forKey: "image") as! String))
                    }
                    
                    print(self.urlImages)
                    DispatchQueue.main.async(execute: {
                        //self.imgSlider.setUpView(imageSource: .Url(imageArray: self.localImages, placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)
                        
                        self.imgSlider.setUpView(imageSource: .Url(imageArray: self.urlImages , placeHolderImage: UIImage (named: "placeHolder")), slideType: .ManualSwipe, isArrowBtnEnabled: true)
                        print(self.localImages.count)
                    })
                   
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
    func getProductAPI(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
       
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getallcloths/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                
                    
                    self.product.append(getProduct.init(name:((item as! NSDictionary).value(forKey: "title") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), oldPrice: "", brandName: ((item as! NSDictionary).value(forKey: "brand") as! String)))
                }
                
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                    self.collectionView.reloadData()
                })
            }
        }
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
        
        if  self.product[indexPath.row].oldPrice != "<null>" {
            cell.oldPriceLabel.text = self.product[indexPath.row].oldPrice
        }
        else{
            cell.oldPriceLabel.isHidden = true
            cell.crossLabel.isHidden = true
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
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/addToWishList/ZWNvbW1lcmNl/", parameters: parameter, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription)
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
                self.getWishListAPI()
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
            }
        }
    }
    
    //MARK: getWishListAPI Methods
    func getWishListAPI() {
        self.wishListProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/ViewWishlist/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Something Wrong..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
//             if (response?.value(forKey: "message") as! String == "Wishlist Empty"){
//                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "message") as! String))
//            }
           
                if ((response!.value(forKey: "Wishlist") != nil) )
                {
                for item in (response!.value(forKey: "Wishlist") as! NSArray) {
                    print(item)
                    
                    self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: ""))
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
 



