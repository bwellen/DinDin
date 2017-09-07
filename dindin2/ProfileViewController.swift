//
//  ProfileViewController.swift
//  dindin2
//
//  Created by Bryn on 01/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    let userId = Auth.auth().currentUser?.uid as! String
    let userEmail = Auth.auth().currentUser?.email as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]

        /*
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]

        self.userNameLabel.text = "User Name: \(userId)"
        self.emailLabel.text = "Email: \(userEmail)"
        // Do any additional setup after loading the view.
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    func loadData(){
        Database.database().reference().child("mealPlan").observeSingleEvent(of: .value, with: { (snapshot) in
            if let mealPlanDictionary = snapshot.value as? [String: AnyObject]{
                for post in mealPlanDictionary{
                    self.mealPlanArray.add(post.value)
                }
                self.mealPlan.reloadData()
                print("mealPlanDictionaryCount \(mealPlanDictionary.count)")
            }
            
        })
    }

    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
