//
//  OrderHistoryViewController.swift
//  Boutique
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class orderDetail {
    var id: String
    var categoryID: String
    var date: String
    var status: String
    var name: String
    var qty: String
   var amount: String
    var orderID : String
    var image : String
    init(id: String,categoryID : String,date : String,status : String,name : String,qty : String,amount : String,orderID : String,image: String) {
        
        self.id = id
        self.categoryID = categoryID
        self.date = date
        self.status = status
        self.name = name
        self.qty = qty
        self.amount = amount
        self.orderID = orderID
        self.image = image
    }
}
class OrderHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var orderID =   ["SK12321","SK12331","SK12460"]
    var orderDate =   ["08 jan 2018","08 jan 2018","08 jan 2018"]
    var amount =   ["2000","2400","4000"]
    var status =   ["Order in Process","Order Delivered","Order Cancelled"]
    var image =   ["inProgress","delivered","cencelled"]
    var order = [orderDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationController?.navigationBar.isHidden = true
        
        tableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = true
        orderDetailAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Order History API
    func orderDetailAPI(){
        self.order.removeAll()
        let parameters: Parameters = [
            "user_id": Model.sharedInstance.userID
            ]
        print(parameters)
        Webservice.apiPost(apiURl: "orderHistory/", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            for item in ((response)?.value(forKey: "orderDetail") as! NSArray){
                print(item)
                self.order.append(orderDetail.init(id: ((item as! NSDictionary).value(forKey: "cloth_id") as! String), categoryID: ((item as! NSDictionary).value(forKey: "category_id") as! String), date: ((item as! NSDictionary).value(forKey: "created") as! String), status: ((item as! NSDictionary).value(forKey: "status") as! String), name: ((item as! NSDictionary).value(forKey: "title") as! String), qty: ((item as! NSDictionary).value(forKey: "quantity") as! String), amount: ((item as! NSDictionary).value(forKey: "price") as! String), orderID: ((item as! NSDictionary).value(forKey: "order_id") as! String), image: ((item as! NSDictionary).value(forKey: "image") as! String)))
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }


    //MARK: TableView Delegate and Data Source
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:OrderHistoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell") as! OrderHistoryTableViewCell!
        
//        let dateFromStringFormatter = DateFormatter()
//        dateFromStringFormatter.dateFormat = "YYYY-MM-dd"
//
//        let date = self.order[indexPath.row].date
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let dateFromString : NSDate = dateFormatter.date(from: date)! as NSDate
//       // dateFormatter.dateFormat = "dd-MM-yyyy"
//        let datenew = dateFormatter.string(from: dateFromString as Date)
//        print(datenew)
        
        cell.orderDateLabel.text = "12/06/2015"
      
        cell.orderIDLabel.text = ("SKU\(self.order[indexPath.row].id)")
       // cell.amountLabel.text = ("\(Model.sharedInstance.currency)\(self.order[indexPath.row].amount)")
        cell.nameLabel.text = self.order[indexPath.row].name
        cell.qtyLabel.text = ("Quantity : \(self.order[indexPath.row].qty)")
        cell.priceLabel.text = ("\(Model.sharedInstance.currency)\(self.order[indexPath.row].amount)")
       
        cell.productImg.layer.cornerRadius =  cell.productImg.frame.size.height / 2
        cell.productImg.clipsToBounds = true
        let url = URL(string: self.order[indexPath.row].image )
        cell.productImg.kf.indicatorType = .activity
        cell.productImg.kf.setImage(with: url,placeholder: nil)
        if self.order [indexPath.row].status == "3"{
            cell.deliveryLabel.text = "Placed"
            cell.img.image = UIImage(named: "inProgress")
        }
        else if self.order [indexPath.row].status == "4"{
            cell.deliveryLabel.text = "Shipped"
             cell.img.image = UIImage(named: "inProgress")
        }
        else if self.order [indexPath.row].status == "5"{
            cell.deliveryLabel.text = "Delivered"
             cell.img.image = UIImage(named: "delivered")
        }
        else if self.order [indexPath.row].status == "6"{
            cell.deliveryLabel.text = "Cancelled"
            cell.img.image = UIImage(named: "cencelled")
        }
        //cell.deliveryLabel.text = self.status[indexPath.row]
        //cell.img.image = UIImage (named: self.image[indexPath.row])
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension UITabBarController {
    func setTabBarVisible(visible:Bool, animated:Bool) {
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            //self.tabBar.frame = CGRect.offsetBy(frame, 0)
            self.view.frame = CGRect(x:0,y: 0, width:self.view.frame.width,height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
}
