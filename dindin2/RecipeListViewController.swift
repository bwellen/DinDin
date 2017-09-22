//
//  recipeListViewController.swift
//  dindin2
//
//  Created by Bryn on 28/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import os.log


class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //REMOVED UITableViewDelegate, UITableViewDataSource
    
    // MARK: Variables
    @IBOutlet weak var postTableView: UITableView!
    var posts = NSMutableArray()
    var postsPic = NSMutableArray()
    var postsImageFile = [UIImage]()
    var imageDictionary = [Int: UIImage]()
    var imageName = [String]()
    
    var store = DataStore.sharedInstance
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]

        loadData()
        

    }
    
    func loadData(){
        var i = 0
        //Load Text Data
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject]{
                for post in postsDictionary{
                    self.posts.add(post.value)
                    var holder = self.posts[i] as! [String: AnyObject]
                    self.imageName.append(holder["image"] as! String)
                    //print(holder["image"] as! String)
                    i += 1
                }
                self.postTableView.reloadData()
                //print("Location: self.postTableView.reloadData() l.45")
                self.loadImages()
            }
        })
    }
    
    func loadImages() {
        
        let rCount = self.imageName.count
        
        for i in 0..<rCount {
            //print(self.imageName[i])
            if self.imageName[i] != "" {
                let savedImageCount = self.store.imageList.count
                var needToDownload = true
                
                // Check Saved Images for Match
                for x in 0..<savedImageCount{
                    if self.imageName[i] == self.store.imageList[x].imageTitle {
                        self.imageDictionary[i] = self.store.imageList[x].imageObject
                        needToDownload = false
                    }
                } // savedImageCount loop
                
                // Download Image if no Match
                if needToDownload {
                    let imageRef = Storage.storage().reference().child("images/\(self.imageName[i])")
                    //print("images/\(self.imageName[i])")
                    imageRef.getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                        if error == nil{
                            //success
                            self.imageDictionary[i] = (UIImage(data: data!)!)
                            self.postTableView.reloadData()
                            
                            // Add Image to Dictionary
                            let newImage = Image(title: self.imageName[i], image: self.imageDictionary[i]!)
                            self.save(imageObject: newImage)
                            print(self.store.imageList)
                            
                        } else {
                            // failure
                            //print("Error dling image B: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            }
            
        }
        self.postTableView.reloadData()
    }
    
    /*
    //persistent data
    
    private func saveMeals(){
        let isSaveSuccessfulSave = NSKeyedArchiver.archiveRootObject(mealPlan, toFile: Meal.ArchiveURL.path)
        
        if isSaveSuccessfulSave {
            os_log("Meal sucsessfully saved to meal plan.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to log saved meals", log: OSLog.default, type: .error)
        }
        
    }
    */
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("Location: number of sections")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("Location: table view l.85")
        return self.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostTableViewCell
        //print("table view function")

        /*
        cell.recipeTitleLabel.alpha = 0
        cell.recipeDetailTextView.alpha = 0
        cell.postImageView.alpha = 0
        */
 
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.recipeTitleLabel.text = post["title"] as? String
        cell.recipeDetailTextView.text = post["content"] as? String
        
        //let isIndexValid = array.indices.contains(index)
        var isIndexValid = Bool()
        //let isIndexValid = self.postsImageFile.indices.contains(indexPath.row)
        if imageDictionary[indexPath.row] == nil {
            isIndexValid = false
        } else {
            isIndexValid = true
        }
        
        if isIndexValid {
            cell.load.alpha = 0
            cell.postImageView.image = imageDictionary[indexPath.row]
        } else {
            cell.load.alpha = 1
            //print(indexPath.row)
            //print("still loading plese")
        }
        
        //Turn Image into a button
        cell.imageButton.setTitle(post["title"] as? String, for: .disabled)
        cell.imageButton.tag = indexPath.row
        
        return cell
    }
    

    @IBAction func addRecipe(_ sender: UIButton) {
        
        // Function: This Button will add MealPlan to the DataBase
        let selectedRecipe = self.posts[sender.tag] as! [String: AnyObject]

        let userId = Auth.auth().currentUser?.uid
        let title = sender.title(for: .disabled)
        var day = "None"
        var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let image = imageName[sender.tag]
        let ingredients = selectedRecipe["ingredients"] as? String
        let instructions = selectedRecipe["instructions"] as? String
        let source = selectedRecipe["source"] as? String
        
        //Create Alert to Select Day of the Week
        
        let alert = UIAlertController(title: "Add Recipe to your Meal Plan", message: "Which day?", preferredStyle: .actionSheet)
        
        
        
        for i in 0..<7 {
            alert.addAction(UIAlertAction(title: days[i], style: .default, handler: { (action) in
                //execute some code when this option is selected
                day = days[i]
                
                let primarykey = day + userId!
                
                let postObject = [
                    "userId" : userId,
                    "title" : title,
                    "day" : day,
                    "image": image,
                    "ingredients": ingredients,
                    "instructions": instructions,
                    "source": source
                ]
                
                
                Database.database().reference().child("mealPlan").child(primarykey).setValue(postObject)
                
                print("Posted to DB for: \(day) userId: \(userId) title: \(title) image: \(image)")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadShoppingList"), object: nil)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                vc.selectedIndex = 1
                self.present(vc, animated: true, completion: nil)
                
            }))
 
        }
        
        //add dismiss action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    @IBAction func composeRecipe(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addRecipe")
        self.present(vc!, animated: true, completion: nil)
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Images").path)
    }
    
    private func save(imageObject: Image) {
        self.store.imageList.append(imageObject)
        NSKeyedArchiver.archiveRootObject(self.store.imageList, toFile: filePath)
    }

}



