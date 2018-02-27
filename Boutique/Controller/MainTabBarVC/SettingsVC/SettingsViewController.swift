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
        
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowOffset = CGSize.zero
        headerView.layer.shadowRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "ConfirmPasswordViewController") as! ConfirmPasswordViewController
            navigationController?.pushViewController(abcViewController, animated: true)
        }
       else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let abcViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(abcViewController, animated: true)
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
