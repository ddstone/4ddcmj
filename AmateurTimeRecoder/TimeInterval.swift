//
//  TimeInterval.swift
//  TimeRecorder
//
//  Created by apple on 5/18/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import Foundation

class TimeInterval: NSObject, NSCoding {
    var from: NSDate
    var to: NSDate
    var last: Double
    
    init(from: NSDate, to: NSDate) {
        self.from = from
        self.to = to
        last = to.timeIntervalSinceDate(from)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(from, forKey: "from")
        aCoder.encodeObject(to, forKey: "to")
        aCoder.encodeObject(last, forKey: "last")
    }
    
    required init?(coder aDecoder: NSCoder) {
        from = aDecoder.decodeObjectForKey("from") as! NSDate
        to = aDecoder.decodeObjectForKey("to") as! NSDate
        last = aDecoder.decodeObjectForKey("last") as! Double
    }
}
