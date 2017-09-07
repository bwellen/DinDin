//
//  AddToShoppingListViewController.swift
//  dindin2
//
//  Created by Bryn on 21/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class AddToShoppingListViewController: UIViewController {
    
    
    @IBOutlet weak var itemField: UITextField!
    var store = DataStore.sharedInstance
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("ShoppingList").path)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem(_ sender: Any) {
        if itemField.text != "" {
            if let text = itemField.text {
                let newItem = ShoppingItem(item: text)
                self.save(item: newItem)
            }
        }
        
        print(self.store.shoppingList[0].item)
        
    }
    
    private func save(item: ShoppingItem) {
        self.store.shoppingList.append(item)
        NSKeyedArchiver.archiveRootObject(self.store.shoppingList, toFile: filePath)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadShoppingList"), object: nil)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
    }
    
    private func loadData(){
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ShoppingItem] {
            self.store.shoppingList = data
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
        self.present(vc!, animated: true, completion: nil)
        */
        
        //tabBarController?.selectedIndex = 2
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        vc.selectedIndex = 2
        self.present(vc, animated: true, completion: nil)
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
