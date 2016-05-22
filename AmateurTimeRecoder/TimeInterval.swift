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
    
    // MARK: - API
    
    func setNewTo(newTo: NSDate) {
        to = newTo
        last = to.timeIntervalSinceDate(from)
    }
}

extension TimeInterval {
    override var description: String {
        let nf = NSDateFormatter()
        nf.dateStyle = .ShortStyle
        nf.timeStyle = .ShortStyle
        return nf.stringFromDate(from) + " -> " + nf.stringFromDate(to) + ": " + "\(last)"
    }
}