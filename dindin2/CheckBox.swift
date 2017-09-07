//
//  CheckBox.swift
//  dindin2
//
//  Created by Bryn on 21/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //let checkedBoxImage = #imageLiteral(resourceName: "checkedBox")
    //let uncheckedImage = #imageLiteral(resourceName: "uncheckedBox")
    
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(#imageLiteral(resourceName: "checkedBox"), for: UIControlState.normal)
            } else {
                self.setImage(#imageLiteral(resourceName: "uncheckedBox"), for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            //
        }
    }
}
