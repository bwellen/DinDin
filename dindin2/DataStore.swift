//
//  DataStore.swift
//  dindin2
//
//  Created by Bryn on 21/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import Foundation
import UIKit

class DataStore {
    static let sharedInstance = DataStore()
    private init(){}
    var shoppingList: [ShoppingItem] = []
    var imageList: [Image] = []
    
    
}
