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
    static let appBaseURL = "http://kftsoftwares.com/ecomm/recipes"  // assign your base url suppose:  http://www.stack.com/index.php
    static let apiLogin = "login/"   // assign signup i.e: signup
    static let accessToken = "Bearer ZWNvbW1lcmNl"
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
    
    class func apiPost (apiURl:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping (NSDictionary,_ Error:NSError?) -> ()){
        
        let headers = ["Authorization":"Bearer ZWNvbW1lcmNl"]
        var strURL:String = FV_API.appBaseURL  // it gives http://www.stack.com/index.php and apiURl is apiSignUP
        
        if((apiURl as NSString).length > 0)
        {
            strURL = strURL + "/" + apiURl    // this gives again http://www.stack.com/index.php/signup
        }
        
        
        Alamofire.request(strURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            print("Request  \(String(describing: response.request))")
//            print("RESPONSE \(String(describing: response.result.value))")
//            print("RESPONSE \(response.result)")
            print("RESPONSE \(response)")
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    completionHandler(response.result.value as! NSDictionary,nil)
                }
                break
                
            case .failure(_):
                
                 print("RESPONSE \(response.result)")
                completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
                break
                
            }        }
    }
    
     //MARK:- POST APIs
//    class func apiPost(serviceName:String,parameters: [String:Any]?,headers:[String:Any]?, completionHandler: @escaping (NSDictionary,_ Error:NSError?) -> ()) {
//        
//        Alamofire.request(serviceName, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            
//            switch(response.result) {
//            case .success(_):
//                if response.result.value != nil  {
//                    completionHandler(response.result.value as! NSDictionary ,nil)
//                }
//                break
//            case .failure(_):
//              
//                completionHandler([:],response.result.error as NSError?)
//                //completionHandler(response.result.value as! NSDictionary,response.result.error as NSError?)
//                break
//                
//            }
//        }
//    }
    
     //MARK:- GET APIs
    class func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (NSDictionary, NSError?) -> ()) {
        
        Alamofire.request(serviceName, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
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


