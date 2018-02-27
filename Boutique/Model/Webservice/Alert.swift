//
//  Alert.swift
//  Boutique
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Alert: NSObject {
    //MARK: Alert Method
    static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
         alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
