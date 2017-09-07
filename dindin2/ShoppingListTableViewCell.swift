//
//  ShoppingListTableViewCell.swift
//  dindin2
//
//  Created by Bryn on 21/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    // Variables
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var IngredientLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }

}
