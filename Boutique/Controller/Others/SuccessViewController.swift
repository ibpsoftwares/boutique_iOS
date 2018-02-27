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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnGotIt(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let abcViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        navigationController?.pushViewController(abcViewController, animated: true)
        
    }

}
