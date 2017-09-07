//
//  ViewController.swift
//  dindin2
//
//  Created by Bryn on 26/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return(true)
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //If user is logged in display homepage
        if Auth.auth().currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "recipeListVC")
            self.present(vc!, animated: true, completion: nil)
        }
        
    }
 */

    @IBAction func loginPressed(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        //firebase.Auth().signin
        Auth.auth().signIn(withEmail: username!, password: password!) { (user, error) in
            if error != nil{
                //if error
                let alert = UIAlertController(title: "Error", message: "Incorrect Username/Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                //success
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
                self.present(vc!, animated: true, completion: nil)
            }
        }
        
    }

}

