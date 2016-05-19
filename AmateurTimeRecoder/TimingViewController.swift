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
                let to = NSDate()
                let seconds = to.timeIntervalSinceDate(from)
                let nf = NSNumberFormatter()
                nf.maximumFractionDigits = 1
                let alert = UIAlertController(
                    title: "Cool down is readdy~?",
                    message: "\(nf.stringFromNumber(seconds)!) seconds",
                    preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: .Default) { (action) in
                    self.isTiming = !self.isTiming
                })
                presentViewController(alert, animated: true, completion: nil)
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
