//
//  RecipeWebViewController.swift
//  dindin2
//
//  Created by Bryn on 22/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit

class RecipeWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString = PassUrl.url
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if urlString == "" {
            urlString = "http://www.google.com"
        }
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]

        let url = URL(string: urlString)
        
        webView.loadRequest(URLRequest(url: url!))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeRecipe(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        vc.selectedIndex = 1
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
