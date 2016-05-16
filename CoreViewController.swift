//
//  CoreViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/9.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftyDrop
import TKSubmitTransition
import BubbleTransition
import FSCalendar
import DateSuger
import RKNotificationHub

let userDidLogoutNotification = "userDidLogoutNotification"
let userDidCreatenewNotification = "userDidCreatenewNotification"
class CoreViewController: UIViewController,UIViewControllerTransitioningDelegate,FSCalendarDataSource,FSCalendarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var ProfileImage: PFImageView!
    @IBOutlet weak var AvatarImage: PFImageView!

    @IBOutlet weak var UsernameLabel: UILabel!
    
    
    
    let transition = BubbleTransition()
    var events : [Event]?
    var filteredevent : [Event]?
    var selectedDate : NSDate = NSDate()
    var hub : RKNotificationHub?
    var invitedevent: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PFUser.currentUser()?.fetchInBackground()
        AvatarImage.layer.cornerRadius = 40
        AvatarImage.clipsToBounds = true
        //transitionButton.layer.cornerRadius = 25
        //transitionButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.scope = .Week
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreViewController.needRelaod), name: userDidCreatenewNotification, object: nil)

//        let user = User()
//        user.addAttendingEvents("3333333")
        
        
//        let location = CLLocation(latitude: 38.6488705, longitude: -90.3114517)
//        let date = NSDate()
//        let pic = UIImage(named: "camera_edit")
//        event = Event(name: "Test Class", owner: user, description: "testtesttest", location: location, picture: pic, date: date, isPublic: true)
        var user = User()
        
        let eventattendinglist = user.eventsAttending
        //print(eventattendinglist)
        if(eventattendinglist != nil){
        Event.getEventsbyIDs(eventattendinglist!, orderBy: "createdAt") { (events:[Event]) in
            self.events=events
            self.filteredevent?.removeAll()
            for event in events{
                
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent != nil){
                    self.filteredevent?.append(event)
                }
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent == nil){
                    self.filteredevent = [event]
                }
            }
            //print(self.filteredevent)
            self.tableView.reloadData()
        }
        }
        hub = RKNotificationHub.init(view: UsernameLabel)
        hub?.setCircleAtFrame(CGRectMake(90, -85, 30, 30))
        
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (result:PFObject?, error:NSError?) in
            user = User()
            
            user.getUserObject({ (newresult:UserObject) in
                self.invitedevent =  newresult.eventsInvitedTo
                if self.invitedevent != nil {
                    if self.invitedevent!.count>0 {
                        
                        self.hub?.incrementBy(UInt((self.invitedevent!.count)))
                        self.hub?.pop()
                        
                    }
                }
                
            })
        })

//        user.fetchInBackgroundWithBlock({ (result:PFObject?, error:NSError?) in
//            
//           
//            
//
//        })

        
        if(user.propicFile != nil){
            AvatarImage.file = user.propicFile
            AvatarImage.loadInBackground()
        }
        
        if(user.coverpicFile != nil){
            ProfileImage.file = user.coverpicFile
            ProfileImage.loadInBackground()
        }
        
        UsernameLabel.text = user.name

        if traitCollection.forceTouchCapability == .Available{
            registerForPreviewingWithDelegate(self, sourceView: tableView)
        }

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var user = User()
        if(user.propicFile != nil){
            AvatarImage.file = user.propicFile
            AvatarImage.loadInBackground()
        }
        
        if(user.coverpicFile != nil){
            ProfileImage.file = user.coverpicFile
            ProfileImage.loadInBackground()
        }
        
        UsernameLabel.text = user.name
    }
    
    func needRelaod(){
        
        PFUser.currentUser()?.fetchInBackground()
        self.filteredevent?.removeAll()
        
        let user = User()
        let eventattendinglist = user.eventsAttending
        //print(eventattendinglist)
        Event.getEventsbyIDs(eventattendinglist!, orderBy: "createdAt") { (events:[Event]) in
            self.events=events
            self.filteredevent?.removeAll()
            for event in events{
                
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent != nil){
                    self.filteredevent?.append(event)
                }
                if (event.startDate?.isSameDay(NSDate()) == true && self.filteredevent == nil){
                    self.filteredevent = [event]
                }
            }
            //print(self.filteredevent)
            self.tableView.reloadData()
        }

        
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func minimumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        return calendar.dateWithYear(2015, month: 2, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar!) -> NSDate! {
        return calendar.dateWithYear(2050, month: 2, day: 1)
    }
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        self.filteredevent?.removeAll()
        
        self.selectedDate = date
        if(events != nil){
        for originalevent in events!{
            
            
            
            
            if (originalevent.startDate?.isSameDay(date) == true && self.filteredevent != nil){
                self.filteredevent!.append(originalevent)
            }
            if (originalevent.startDate?.isSameDay(date) == true && self.filteredevent == nil){
                self.filteredevent = [originalevent]
            }
        }
        }

        

        self.tableView.reloadData()
        
        
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredevent != nil{
            return filteredevent!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Eventcell", forIndexPath: indexPath) as! EventsCell
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd hh:mm" //format style. Browse online to get a format that fits your needs.
        var dateString = dateFormatter.stringFromDate(filteredevent![indexPath.row].startDate!)
        var dateFormatter2 = NSDateFormatter()
        
        if((filteredevent![indexPath.row].endDate?.isSameDay(filteredevent![indexPath.row].startDate!)) == true){
            dateFormatter2.dateFormat = "MM-dd hh:mm"
        }else{
            dateFormatter2.dateFormat = "MM-dd hh:mm"
        }
        
        var EnddateString = dateFormatter2.stringFromDate(filteredevent![indexPath.row].endDate!)
        
        cell.EventName.text = filteredevent![indexPath.row].name
        
        cell.EventLocation.text =  filteredevent![indexPath.row].address
        cell.EventTime.text = dateString
        cell.EventEndtime.text = EnddateString
        //cell.EventLocation.text = events![indexPath.row].location
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
        
        if(segue.identifier == "NotificationSegue"){
            let dvc = segue.destinationViewController as! NotificationsViewController
            dvc.invitedlist = self.invitedevent
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }


}
