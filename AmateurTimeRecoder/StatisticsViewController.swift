//
//  StatisticsViewController.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/24/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, MDRotatingPieChartDelegate, MDRotatingPieChartDataSource
{
    @IBOutlet weak var PieCharView: UIView!
    
    private var slicesData: Array<Data> = Array<Data>()
    var pieChart: MDRotatingPieChart!

    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart = MDRotatingPieChart(frame: CGRectMake(0, 0, view.frame.width, view.frame.width))
        
        slicesData = [
            Data(myValue: 52.4, myColor: UIColor(red: 0.16, green: 0.73, blue: 0.61, alpha: 1), myLabel:"Apple"),
            Data(myValue: 70.5, myColor: UIColor(red: 0.23, green: 0.6, blue: 0.85, alpha: 1), myLabel:"Banana"),
            Data(myValue: 50, myColor: UIColor(red: 0.6, green: 0.36, blue: 0.71, alpha: 1), myLabel:"Coconut"),
            Data(myValue: 60.1, myColor: UIColor(red: 0.46, green: 0.82, blue: 0.44, alpha: 1), myLabel:"Raspberry"),
            Data(myValue: 40.9, myColor: UIColor(red: 0.94, green: 0.79, blue: 0.19, alpha: 1), myLabel:"Cherry"),
            Data(myValue: 40.7, myColor: UIColor(red: 0.89, green: 0.49, blue: 0.19, alpha: 1), myLabel:"Mango")]
        
        pieChart.delegate = self
        pieChart.datasource = self
        
        view.addSubview(pieChart)
        
        /*
         Here you can dig into some properties
         -------------------------------------
         
         var properties = Properties()
         
         properties.smallRadius = 50
         properties.bigRadius = 120
         properties.expand = 25
         
         
         properties.displayValueTypeInSlices = .Percent
         properties.displayValueTypeCenter = .Label
         
         properties.fontTextInSlices = UIFont(name: "Arial", size: 12)!
         properties.fontTextCenter = UIFont(name: "Arial", size: 10)!
         
         properties.enableAnimation = true
         properties.animationDuration = 0.5
         
         
         var nf = NSNumberFormatter()
         nf.groupingSize = 3
         nf.maximumSignificantDigits = 2
         nf.minimumSignificantDigits = 2
         
         properties.nf = nf
         
         pieChart.properties = properties
         */
        
        
        let title = UILabel(frame: CGRectMake(0, view.frame.width, view.frame.width, 100))
        title.text = "@xouuox\n\nMDRotatingPieChart demo \nclick on a slice, or drag the pie :)"
        title.textAlignment = .Center
        title.numberOfLines = 4
        view.addSubview(title)
        
        let refreshBtn = UIButton(frame: CGRectMake((view.frame.width-200)/2, view.frame.width+100, 200, 50))
        refreshBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        refreshBtn.setTitle("Refresh", forState: UIControlState.Normal)
        refreshBtn.addTarget(self, action: #selector(StatisticsViewController.refresh), forControlEvents: UIControlEvents.TouchUpInside)
        refreshBtn.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(refreshBtn)
    }
    
    //Delegate
    //some sample messages when actions are triggered (open/close slices)
    func didOpenSliceAtIndex(index: Int) {
        print("Open slice at \(index)")
    }
    
    func didCloseSliceAtIndex(index: Int) {
        print("Close slice at \(index)")
    }
    
    func willOpenSliceAtIndex(index: Int) {
        print("Will open slice at \(index)")
    }
    
    func willCloseSliceAtIndex(index: Int) {
        print("Will close slice at \(index)")
    }
    
    //Datasource
    func colorForSliceAtIndex(index:Int) -> UIColor {
        return slicesData[index].color
    }
    
    func valueForSliceAtIndex(index:Int) -> CGFloat {
        return slicesData[index].value
    }
    
    func labelForSliceAtIndex(index:Int) -> String {
        return slicesData[index].label
    }
    
    func numberOfSlices() -> Int {
        return slicesData.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh()  {
        pieChart.build()
    }
    
    private class Data {
        var value:CGFloat
        var color:UIColor = UIColor.grayColor()
        var label:String = ""
        
        init(myValue:CGFloat, myColor:UIColor, myLabel:String) {
            value = myValue
            color = myColor
            label = myLabel
        }
    }
}
