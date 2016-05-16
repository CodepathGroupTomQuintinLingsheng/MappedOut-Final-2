//
//  NotificationsViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 4/21/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NotificationCellDelegate {
    
    
    @IBOutlet weak var invitationsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var invitedlist : [String]?
    var invitedEvent : [Event]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        Event.getEventsbyIDs(invitedlist!, orderBy: "updatedAt") { (result:[Event]) in
            self.invitedEvent = result
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(invitedEvent != nil){
            return (invitedEvent?.count)!
        }
        return 0
    }
    
    @IBAction func ondismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func eventisacceptted(acceptted: Bool,parentcell:NotificationCell) {
        let index = tableView.indexPathForCell(parentcell)
        //print(index)
//        tableView.deleteRowsAtIndexPaths([index!], withRowAnimation: UITableViewRowAnimation.Fade)
        invitedEvent?.removeFirst()
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inviteCell", forIndexPath: indexPath) as! NotificationCell
        cell.eventnamelabel.text = self.invitedEvent![indexPath.row].name
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm" //format style. Browse online to get a format that fits your needs.
        var startdateString = dateFormatter.stringFromDate(invitedEvent![indexPath.row].startDate!)
        var enddateString = dateFormatter.stringFromDate(invitedEvent![indexPath.row].endDate!)
        cell.starttimeLabel.text = startdateString
        cell.endTimeLabel.text = enddateString
        cell.delegate = self
        return cell
        
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
