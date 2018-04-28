//
//  CartViewController.swift
//  Boutique
//
//  Created by Apple on 16/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Kingfisher
import SKActivityIndicatorView
import Alamofire

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var addToWishlistBtn: UIButton!
    var selectedIndex = NSInteger()
     var cartProduct = [getProductDetail]()
     var totalPrice = Int()
    var count = NSInteger()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        tableView.tableFooterView = UIView()
        
        addToCartBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 237.0/255.0, green: 123.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        
        addToWishlistBtn.layer.cornerRadius = 2
        addToCartBtn.layer.borderColor = UIColor (red: 102.0/255.0, green: 102.0/255.0, blue: 103.0/255.0, alpha: 1).cgColor
        getCartViewAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: TableView Delegate and Data Source
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartProduct.count
    }
    
    //MARK: getCartViewAPI Methods
    func getCartViewAPI() {
        
        self.totalPrice = 0
        self.cartProduct.removeAll()
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let requestString = "ViewCart/\(Model.sharedInstance.userID)/ZWNvbW1lcmNl/"
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
                        
                        self.cartProduct.append(getProductDetail.init(name:((item as! NSDictionary).value(forKey: "title") as! String), id: ((item as! NSDictionary).value(forKey: "Cart_id") as! String), price: ((item as! NSDictionary).value(forKey: "price") as! String), image: ((item as! NSDictionary).value(forKey: "image1") as! String), oldPrice: ((item as! NSDictionary).value(forKey: "image1") as! String), brand: "", wishlistID: ((item as! NSDictionary).value(forKey: "Wishlist") as! String), cout: "1", sizeID: ""))
                    }
                    
                    for var i in (0..<(self.cartProduct.count)){
                        let total = (Int)(self.cartProduct[i].price)!
                        print(total)
                        self.totalPrice += total
                        self.totalPriceLabel.text = String("$\(self.totalPrice)")
                    }
                    DispatchQueue.main.async(execute: {
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
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:CartTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell!
        
        let url = URL(string: self.cartProduct[indexPath.row].image)
        cell.productImg.kf.setImage(with: url,placeholder: nil)
        cell.productImg.layer.cornerRadius = cell.productImg.frame.size.height / 2
        cell.productImg.clipsToBounds = true
        
        cell.productNameLabel.text = cartProduct[indexPath.row].name
        cell.priceLabel.text = "$\(cartProduct[indexPath.row].price)"
        
        self.selectedIndex = indexPath.row
        cell.btnDelete.tag = indexPath.row
       
        cell.btnDelete.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        let tag = indexPath.row // +1
        cell.tag = tag
        cell.countStepper.addTarget(self,action:#selector(stepperButton(sender:)), for: .touchUpInside)
        cell.countStepper.value = Double(count) //Here you update your view
        cell.qtyLabel.text = "x \(Int(cell.countStepper.value))" //And here
        return cell
    }
    @objc func stepperButton(sender: CartTableViewCell) {
        
        print("UIStepper is now \(Double(sender.countStepper.value))")
        
//        if let indexPath = tableView.indexPath(for: sender.tag){
//            print(indexPath)
//            count = NSInteger(sender.countStepper.value)
//            print(count)
//        }
    }
    @objc func buttonClicked(sender:UIButton!) {
        
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
        let url = "rmcart/ZWNvbW1lcmNl/"
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableView.beginUpdates()
        //self.tableView.insertRows(at: [NSIndexPath(forRow: self.cartProduct.count-1, inSection: 0) as IndexPath], with: UITableViewRowAnimation.fade)
        self.tableView.endUpdates()
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
    
    @IBAction func btnPlaceOrder(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
