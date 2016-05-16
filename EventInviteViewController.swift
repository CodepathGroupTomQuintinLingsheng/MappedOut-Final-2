//
//  EventInviteViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/1/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftyDrop

class EventInviteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var invitedUsers: [User] = []
    var eventsOwned: [Event] = []
    var eventsAttending: [Event] = []
    var user = User()
    var selectedEvent: Event?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.enabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: false)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
//        navigationItem.titleView = segmentedControl
        
        user.getPublicAttendingEvents { (events: [Event]) in
            self.eventsAttending = events
        }
        
        user.getOwnedEvents { (events: [Event]) in
            self.eventsOwned = events
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        confirmButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentedControl.selectedSegmentIndex == 0) {

            return eventsOwned.count
        }
        else if (segmentedControl.selectedSegmentIndex == 1) {
            return eventsAttending.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventInvitePFTableViewCell", forIndexPath: indexPath) as! EventInvitePFTableViewCell
        var event: Event?
        if(segmentedControl.selectedSegmentIndex == 0) {
            event = eventsOwned[indexPath.row] 
        }
        else {
            event = eventsAttending[indexPath.row]
        }
        if let event = event {
            cell.eventName.text = event.name
            cell.eventAddress.text = event.address
            if let file = event.pictureFile {
                cell.eventPicture.file = file
                cell.eventPicture.loadInBackground()
            }
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd hh:mm" //format style. Browse online to get a format that fits your needs.
            var startdateString = dateFormatter.stringFromDate(event.startDate!)
            var enddateString = dateFormatter.stringFromDate(event.endDate!)
            cell.eventStartTime.text = startdateString
            cell.eventEndTime.text = enddateString
        }
    
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CancelFromEvents" {
//            let dvc = segue.destinationViewController as! UINavigationController
//            let vc = dvc.viewControllers[0] as! FriendsTableViewController
            
//            vc.tableView.setEditing(true, animated: true)
//            vc.updateButtons()
//            vc.selectedUsers = invitedUsers
        }
        else if segue.identifier == "ConfirmFromEvents" {
            if let selectedEvent = selectedEvent {

                
                selectedEvent.inviteToEvent(invitedUsers, success: {
                    let dvc = segue.destinationViewController as! UITabBarController
                    dvc.selectedIndex = 2
                    Drop.down("Friends Successfully Invited", state: DropState.Success, duration: 3, action: nil)
                })
            }
        }
    }

    @IBAction func onSegmentedControlChange(sender: AnyObject) {
        confirmButton.enabled = false
        tableView.reloadData()
    }
     
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        confirmButton.enabled = true
        if(segmentedControl.selectedSegmentIndex == 0) {
            selectedEvent = eventsOwned[indexPath.row]
        }
        else {
            selectedEvent = eventsAttending[indexPath.row]
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    @IBAction func onConfirm(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            if let selectedEvent = self.selectedEvent {
                selectedEvent.inviteToEvent(self.invitedUsers, success: {
//                    let dvc = self.parentViewController as! FriendsTableViewController
//                    dvc.tableView.setEditing(false, animated: false)
//                    dvc.updateButtons()
                    Drop.down("Friends Successfully Invited", state: DropState.Success, duration: 3, action: nil)
                })
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
