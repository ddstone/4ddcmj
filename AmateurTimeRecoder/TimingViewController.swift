//
//  TimingViewController.swift
//  TimeRecorder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class TimingViewController: UIViewController
{
    var isTiming = false {
        didSet {
            updateUI()
        }
    }
    var from: NSDate!
    
    let imageView = UIImageView()
    
    @IBOutlet weak var timingView: UIView!
        
    @IBAction func longTap(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            if isTiming {
                let title = "经过" + Utility.toCost(NSDate().timeIntervalSinceDate(from)) + "，CD好了么?"
                let message = "Message"
                Utility.presentTwoButtonAlert(self, title: title, message: message) { (action) in
                    self.isTiming = !self.isTiming
                }
                
            } else {
                from = NSDate()
                isTiming = !isTiming
            }
        }
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timingView.addSubview(imageView)
        timingView.backgroundColor = UIColor.blackColor()
        // restore from db
        if let isTiming = AppDelegate.database.read(Constant.DBIsTimingFile, key: Constant.DBIsTimingKey) as? Bool {
            self.isTiming = isTiming
            self.from = AppDelegate.database.read(Constant.DBFromFile, key: Constant.DBFromKey) as! NSDate
        }
        updateUI()
        
        // Listen to backup when into background
        NSNotificationCenter.defaultCenter().addObserverForName(
            NotificationName.DidEnterBackground,
            object: UIApplication.sharedApplication().delegate,
            queue: NSOperationQueue.mainQueue()) { (notification) in
                if self.isTiming {
                    self.storeData()
                } else {
                    self.delData()
                }
        }
    }
    
    // MARK: - Internal functions
    private func updateUI() {
        let name = isTiming ? Constant.WadeSuspend : Constant().WadeOntheGo
        imageView.image = UIImage(named: name)!
        centerForImage()
    }
    
    private func centerForImage() {
        let width = imageView.superview!.superview!.bounds.width
        let height = width / imageView.image!.aspecRatio
        let y = (imageView.superview!.superview!.bounds.height - height)/2
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
    }

    private func storeData() {
        AppDelegate.database.insert(Constant.DBIsTimingFile, obj: self.isTiming, key: Constant.DBIsTimingKey)
        AppDelegate.database.insert(Constant.DBFromFile, obj: self.from, key: Constant.DBFromKey)
    }
    
    private func delData() {
        [Constant.DBIsTimingFile, Constant.DBFromFile].forEach {
            AppDelegate.database.delFile($0)
        }
    }

    // MARK: - Constains
    struct Constant {
        static let IsCooldownReady = "CD好了么?"
        
        static let WadeSuspend = "Wade_suspend"
        var WadeOntheGo = "Wade_onthego" + String(arc4random()%UInt32(6))
        
        static let DBIsTimingFile = "DB_isTiming_file"
        static let DBIsTimingKey = "DB isTiming Key"
        static let DBFromFile = "DB_from_file"
        static let DBFromKey = "DB from Key"
    }
}

extension UIImage {
    var aspecRatio: CGFloat {
        return size.height != 0 ? size.width/size.height : 0
    }
}
