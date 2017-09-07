//
//  WeeklyPlannerTableViewCell.swift
//  dindin2
//
//  Created by Bryn on 28/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class WeeklyPlannerTableViewCell: UITableViewCell {
    
    // MARK: Weekly Planner Meal Variables
    
    @IBOutlet weak var dayOfTheWeek: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var load: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
