//
//  PostTableViewCell.swift
//  dindin2
//
//  Created by Bryn on 28/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class PostTableViewCell: UITableViewCell {

    // MARK: Variables
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var recipeDetailTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //self.recipeTitleLabel.
    }

}
