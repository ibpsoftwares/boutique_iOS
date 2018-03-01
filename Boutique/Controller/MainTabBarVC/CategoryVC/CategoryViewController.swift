//
//  CategoryViewController.swift
//  Boutique
//
//  Created by Apple on 14/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//


//http://kftsoftwares.com/ecom/recipes/getbycategory/54659/ZWNvbW1lcmNl/
import UIKit
import LUExpandableTableView
import Alamofire
import SKActivityIndicatorView

class getCategory {
    var category: String
    
    init(category: String) {
        self.category = category
       
    }
}
class getCategoryName {
    var categoryName: String
    var id: String
    
    init(categoryName: String,id : String) {
        self.categoryName = categoryName
        self.id = id
        
    }
}
class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let expandableTableView = LUExpandableTableView()
    private let cellReuseIdentifier = "MyCell"
    private let sectionHeaderReuseIdentifier = "MySectionHeader"
     var category = [getCategory]()
     var categoryName = [getCategoryName]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    var dataArray = NSMutableArray()
    var array: [[NSDictionary]] = []
    
    let items = ["Shoes", "Glass", "Mobile", "Laptop","Jeans","Clothes","accessories","Kids Toy"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.tableFooterView = UIView()
        
//        view.addSubview(expandableTableView)
//        expandableTableView.register(MyTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
//        expandableTableView.register(UINib(nibName: "MyExpandableTableViewSectionHeader", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
//
//        expandableTableView.expandableTableViewDataSource = self
//        expandableTableView.expandableTableViewDelegate = self
//        expandableTableView.tableFooterView = UIView()
        self.getCategoryAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        expandableTableView.frame = view.bounds
        expandableTableView.frame.origin.y += 65
    }
    
    //MARK: getProductAPI Methods
   func getCategoryAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        
    Webservice.apiPost(serviceName: "http://kftsoftwares.com/ecom/recipes/viewCategories/ZWNvbW1lcmNl/", parameters: nil, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                for item in (response!.value(forKey: "categories") as! NSArray) {
                    self.categoryName.append(getCategoryName.init(categoryName: (item as! NSDictionary).value(forKey: "name") as! String, id: (item as! NSDictionary).value(forKey: "id") as! String))
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }

    //MARK: TableView Delegate and Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:CategoryTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell!
        cell.itemNameLabel.text = self.categoryName[indexPath.row].categoryName
        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        categoryViewController.categoryID = self.categoryName[indexPath.row].id
        navigationController?.pushViewController(categoryViewController, animated: true)

    }
    
}
// MARK: - LUExpandableTableViewDataSource
/*
extension CategoryViewController: LUExpandableTableViewDataSource {
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return self.category.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return self.array[section].count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MyTableViewCell else {
            assertionFailure("Cell shouldn't be nil")
            return UITableViewCell()
        }
        
        //cell.label.text = "Cell at row \(indexPath.row) section \(indexPath.section)"
        cell.label.text = (self.array[indexPath.row][indexPath.section] ).value(forKey: "category_name") as? String
        return cell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? MyExpandableTableViewSectionHeader else {
            assertionFailure("Section header shouldn't be nil")
            return LUExpandableTableViewSectionHeader()
        }
        
        //sectionHeader.label.text = "Section \(section)"
        sectionHeader.label.text = self.category[section].category
        
        return sectionHeader
    }
}

// MARK: - LUExpandableTableViewDelegate

extension CategoryViewController: LUExpandableTableViewDelegate {
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 50
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 69
    }
    
    // MARK: - Optional
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        print("Did select section header at section \(section)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
        print("Will display section header for section \(section)")
    }
}
*/
