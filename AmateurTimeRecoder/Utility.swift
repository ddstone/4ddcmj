//
//  Utility.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class Utility {
    static func presentMessage(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        return alert
    }
}