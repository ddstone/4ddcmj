//
//  Project.swift
//  TimeRecorder
//
//  Created by apple on 5/18/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import Foundation

class Project: NSObject, NSCoding {
    let name: String
    let create: NSDate
    var category: Category
    var timeIntervals: [TimeInterval]
    var lastest: NSDate!

    
    init(name: String, category: Category) {
        self.name = name
        self.category = category
        self.create = NSDate()
        self.timeIntervals = [TimeInterval]()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(create, forKey: "create")
        aCoder.encodeObject(category, forKey: "category")
        aCoder.encodeObject(timeIntervals, forKey: "timeIntervals")
        aCoder.encodeObject(lastest, forKey: "lastest")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        create = aDecoder.decodeObjectForKey("create") as! NSDate
        category = aDecoder.decodeObjectForKey("category") as! Category
        timeIntervals = aDecoder.decodeObjectForKey("timeIntervals") as! [TimeInterval]
        lastest = aDecoder.decodeObjectForKey("lastest") as! NSDate!
    }
    
    func addTimeInterval(timeInterval: TimeInterval) {
        timeIntervals.append(timeInterval)
        if lastest == nil {
            lastest = timeInterval.to
        } else {
            switch lastest.compare(timeInterval.to) {
            case .OrderedAscending:
                lastest = timeInterval.to
            default: break
            }
        }
    }
}