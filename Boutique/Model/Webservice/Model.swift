//
//  Model.swift
//  Boutique
//
//  Created by Apple on 16/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

final class Model {
    
    // Can't init is singleton
    public init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: Model = Model()
    
    //MARK: Local Variable
    
    var userID = String()
     var currency = String()
    var badgeValue = String()
    var cartCount = Int()
    var totalPrice = Double()
    var  totalAmt = String()
     var  paymentType = String()
    var tempData = NSMutableDictionary()
     var lacalDataArr = NSMutableArray()
    var loginData = NSMutableDictionary()
     var checkoutData: [Dictionary<String, AnyObject>] = []
    
    
}
final class localDatabase {
    //MARK: Shared Instance
    
    static let sharedInstance: Model = Model()
    
    var name: String
    var price: String
    var image: String
    var id : String
    var oldPrice : String
    var brandName : String
    var wishlistID : String
    init(name: String,price: String,image: String,id: String,oldPrice: String,brandName: String,wishlistID : String) {
        self.name = name
        self.price = price
        self.image = image
        self.id = id
        self.oldPrice = oldPrice
        self.brandName = brandName
        self.wishlistID = wishlistID
    }
    
    func myFunction() -> String {
        return ""
    }
}
