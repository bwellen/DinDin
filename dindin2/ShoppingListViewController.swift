//
//  ShoppingListViewController.swift
//  dindin2
//
//  Created by Bryn on 01/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ingredientList = ["apples", "lemons", "limes"]
    var store = DataStore.sharedInstance
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("ShoppingList").path)
    }

    
    @IBOutlet weak var ingredientTV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadShoppingList"), object: nil)
        
        self.ingredientTV.delegate = self
        self.ingredientTV.dataSource = self
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]

        /*
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Mistress Script", size: 25)!, NSForegroundColorAttributeName: UIColor.black]
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func loadData(){
        print("hihi loading data plese")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ShoppingItem] {
            self.store.shoppingList = data
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShoppingListTableViewCell
        
        cell.IngredientLabel.text = self.store.shoppingList[indexPath.row].item
        cell.checkBox.tag = indexPath.row
        var isChecked = self.store.shoppingList[indexPath.row].isChecked
        if isChecked {
            cell.checkBox.isChecked = true
        }
        
        return cell
    }
    

    @IBAction func addToList(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addToShoppingList")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func clickCheckBox(_ sender: UIButton) {
        print("click")
        print(self.store.shoppingList[sender.tag].isChecked)
        var item = self.store.shoppingList[sender.tag]
        var newItem = ShoppingItem(item: item.item)
        newItem.click()
        print("new: \(newItem.isChecked)")
        self.store.shoppingList[sender.tag] = newItem
        NSKeyValueChange.replacement
        
    }
    
    private func editShoppingList(item: ShoppingItem, tag: Int) {
        print("in edit method")
        self.store.shoppingList[tag] = item
        print(self.store.shoppingList[tag].isChecked)
        NSKeyedArchiver.archiveRootObject(self.store.shoppingList, toFile: filePath)
    }
    
    
    @IBAction func deleteShoppingList(_ sender: UIBarButtonItem) {
        print("in delete")
        // Create Fetch Request
        self.store.shoppingList.removeAll()
        NSKeyedArchiver.archiveRootObject(self.store.shoppingList, toFile: filePath)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadShoppingList"), object: nil)
        
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
