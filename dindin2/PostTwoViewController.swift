//
//  PostTwoViewController.swift
//  dindin2
//
//  Created by Bryn on 07/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var recipeTitle = ""

class PostTwoViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Variables
    
    //Data From Page 1
    
    //var recipeImage: UIImage
    var recipeDesc = ""
    
    //Data from Current Page
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeInstructions: UITextView!
    @IBOutlet weak var recipeSource: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]
        

        self.recipeSource.delegate = self


        // Do any additional setup after loading the view.
        //let page1 = storyboard?.instantiateViewController(withIdentifier: "postVC")
        //recipeTitle = page1.titleTextField.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        recipeSource.resignFirstResponder()
        return true
    }
    

    
    
    @IBAction func submitRecipe(_ sender: UIButton) {
        if Recipe.title == "" {
            print("add recipe title")
        } else {
            print(Recipe.title)
        }
        let userId = Auth.auth().currentUser?.uid
        Recipe.ingredients = self.recipeIngredients.text
        Recipe.instructions = self.recipeInstructions.text
        var source = self.recipeSource.text
        
        if (source?.contains("http://") == false){
            source = "http://" + source!
        }
        
        //Recipe.source = self.recipeSource.text
        // Add to DB
        let postObject = [
            "userId" : userId,
            "title" : Recipe.title,
            "content" : Recipe.description,
            "image":  Recipe.imageName,
            "ingredients": Recipe.ingredients,
            "instructions": Recipe.instructions,
            "source": source
        ]
        
        Database.database().reference().child("posts").childByAutoId().setValue(postObject)
        
        let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
            self.present(vc!, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        print("Post successful.")
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
