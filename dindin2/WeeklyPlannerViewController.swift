//
//  WeeklyPlannerViewController.swift
//  dindin2
//
//  Created by Bryn on 28/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Foundation

class WeeklyPlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Variables
    
    let userId = Auth.auth().currentUser?.uid as! String
    @IBOutlet weak var mealPlan: UITableView!
    
    var mealPlanArray = NSMutableArray()
    var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var titleDescription = [String]()
    var imageFile = [String]()
    //var sourceArray = [String]()
    
    //NEW VARIABLES
    var primaryKey = [Int: String]()
    var day = [Int: String]()
    var mealDesc = [Int: String]()
    var imageName = [Int: String]()
    var image = [Int: UIImage?]()
    var source = [Int: String]()
    var ingredients = [Int: String]()

    //let userId = "test01"
    var Imagequery = [String: UIImage]()
    
    //INGREDIENTS DATA STORE
    var store = DataStore.sharedInstance
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Images").path)
    }
    
    var filePath2: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("ShoppingList").path)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mealPlan.delegate = self
        self.mealPlan.dataSource = self
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]
        
        //Load Data
        loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func loadData(){
        let ref = Database.database().reference().child("mealPlan")
        let query = ref.queryOrdered(byChild: "userId").queryEqual(toValue: userId)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            if let mealPlanDictionary = snapshot.value as? [String: AnyObject]{
                for post in mealPlanDictionary{
                    self.mealPlanArray.add(post.value)
                }
                self.mealPlan.reloadData()
                self.loadImages()
                //print("mealPlanDictionaryCount \(mealPlanDictionary.count)")
            }
        
        })
        
    }
    
    func loadImages(){
        let count = self.mealPlanArray.count
        for i in 0..<count{
            let savedMeal = self.mealPlanArray[i] as! [String: AnyObject]
            let imageFile = savedMeal["image"] as! String
            let recipeName = savedMeal["title"] as! String
            if  imageFile != "" {
                let savedImageCount = self.store.imageList.count
                var needToDownload = true
                
                // Check Saved Images for Match
                for x in 0..<savedImageCount{
                    if imageFile == self.store.imageList[x].imageTitle {
                        self.Imagequery[recipeName] = self.store.imageList[x].imageObject
                        needToDownload = false
                        print("image found! ")
                    }
                } // savedImageCount loop
                
                if needToDownload {
                    print("\(i): Prepare to Download Image \(imageFile)")
                    let imageRef = Storage.storage().reference().child("images/\(imageFile)")
                    //print("images/\(self.imageName[i])")
                    imageRef.getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                        if error == nil{
                            //success
                            self.Imagequery[recipeName] = (UIImage(data: data!)!)
                            //print(self.postsImageFile.count)
                            //print("success adding image")
                            self.mealPlan.reloadData()
                            
                        } else {
                            // failure
                            print("Error dling image B: \(String(describing: error?.localizedDescription))")
                        }
                    }) 
                }
                
                
            }
        }
        print("LOAD RECIPE IMAGE")
        print(count)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.days.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Declare Cell as Type "WeeklyPlannerTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeeklyPlannerTableViewCell
        
        //CELL BACKGROUND IMAGE
        
        /*
        UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
        av.backgroundColor = [UIColor clearColor];
        av.opaque = NO;
        av.image = [UIImage imageNamed:@"categorytab1.png"];
        cell.backgroundView = av;
        */
        
        //cell.button.setBackgroundImage(#imageLiteral(resourceName: "whatsForDinner"), for: .normal)
        cell.recipeImage.image = #imageLiteral(resourceName: "whatsForDinner2")
        
        cell.button.tag = indexPath.row
        primaryKey[indexPath.row] = days[indexPath.row]+userId
        day[indexPath.row] = days[indexPath.row]
        mealDesc[indexPath.row] = "Add to your meal plan"

        // Set Default No Meal Display
        cell.dayOfTheWeek.text = days[indexPath.row]
        cell.recipeTitle.text = "Add to your meal plan"
        cell.recipeDescription.alpha = 0
        cell.recipeImage.alpha = 0
        
        // Find meal for given cell day
        let length = mealPlanArray.count

        for i in 0..<length {
            let savedMeal = self.mealPlanArray[i] as! [String: AnyObject]
            let dayName = savedMeal["day"] as? String
            let userIdName = savedMeal["userId"] as? String
            let imageFile = savedMeal["image"] as? String
        
            if(days[indexPath.row] == dayName && userIdName == userId){
                cell.button.setBackgroundImage(nil, for: .normal)
                cell.recipeTitle.text = savedMeal["title"] as? String
                mealDesc[indexPath.row] = (savedMeal["title"] as? String)!
                source[indexPath.row] = savedMeal["source"] as? String
                ingredients[indexPath.row] = savedMeal["ingredients"] as? String
                
                var isIndexValid = Bool()
                
                if imageFile == nil {
                    isIndexValid = false
                } else {
                    isIndexValid = true
                    imageName[indexPath.row] = imageFile!
                }
                
                if isIndexValid {
                    print("index was valid")
                    cell.recipeImage.image = Imagequery[cell.recipeTitle.text!]
                    cell.recipeImage.alpha = 1
                    cell.load.alpha = 0
                } else {
                    print("no index")
                    cell.load.alpha = 0
                }
                
                if mealDesc[indexPath.row] == "I'm Ordering In" {
                    cell.recipeImage.image = #imageLiteral(resourceName: "delivery2")
                    //cell.button.setBackgroundImage(#imageLiteral(resourceName: "delivery"), for: .normal)
                } else if mealDesc[indexPath.row] == "I'm Eating Out" {
                    cell.recipeImage.image = #imageLiteral(resourceName: "restaurant2")
                    //cell.button.setBackgroundImage(#imageLiteral(resourceName: "restaurant"), for: .normal)
                }
                
                
                
                break
            } else {
                
                //cell.recipeImage.image = #imageLiteral(resourceName: "noMeal")
                cell.recipeImage.alpha = 1
                cell.load.alpha = 0
            }
        
        }
        
        
        
        return cell
    }
    
    @IBAction func tap(_ sender: UIButton) {
        let actions = ["I'm Eating Out", "I'm Ordering In", "Go to Recipe Inspiration"]
        
        let notRecipe = ["I'm Eating Out", "I'm Ordering In", "Add to your meal plan"]
        
        //Create Alert to Select Day of the Week
    
        print(mealDesc[sender.tag]!)
        
        // MARK: If Recipe- DISPLAY THE FOLLOWING OPTIONS
        if notRecipe.contains(mealDesc[sender.tag]!) == false {
            //let targetMeal = self.mealPlanArray[sender.tag] as! [String: AnyObject]
            //edit
            let alert = UIAlertController(title: mealDesc[sender.tag], message: "What are we doing?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "View Recipe", style: .default, handler: { (action) in
                //Redirect to View Recipe Page
                print("Redirect to View Recipe Page")
                if let sourceUrl = self.source[sender.tag] {
                    print(sourceUrl)
                    PassUrl.url = sourceUrl
                    
                    let recipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "recipeWebView")
                    self.present(recipeViewController!, animated: true, completion: nil)
                } else {
                    
                    print("trying to redl source")
                    let primarykey = self.days[sender.tag] + self.userId
                    let ref = Database.database().reference().child("mealPlan").child(primarykey)
                    
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let meal = snapshot.value as? [String: AnyObject]{
                            for _ in meal{
                                if let url = meal["source"] {
                                    PassUrl.url = url as! String
                                    
                                    let recipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "recipeWebView")
                                    self.present(recipeViewController!, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                        
                    })
                }
                
                
                
                
            }))
            alert.addAction(UIAlertAction(title: "Add Ingredients to Shopping Cart", style: .default, handler: { (action) in
                print("add to shopping cart")
                //let targetMeal = self.mealPlanArray[sender.tag] as! [String: AnyObject]
                if let ingredientString = self.ingredients[sender.tag] {
                    var ingredientsArray: [String] = []
                    
                    ingredientString.enumerateLines { (line, _) -> () in
                        ingredientsArray.append(line)
                    }
                    
                    print(ingredientsArray.count)
                
                    for i in 0..<ingredientsArray.count {
                        let newItem = ShoppingItem(item: ingredientsArray[i])
                        self.save(item: newItem)
                        print("\(i) : \(ingredientsArray[i])")
                    }
                }
                
                
                //Redirect to View Recipe Page
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingList")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                vc.selectedIndex = 2
                self.present(vc, animated: true, completion: nil)
                

                //self.present(vc!, animated: true, completion: nil)
                
                
                
                
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                let primarykey = self.days[sender.tag] + self.userId
                Database.database().reference().child("mealPlan").child(primarykey).removeValue()
                print("Delete")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                vc.selectedIndex = 1
                self.present(vc, animated: true, completion: nil)
            }))
            
            //add dismiss action
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else if notRecipe.contains(mealDesc[sender.tag]!) {
            //Redirect
            //No Recipe for me tonight
            let alert2 = UIAlertController(title: mealDesc[sender.tag], message: "What's for dinner?", preferredStyle: .actionSheet)
            alert2.addAction(UIAlertAction(title: "Add Recipe from Inspiration Page", style: .default, handler: { (action) in
                //Redirect to View Recipe Page
                print("Add Recipe from Inspiration Page")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                vc.selectedIndex = 0
                self.present(vc, animated: true, completion: nil)


            }))
            alert2.addAction(UIAlertAction(title: "I'm not cooking tonight", style: .default, handler: { (action) in
                //Redirect to View Recipe Page
                print("I'm not cooking tonight")
                
                let alert3 = UIAlertController(title: "Change Meal Plan", message: "What do you want to do?", preferredStyle: .actionSheet)
                
                for i in 0..<2 {
                    alert3.addAction(UIAlertAction(title: actions[i], style: .default, handler: { (action) in
                        //execute some code when this option is selected
                        //day = days[i]
                        
                        let primarykey = self.days[sender.tag] + self.userId
                        
                        let postObject = [
                            "userId" : self.userId,
                            "title" : actions[i],
                            "day" : self.days[sender.tag],
                            "image": "none"
                        ]
                        
                        
                        Database.database().reference().child("mealPlan").child(primarykey).setValue(postObject)
                        
                        print("Posted to DB for: \(self.days[sender.tag]) userId: \(self.userId) title: \(actions[i]) ")
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                        vc.selectedIndex = 1
                        self.present(vc, animated: true, completion: nil)
                        

                        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
                        //self.tabBarController?.selectedIndex = 1
                        //self.present(vc!, animated: true, completion: nil)
                        
                    }))
                    
                }
                
                //add dismiss action
                alert3.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert3, animated: true, completion: nil)

            }))

            
            alert2.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                let primarykey = self.days[sender.tag] + self.userId
                Database.database().reference().child("mealPlan").child(primarykey).removeValue()
                print("Delete")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
                vc.selectedIndex = 1
                self.present(vc, animated: true, completion: nil)
            }))
            
            
            
            //add dismiss action
            alert2.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert2, animated: true, completion: nil)
            
        }
        
        
    }
    
    private func save(item: ShoppingItem) {
        self.store.shoppingList.append(item)
        NSKeyedArchiver.archiveRootObject(self.store.shoppingList, toFile: filePath2)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadShoppingList"), object: nil)
        //print(self.store.shoppingList)
        
    }
    
    
    

}

struct PassUrl {
    static var url = ""
}


