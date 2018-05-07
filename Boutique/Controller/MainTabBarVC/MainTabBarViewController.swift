//
//  MainTabBarViewController.swift
//  Boutique
//
//  Created by Apple on 12/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire

class MainTabBarViewController: UITabBarController ,UITabBarControllerDelegate{

     var wishListProduct = [getProductDetail]()
    var cartProduct = [getProductDetail]()
    var objectModel = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font:UIFont(name: "Whitney-Medium", size: 15.0)]
        appearance.setTitleTextAttributes((attributes as Any as! [NSAttributedStringKey : Any]), for: .normal)
        
      //getCartViewAPI()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
       
        self.objectModel.badgeValue = ""
       // self.wishListProduct.removeAll()
         tabBar.inActiveTintColor()
        
      
        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color:  UIColor(red: 39.0/255.0, green: 61.0/255.0, blue: 67.0/255.0, alpha: 1), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func removeTabbarItemsText() {
        if let items = tabBar.items {
            for item in items {
                //item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -2, 0);
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         self.wishListProduct.removeAll()
        getWishListAPI()
        
    }
    //MARK: getCartViewAPI Methods
    func getWishListAPI() {
        
        self.wishListProduct.removeAll()
        let requestString = "viewWishlist/\(Model.sharedInstance.userID)/"
        print(requestString)
        Alamofire.request(requestString,method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
               
                if response.result.value != nil{
                    
                    let product = response.result.value as! NSDictionary
                    print(product)
                    
//                    if ((product ).value(forKey: "message") as! String == "Wishlist Empty"){
//                        Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (product.value(forKey: "message") as! String))
//                    }
//                    else{
                    
                    if ((product ).value(forKey: "Wishlist") != nil){
                        
                    for item in ((product ).value(forKey: "Wishlist") as! NSArray) {
                        print(item)
                        
                        self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1", sizeID: ""))
                    }
                    
                    self.objectModel.badgeValue = (String)(self.wishListProduct.count)
                    if self.wishListProduct.count > 0 {
                        
                       // let tabItem = tabItems![4] as! UITabBarItem
                       // tabItem.badgeValue = (String)(self.wishListProduct.count)
                        //self.tabBar.items?[3].badgeValue =  self.objectModel.badgeValue
                    }
                        
                    }
                    else{
                          // self.tabBar.items?[3].badgeValue =  nil
                          //  Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (product.value(forKey: "message") as! String))
                        }
                }
                //}
                break
                
            case .failure(_):
                print("Failure : \(String(describing: response.result.error))")
                break
                
            }
        }
    }
    
    //MARK: getCartViewAPI Methods
    func getCartViewAPI(){
        
        self.cartProduct.removeAll()
        //SKActivityIndicator.spinnerColor(UIColor.darkGray)
        //SKActivityIndicator.show("Loading...")
        
        Webservice.apiPost(apiURl: "viewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: "", brand: "", wishlistID: "", cout: "1", sizeID: ""))
                    }
                   
                    Model.sharedInstance.cartCount = self.cartProduct.count
            }
        }
    }
    }
}

extension UITabBar{
    func inActiveTintColor() {
        if let items = items{
            for item in items{
                item.image =  item.image?.withRenderingMode(.alwaysOriginal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
                item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
            }
        }
    }
}
extension UIImage
{
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect: CGRect = CGRect(x: -4, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

