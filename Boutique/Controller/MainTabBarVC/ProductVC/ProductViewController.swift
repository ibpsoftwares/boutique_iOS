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

class getProductDetail {
    var name: String
    var price: String
    var id : String
    var image: String
    var oldPrice: String
    var brand: String
    init(name: String,id : String,price: String,image: String,oldPrice: String,brand:String) {
        self.name = name
        self.id = id
        self.price = price
        self.image = image
        self.oldPrice = oldPrice
        self.brand = brand
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
class ProductViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate , UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    var searchActive : Bool = false
    //var data = ["Tshirt","shoes","Jeans","Mobile","Laptops","Shirts","makeup"]
    var data :[String] = []
    var filtered:[String] = []
   var screenheight : CGFloat!
    var product = [getProductDetail]()
    var price = [getPrice]()
    var categoryID = String()
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideSortView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterTableView: UITableView!
    var sortArr =  ["Price :High To Low","Price :Low To High","Newest First","Oldest First"]
    var filterArr =  ["Price : 100 To 500","Price : 500 To 1000","Price : 1000 To 2000","Price : 2000 To 5000"]
    var selectedSortIndex = String()
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
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getbycategory/\(categoryID)/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                        
                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "original_price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: "", brand: ((item as! NSDictionary).value(forKey: "brand") as! String)))
                        
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
//        if(searchActive) {
//            return filtered.count
//        }
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
        
//        if(searchActive){
//           cell.productNameLabel.text = filtered[indexPath.row]
//            cell.productPriceLabel.text = self.product[indexPath.row].price
//            let url = URL(string: self.product[indexPath.row].image)
//            cell.productImg.kf.setImage(with: url,placeholder: nil)
//        } else {
           cell.productNameLabel.text = self.product[indexPath.row].name
            cell.originalPriceLabel.text = self.product[indexPath.row].price
            let url = URL(string: self.product[indexPath.row].image)
            cell.productImg.kf.setImage(with: url,placeholder: nil)
        //}
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
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getbycategory/\(categoryID)/ZWNvbW1lcmNl/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                    
                    self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image") as! String), brand: ""))
                    
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
                    
                    
                    self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cloth_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image1") as! String), brand: ""))
                    
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
            priceCell?.selectImageView.image = UIImage (named: "check")
            priceCell = self.filterTableView.dequeueReusableCell(withIdentifier: "rangeCell") as! PriceTableViewCell!
            selectedSortIndex = (String)(indexPath.row)
            sortAPIMethod(sortID: selectedSortIndex)
        }
        else if tableView == self.filterTableView {
            var priceCell:PriceTableViewCell?
            priceCell?.selectImageView.image = UIImage (named: "check")
            priceCell = self.filterTableView.dequeueReusableCell(withIdentifier: "rangeCell") as! PriceTableViewCell!
            self.filterByPrice(rangeID: self.price[indexPath.row].id)
        }
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
                        
                        self.product.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image") as! String), brand: ""))
                        
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
        if sender.tag  == 0{
            self.slideView.isHidden = false
            self.filterTableView.isHidden = false
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            self.slideView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideView)
            sender.tag = 1
        }
        else if sender.tag == 1{
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            self.slideView.layer.add(transition, forKey: nil)
            self.view .addSubview(self.slideView)
            self.slideView.isHidden = true
            self.filterTableView.isHidden = true
            self.collectionView.reloadData()
            sender.tag = 0
        }
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
        
        Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/getpricerange/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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

