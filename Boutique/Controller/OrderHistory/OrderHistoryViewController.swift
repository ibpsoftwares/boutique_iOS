//
//  OrderHistoryViewController.swift
//  Boutique
//
//  Created by Apple on 28/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var orderID =   ["SK12321","SK12331","SK12460"]
    var orderDate =   ["08 jan 2018","08 jan 2018","08 jan 2018"]
    var amount =   ["2000","2400","4000"]
    var status =   ["Order in Process","Order Delivered","Order Cancelled"]
    var image =   ["inProgress","delivered","cencelled"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationController?.navigationBar.isHidden = true
        
        tableView.register(UINib(nibName: "OrderHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        tableView.tableFooterView = UIView()
        
        self.tabBarController?.tabBar.isHidden = true
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
        return orderID.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:OrderHistoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell") as! OrderHistoryTableViewCell!
        cell.orderIDLabel.text = self.orderID[indexPath.row]
        cell.orderDateLabel.text = self.orderDate[indexPath.row]
        cell.amountLabel.text = self.amount[indexPath.row]
        cell.deliveryLabel.text = self.status[indexPath.row]
        cell.img.image = UIImage (named: self.image[indexPath.row])
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
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
