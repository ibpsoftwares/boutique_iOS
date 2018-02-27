//
//  MyCartViewController.swift
//  Boutique
//
//  Created by Apple on 24/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

//
//  CartViewController.swift
//  SpreeiOS
//
//  Created by Bharat Gupta on 07/06/16.
//  Copyright © 2016 Vinsol. All rights reserved.
//

import UIKit
import Kingfisher
import SKActivityIndicatorView
import Alamofire

class MyCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum STATE {
        case Loading
        case Empty
        case Filled
    }
    var isLoading = true
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutView: UIView!
    
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    var count = Int()
    var cartProduct = [getProductDetail]()
    var totalPrice = Int()
     var currentQty = 1
    let minQty = 1
    let maxQty = 20
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutView.isHidden = false
        tableView.tableFooterView = UIView()
        checkoutButton.layer.borderWidth = 0.5
       // checkoutButton.layer.borderColor = UIColor.secondary.cgColor
        getCartViewAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fetchCartDetails()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: getCartViewAPI Methods
    func getCartViewAPI() {
        
        self.totalPrice = 0
        self.cartProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let requestString = "http://kftsoftwares.com/ecom/recipes/ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/"
        Alamofire.request(requestString,method: .post, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                if response.result.value != nil{
                    
                    let product = response.result.value as! NSDictionary
                    print(product)
                    for item in ((product ).value(forKey: "items") as! NSArray) {
                        print(item)
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cart_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String)))
                    }
                    let defaults = UserDefaults.standard
                    defaults.set(self.cartProduct.count, forKey: "totalCartItem")
                    defaults .synchronize()
                    Model.sharedInstance.cartCount = self.cartProduct.count
                    for var i in (0..<(self.cartProduct.count)){
                        let total = (Int)(self.cartProduct[i].price)!
                        print(total)
                        self.totalPrice += total
                        self.totalPriceLabel.text = String("$\(self.totalPrice)")
                    }
                    DispatchQueue.main.async(execute: {
                       self.itemsCountLabel.text =  "Total (\(self.cartProduct.count))"
                        self.tableView.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let url = URL(string: self.cartProduct[indexPath.row].image)
        cell.thumbImageView.kf.setImage(with: url,placeholder: nil)
        cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.height / 2
        cell.thumbImageView.clipsToBounds = true
        
        cell.nameLabel.text = cartProduct[indexPath.row].name
        cell.priceLabel.text = "$\(cartProduct[indexPath.row].price)"
       // cell.configure()
       
        cell.removeButton.tag = indexPath.row
         cell.removeButton.addTarget(self,action:#selector(remove(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func remove(sender:UIButton!) {
        self.deleteItemFromCart(cartID: self.cartProduct[sender.tag].id)
    }
    //MARK: deleteItemFromCart Methods
    func deleteItemFromCart( cartID : String) {
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "cart_id": cartID,
            ]
        print(parameters)
        let url = "http://kftsoftwares.com/ecom/recipes/rmcart/ZWNvbW1lcmNl/"
        
        Alamofire.request(url, method:.post, parameters:parameters, headers:nil).responseJSON { response in
            switch response.result {
                
            case .success:
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                debugPrint(response)
                
                self.showAlert(msg: (response.result.value as! NSDictionary).value(forKey: "message") as! String)
                
            case .failure(let error):
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                print(error)
            }
        }
    }
    
    @IBAction func checkout(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    //MARK: Alert Method
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async(execute: {
            self.getCartViewAPI()
        })
        self.present(alert, animated: true, completion: nil)
    }
}




