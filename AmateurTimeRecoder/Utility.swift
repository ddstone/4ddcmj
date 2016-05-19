//
//  Utility.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class Utility {
    static func presentTwoButtonAlert(controller: UIViewController, title: String, message: String, fun: (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: fun))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func toCost(seconds: Double) -> String {
        let nf = NSNumberFormatter()
        nf.maximumFractionDigits = 1
        switch seconds / 3600 {
        case let hours where hours > 1:
            return "\(nf.stringFromNumber(hours)!) 小时"
        default:
            return "\(nf.stringFromNumber(seconds / 60)!) 分钟"
        }
    }
}