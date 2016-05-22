//
//  DurationPickerViewController.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/22/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class DurationPickerViewController: UIViewController
{
    var duration: NSTimeInterval?
    
    weak var delegate: AdjustDateAccordingToDuration?
    
    @IBOutlet weak var durationPicker: UIDatePicker!
    
    @IBAction func ok() {
        dismissViewControllerAnimated(true) {
            self.delegate?.adjustDateAccordingToDuration(self.durationPicker.countDownDuration)
        }
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        durationPicker.countDownDuration = duration!
    }
}

protocol AdjustDateAccordingToDuration: class {
    func adjustDateAccordingToDuration(timeIntervals: NSTimeInterval)
}
