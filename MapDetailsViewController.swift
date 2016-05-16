//
//  MapDetailsViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/19/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class MapDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventProfilePicture: PFImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventDistance: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet var largeView: UIView!
    @IBOutlet weak var Enddatelabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    let swipe = UISwipeGestureRecognizer()
    var event: Event?
    var attending: [String] = []
    var attendingUsers: [User] = []
    var namesOfAttendees: [String]!
    let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe.addTarget(self, action: "didSwipe")
        
        largeView.addGestureRecognizer(swipe)
        largeView.userInteractionEnabled = true
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        if(event != nil){
            eventNameLabel.text = event!.name
            if(event!.endDate != nil && event!.startDate != nil){
                let time = event?.endDate
                var formatter = NSDateFormatter()
                formatter.dateFormat = "M-dd hh:mm"
                var title = formatter.stringFromDate(time!)
                let startDate = event?.startDate
                var formatter2 = NSDateFormatter()
                formatter2.dateFormat = "M-dd hh:mm"
                var title2 = formatter.stringFromDate(time!)
                dateLabel.text =  "Start Time: " + title2
                Enddatelabel.text = "End Time: " + title
                
            }
            else{
                dateLabel.text = "No Time Info."
            }
            
            eventDescription.text = event!.descript
            eventProfilePicture.file = event!.pictureFile
            eventProfilePicture.loadInBackground()
            let compareFromPoint = CLLocation(latitude: 38.6480, longitude: -90.3050)
            let compareToPoint = CLLocation(latitude: event!.location!.coordinate.latitude, longitude: event!.location!.coordinate.longitude)
            let distance = compareFromPoint.distanceFromLocation(compareToPoint)
            let convertedDistance = round((distance/1609.34)*100)/100
            eventDistance.text = "\(convertedDistance) mi away"
        }
        
        event?.getUsersAttending({ (users: [User]) in
            self.attendingUsers = users
            
            
            for user in self.attendingUsers{
                self.attending.append(user.username!)
            }
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.layer.cornerRadius = 5
            self.tableView.clipsToBounds = true
            
            self.tableView.reloadData()
        })
        
        
        
    }
    
    
    
//    override func previewActionItems()-> [UIPreviewActionItem]{
//        let addToEvents = UIPreviewAction(title: "Add Event", style: .Default) {
//            (action, viewController) -> Void in
//            //user.eventsAttending.append(event.name)
//        }
//        return addToEvents
//    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    @IBAction func onDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return attending.count
        
    }
    func didSwipe(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MapDetailsTableCell", forIndexPath: indexPath) as! MapDetailsTableCell
        cell.attendingLabel.text = attending[indexPath.row]
        cell.profileImageView.file = attendingUsers[indexPath.row].propicFile
        cell.profileImageView.loadInBackground()
        
        
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
