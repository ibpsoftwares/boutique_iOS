//
//  SuccessViewController.swift
//  Boutique
//
//  Created by Apple on 22/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

     @IBOutlet var btnGotIt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.btnGotIt.layer.cornerRadius = 19
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tabBarController?.tabBar.isHidden = false
        
    }

    @IBAction func btnGotIt(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        navigationController?.pushViewController(abcViewController, animated: true)
        
    }

}
