//
//  ShoppingItem.swift
//  dindin2
//
//  Created by Bryn on 21/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import Foundation
import UIKit

class ShoppingItem: NSObject, NSCoding {
    private var _item: String?
    private var _isChecked: Bool?
    
    struct ItemKey {
        static let item = "item"
        static let isChecked = "isChecked"
    }
    
    init(item: String) {
        self._isChecked = false
        self._item = item
    }
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let itemName = aDecoder.decodeObject(forKey: ItemKey.item) as? String {
            _item = itemName
            _isChecked = false
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_item, forKey: ItemKey.item)
        aCoder.encode(_isChecked, forKey: ItemKey.isChecked)
    }
    
    var item: String {
        get {
            return _item!
        }
        set {
            _item = newValue
        }
    }
    
    var isChecked: Bool {
        get {
            return _isChecked!
        }
        set {
            _isChecked = newValue
        }
    }
    
    func click(){
        if _isChecked == true {
            _isChecked = false
        } else {
            _isChecked = true
        }
    }
    
}
