//
//  ProjectsTableViewController.swift
//  AmateurTimeRecoder
//
//  Created by apple on 5/19/16.
//  Copyright © 2016 ddstone. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController, AddProject {
    
    var projects = [[Project]]() { didSet { tableView.reloadData() } }
    
    var timingVC: TurnOffTiming!
    var timeIntervals: TimeInterval!
    var apObserver: NSObjectProtocol?

    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Utility.toCost(timeIntervals.last)
        restoreData()
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
    
    // Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.AddProjectSegueIdentifier {
            (segue.destinationViewController.containerController as! AddProjectViewController).addProjectItem = self
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
        let project = projects[indexPath.section][indexPath.row]
        Utility.presentTwoButtonAlert(self, title: "加入时间", message: "确定将" + title! + "加入到" + project.name + "中么") { (action) in
            project.addTimeInterval(self.timeIntervals)
            self.timingVC.turnOffTiming()
            self.dismissViewControllerAnimated(true, completion: nil)
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
    
    // MARK: - Constants
    struct Constants {
        static let DBProjectsFileName = "DBProjectsFile"
        static let DBProjectsKey = "DBProjectsKey"

        static let AddProjectSegueIdentifier = "AddProjectSegueIdentifier"
        static let ProjectCellReuseIdentifier = "ProjectCellReuseIdentifier"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol TurnOffTiming {
    func turnOffTiming()
}
