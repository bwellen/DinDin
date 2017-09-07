//
//  PostViewController.swift
//  dindin2
//
//  Created by Bryn on 26/07/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    // MARK: Variables
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var imageFileName = ""
    
    
    //recipeTitle = self.titleTextField.text
    // Mark: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigation Bar Style
        let myFont = UIFont.boldSystemFont(ofSize: 22)
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: myFont, NSForegroundColorAttributeName: UIColor.black]
        /*
        //Change Header to Black Background White Font with Brand Font
        //self.navigationController?.navigationBar.alpha = 0
        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica", size: 20)!, NSForegroundColorAttributeName: UIColor.black]
        */
        
        // Do any additional setup after loading the view.
        
        self.titleTextField.delegate = self
        //self.contentTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presCancel(_ sender: UIBarButtonItem) {
        print("cancel button pressed")
        self.titleTextField.text = ""
        self.contentTextView.text = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    func randomStringWithLength(length: Int) -> NSString {
        let characters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: NSMutableString = NSMutableString(capacity: length)
        
        for i in 0..<length {
            var len = UInt32(characters.length)
            var rand = arc4random_uniform(len)
            randomString.appendFormat("%C", characters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    @IBAction func postPressed(_ sender: Any) {
        let userId = Auth.auth().currentUser?.uid
        let title = titleTextField.text
        let content = contentTextView.text
        
        let postObject = [
            "userId" : userId,
            "title" : title,
            "content" : content,
            "image":  imageFileName
        ]
        
        Database.database().reference().child("posts").childByAutoId().setValue(postObject)
        
        let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        print("Post successful.")
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        print(self.contentTextView.text!)
        Recipe.description = self.contentTextView.text!
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){
        let imageName = randomStringWithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let uploadRef = Storage.storage().reference().child("images/\(imageName).jpg")
        
        let uploadTask = uploadRef.putData(imageData!, metadata: nil) { metadata,
            error in
            if error == nil {
                //success
                print("Success")
                self.imageFileName =  "\(imageName as String).jpg"
                Recipe.imageName = self.imageFileName
            } else {
                //fail
                print(" \(String(describing: error?.localizedDescription))")
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //execute if user hits cancel
        picker.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //execute if user selects an image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image =  pickedImage
            Recipe.image = pickedImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
            
        } else {
            print ("error")
        }
        
        
        //self.previewImageView.image =  selectedImage
        self.selectImageButton.isEnabled = false
        self.selectImageButton.isHidden = true
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Mark: Editing Actions
    
    @IBAction func changeName(_ sender: UITextField) {
        Recipe.title = self.titleTextField.text!
        print(self.titleTextField.text!)
    }
    
    func textViewDidChange(_ textView: UITextView){
        print(self.contentTextView.text!)
        Recipe.description = self.contentTextView.text!
    }
    
    
    
    
 
    
}

struct Recipe {
    static var title = ""
    static var description = ""
    static var ingredients = ""
    static var image: UIImage?
    static var imageName = ""
    static var instructions = ""
}
