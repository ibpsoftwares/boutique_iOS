//
//  Webservice.swift
//  Boutique
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire

struct FV_API
{
    //URL is http://www.stack.com/index.php/signup
    static let appBaseURL = "http://kftsoftwares.com/ecom/recipes/"  // assign your base url suppose:  http://www.stack.com/index.php
    static let apiLogin = "login/"   // assign signup i.e: signup
}

class Webservice: NSObject
{
    //MARK:- POST APIs
    class func postAPI(_ apiURl:String, parameters:NSDictionary, completionHandler: @escaping (_ Result:AnyObject?, _ Error:NSError?) -> Void)
    {
        var strURL:String = FV_API.appBaseURL  // it gives http://www.stack.com/index.php and apiURl is apiSignUP
        
        if((apiURl as NSString).length > 0)
        {
            strURL = strURL + "/" + apiURl    // this gives again http://www.stack.com/index.php/signup
        }
        
        _ = ["Content-Type": "application/x-www-form-urlencoded"]
        
        print("URL -\(strURL),parameters - \(parameters)")
        
        let api =  Alamofire.request(strURL,method: .post, parameters: parameters as? [String : AnyObject], encoding: URLEncoding.default)
        
        // ParameterEncoding.URL
        api.responseJSON
            {
                response -> Void in
                
                print(response)
                
                if let JSON = response.result.value
                {
                    print("JSON: \(JSON)")
                    completionHandler(JSON as AnyObject?, nil)
                }
                else if let ERROR = response.result.error
                {
                    print("Error: \(ERROR)")
                    completionHandler(nil, ERROR as NSError?)
                }
                else
                {
                    completionHandler(nil, NSError(domain: "error", code: 117, userInfo: nil))
                }
        }
  }
    
     //MARK:- POST APIs
    class func apiPost(serviceName:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping (NSDictionary,_ Error:NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value  {
                    completionHandler(response.result.value as! NSDictionary ,nil)
                }
                break
            case .failure(_):
              
                completionHandler([:],response.result.error as NSError?)
                //completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
                break
                
            }
        }
    }
    
     //MARK:- GET APIs
    class func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (NSDictionary, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    completionHandler(response.result.value as! NSDictionary,nil)
                }
                break
                
            case .failure(_):
                completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
                break
                
            }
        }
    }
}


