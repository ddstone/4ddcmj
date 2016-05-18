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
    
    let imageView = UIImageView()
    
    @IBOutlet weak var timingView: UIView!
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        isTiming = !isTiming
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        timingView.addSubview(imageView)
        timingView.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }

    private func updateUI() {
        let name = isTiming ? Constant().WadeOntheGo : Constant.WadeSuspend
        imageView.image = UIImage(named: name)!
        centerForImage()
    }
    
    private func centerForImage() {
        let width = imageView.superview!.superview!.bounds.width
        let height = width / imageView.image!.aspecRatio
        let y = (imageView.superview!.superview!.bounds.height - height)/2
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    struct Constant {
        static let WadeSuspend = "Wade_suspend"
        var WadeOntheGo = "Wade_onthego" + String(arc4random()%UInt32(6))
    }
}

extension UIImage {
    var aspecRatio: CGFloat {
        return size.height != 0 ? size.width/size.height : 0
    }
}
