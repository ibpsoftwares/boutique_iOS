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
    var objectModel = Model.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedStringKey.font:UIFont(name: "Whitney-Medium", size: 15.0)]
        appearance.setTitleTextAttributes((attributes as Any as! [NSAttributedStringKey : Any]), for: .normal)
        
      
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
//        self.tabBar.layer.borderWidth = 1
//        self.tabBar.layer.borderColor = UIColor.white.cgColor
//        self.tabBar.clipsToBounds = true
        
        self.objectModel.badgeValue = ""
        self.wishListProduct.removeAll()
         tabBar.inActiveTintColor()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.wishListProduct.removeAll()
        getWishListAPI()
    }
    //MARK: getCartViewAPI Methods
    func getWishListAPI() {
        
        self.wishListProduct.removeAll()
        let requestString = "http://kftsoftwares.com/ecom/recipes/ViewWishlist/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/"
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
                        
                        self.wishListProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String)))
                    }
                    
                    self.objectModel.badgeValue = (String)(self.wishListProduct.count)
                    if self.wishListProduct.count > 0 {
                        
                       // let tabItem = tabItems![4] as! UITabBarItem
                       // tabItem.badgeValue = (String)(self.wishListProduct.count)
                        self.tabBar.items?[4].badgeValue =  self.objectModel.badgeValue
                    }
                        
                    }
                    else{
                           self.tabBar.items?[4].badgeValue =  nil
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
