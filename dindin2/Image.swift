//
//  Image.swift
//  dindin2
//
//  Created by Bryn on 22/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import Foundation
import UIKit

class Image: NSObject, NSCoding {
    
    //Properties
    private var title: String?
    private var image: UIImage?
    
    struct ImageKey {
        static let title = "title"
        static let image = "image"
    }

    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
    }
    
    override init(){}
    
    required init?(coder aDecoder: NSCoder){
        if let imageName = aDecoder.decodeObject(forKey: ImageKey.title) as? String {
            title = imageName
            if let photo = aDecoder.decodeObject(forKey: ImageKey.image) as? UIImage {
                image = photo
            }
        }
        
        
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(title, forKey: ImageKey.title)
        aCoder.encode(image, forKey: ImageKey.image)

    }
    
    var imageTitle: String {
        get{
            return title!
        }
        set {
            title = newValue
        }
    }
    
    var imageObject: UIImage {
        get {
            return image!
        }
        set {
            image = newValue
        }
    }
    
    
}
