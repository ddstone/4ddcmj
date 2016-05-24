//
//  ProjectsTableViewController.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController, AddProject, AdjustDateAccordingToDuration {
    
    var projects = [[Project]]() { didSet { tableView.reloadData() } }
    var selectedProject: Project!
    
    var timingVC: TurnOffTiming!
    var timeIntervals: TimeInterval!
    var apObserver: NSObjectProtocol?

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // NARK: - Respond to shake gesture
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restoreData()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        updateUI()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        storeData()
    }

    // Delegate
    
    func addProject(name: String) {
        let newProject = Project(name: name)
        if projects.isEmpty {
            projects.append([newProject])
        } else {
            projects[0].append(newProject)
        }
    }
    
    func adjustDateAccordingToDuration(duration: NSTimeInterval) {
        if duration != timeIntervals.last {
            let newTo = NSDate(timeInterval: duration, sinceDate: timeIntervals.from)
            timeIntervals.setNewTo(newTo)
            updateUI()
            Utility.presentTwoButtonAlert(self, title: "加入时间", message: "确定将" + title! + "加入到" + selectedProject.name + "中么") { (action) in
                self.selectedProject.addTimeInterval(self.timeIntervals)
                self.timingVC.turnOffTiming()
                self.dismissViewControllerAnimated(true, completion: nil)
                    }
        }
    }
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.AddProjectSegueIdentifier:
                (segue.destinationViewController.containerController as! AddProjectViewController).addProjectItem = self
            case Constants.ShowDurationPickerSegueIdentifier:
                let dpvc = segue.destinationViewController.containerController as! DurationPickerViewController
                dpvc.duration = timeIntervals.last
                dpvc.delegate = self
            default: break
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return projects.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects[section].count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ProjectCellReuseIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = projects[indexPath.section][indexPath.row].name
        cell.detailTextLabel?.text = "\(Utility.toCost(projects[indexPath.section][indexPath.row].last))"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedProject = projects[indexPath.section][indexPath.row]
        if timeIntervals != nil {
            performSegueWithIdentifier(Constants.ShowDurationPickerSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Internal functions
    private func storeData() {
        AppDelegate.database.insert(Constants.DBProjectsFileName, obj: projects, key: Constants.DBProjectsKey)
    }
    
    private func restoreData() {
        if let pros = AppDelegate.database.read(Constants.DBProjectsFileName, key: Constants.DBProjectsKey) as? [[Project]] {
            projects = pros
        }
    }
    
    private func updateUI() {
        title = Utility.toCost(timeIntervals.last)
    }
    
    // MARK: - Constants
    struct Constants {
        static let DBProjectsFileName = "DBProjectsFile"
        static let DBProjectsKey = "DBProjectsKey"

        static let AddProjectSegueIdentifier = "AddProjectSegueIdentifier"
        static let ProjectCellReuseIdentifier = "ProjectCellReuseIdentifier"
        static let ShowDurationPickerSegueIdentifier = "Show Duration Picker Identifier"
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

protocol TurnOffTiming {
    func turnOffTiming()
}
