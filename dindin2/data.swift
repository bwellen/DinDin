//
//  data.swift
//  dindin2
//
//  Created by Bryn on 13/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class Recipes {
    var title = ""
    var userId = ""
    var description = ""
    var ingredients = ""
    var instructions = ""
    var source = ""
    var fileName = ""
    var image : UIImage!
    
    /*
    func setValues(title, description, ingredients, instructions, _: fileName ) {
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.instructions = instructions
        self.fileName = fileName
    }
 */
}

class RecipeList {
    var dictionary = [String: Recipes]()
    
    func loadData() {
        print("IN LOAD DATA")
        var posts = NSMutableArray()
        var i = 0
        //Load Text Data
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject]{
                for post in postsDictionary{
                    posts.add(post.value)
                    var holder = posts[i] as! [String: AnyObject]
                    let recipeInstance = Recipes()
                    print("recipe added in load data")
                    recipeInstance.title = holder["title"] as! String
                    recipeInstance.userId = holder["userId"] as! String
                    recipeInstance.description = holder["content"] as! String
                    recipeInstance.ingredients = holder["ingredients"] as! String
                    recipeInstance.instructions = holder["instructions"] as! String
                    recipeInstance.fileName = holder["image"] as! String
                    self.dictionary[recipeInstance.title] = recipeInstance
                    i += 1
                }
            }
        })
        print("FINISHED LOAD DATA")
        loadImages()
    }
    
    func loadImages() {
        print("IN LOAD IMAGES")
        for i in 0..<dictionary.count {
            let key = Array(dictionary.keys)[i]
            let fileName = dictionary[key]?.fileName
            if fileName != "" {
                print("\(i): Prepare to Download Image")
                let imageRef = Storage.storage().reference().child("images/\(String(describing: fileName))")
                print("images/\(String(describing: fileName))")
                imageRef.getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                    if error == nil{
                        //success
                        self.dictionary[key]?.image = (UIImage(data: data!)!)
                        print("success adding image")
                        
                    } else {
                        // failure
                        print("Error dling image B: \(String(describing: error?.localizedDescription))")
                    }
                })
            }
        }
        print("LOAD IMAGES HAS FINISHED")
    }


    
}



class ShoppingList {
    
}
