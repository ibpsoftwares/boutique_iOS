//
//  SettingsViewController.swift
//  Boutique
//
//  Created by Apple on 13/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    let items = ["Help", "Profile", "Change Password", "History","Sign out"]
    let images = ["help", "profileImg", "setting1", "history","signout"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//
//    }
    //MARK: TableView Delegate and Data Source
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:SettingTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! SettingTableViewCell!
        
        // set the text from the data model
        cell.titleLabel.text = self.items[indexPath.row]
        cell.imgView.image = UIImage (named: self.images[indexPath.row])
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        if indexPath.row == 0{
            openURL("http://www.vinsol.com")
        }
        else if indexPath.row == 1{
            //openURL("http://www.vinsol.com/contact")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
        if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmPasswordViewController") as! ConfirmPasswordViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
        else if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
       else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 10.0, *) {
                let abcViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                 Model.sharedInstance.userID = ""
                navigationController?.pushViewController(abcViewController, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
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
