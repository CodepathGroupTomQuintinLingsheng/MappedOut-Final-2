//
//  UserDetailsViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/26/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var bigView: UIView!
    

    @IBOutlet weak var profilePictureView: PFImageView!
    
    let user = User()
    let swipe = UISwipeGestureRecognizer()
    var eventNames: [String]?
    var filterevents : [Event]?
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe.addTarget(self, action: "didSwipe")
        swipe.direction = UISwipeGestureRecognizerDirection.Down 
        bigView.addGestureRecognizer(swipe)
        bigView.userInteractionEnabled = true
        tableView.dataSource = self
        tableView.delegate = self

        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height/2
        tableView.backgroundColor = UIColor.blackColor()
        profilePictureView.clipsToBounds = true
        profilePictureView.layer.borderWidth = 2
        profilePictureView.layer.borderColor = UIColor.whiteColor().CGColor
        if(user.name != nil){
            usernameLabel.text = user.name
        }
        if(user.propicFile != nil){
            profilePictureView.file = user.propicFile
            profilePictureView.loadInBackground()
        }
        if(user.eventsAttending != nil){
            eventNames = user.eventsAttending
        }
        user.getPublicAttendingEvents { (eventlist:[Event]) in
            self.filterevents = eventlist
            self.tableView.reloadData()
        }
        
    }
    func didSwipe(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count = 0
        if filterevents != nil{
            count = filterevents!.count
        }
        return count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
        if (eventNames != nil){
            cell.eventNameLabel.text = filterevents![indexPath.row].name
        }
        return cell
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
