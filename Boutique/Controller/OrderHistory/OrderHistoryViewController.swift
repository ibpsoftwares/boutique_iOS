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
