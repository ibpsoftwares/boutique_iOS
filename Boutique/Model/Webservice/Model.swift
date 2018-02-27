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
    var badgeValue = String()
    var cartCount = Int()
    
}
