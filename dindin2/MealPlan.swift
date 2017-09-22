//
//  MealPlan.swift
//  dindin2
//
//  Created by Bryn on 14/08/2017.
//  Copyright © 2017 Bryn. All rights reserved.
//

import UIKit
import os.log

class MealPlan: NSObject, NSCoding {
    
    // MARK: Properties
    
    var primaryKey: String?
    var userId: String?
    var day: String?
    var title: String?
    var photo: UIImage?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mealPlan")
    
    // MARK: Types
    
    struct PropertyKey {
        static let primaryKey = "primaryKey"
        static let userId = "userId"
        static let day = "day"
        static let title = "title"
        static let photo = "photo"
    }
    
    init(userId: String, day: String, title: String, photo: UIImage?){
        // Initialize stored properties.
        self.userId = userId
        self.day = day
        self.title = title
        self.photo = photo
        self.primaryKey = day + userId
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        //aCoder.encode(primaryKey, forKey: PropertyKey.primaryKey)
        aCoder.encode(userId, forKey: PropertyKey.userId)
        aCoder.encode(day, forKey: PropertyKey.day)
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //required title
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
            else {
                os_log("Unable to decode the name for MealPlan object", log: OSLog.default, type: .debug)
                return nil
        }
        
        //let primaryKey = aDecoder.decodeObject(forKey: PropertyKey.primaryKey) as? String
        let userId = aDecoder.decodeObject(forKey: PropertyKey.userId) as? String
        let day = aDecoder.decodeObject(forKey: PropertyKey.day) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage

        
        self.init(userId: userId!, day: day!, title: title, photo: photo!)
    }
    
}

