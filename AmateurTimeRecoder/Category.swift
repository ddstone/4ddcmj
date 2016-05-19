//
//  Category.swift
//  TimeRecorder
//
//  Created by apple on 5/17/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import Foundation

class Category: NSObject, NSCoding
{
    let name: String
    
    var create = NSDate()
    
    init(name: String) {
        self.name = name
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(create, forKey: "create")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        create = aDecoder.decodeObjectForKey("create") as! NSDate
    }
}