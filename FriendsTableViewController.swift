//
//  FriendsTableViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 3/29/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    
    //Image: https://thenounproject.com/search/?q=invite&i=161161
    
    var friends: [User] = []
    var followers: [User] = []
    var filteredFriends: [User] = []
    var selectedUsers: [User] = []
    var selectedUsersDisplay: UIView?
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var addFriendButton: UIBarButtonItem!
    @IBOutlet var friendsInviteButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var eventInviteButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var user: User?
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar = UISearchBar()
        searchBar!.sizeToFit()
        self.tableView.tableHeaderView = searchBar
        searchBar!.barStyle = .Default
        searchBar!.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        user = User()
        
        user!.getFriends { (friends) -> () in
            self.friends = friends
            self.filteredFriends = friends
            self.tableView.reloadData()
        }
        
        user?.getFollowers({ (followers) in
            self.followers = followers
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        user = User()
        
        user!.getFriends { (friends) -> () in
            self.friends = friends
            self.filteredFriends = friends
            self.tableView.reloadData()
        }
        
        user!.getFollowers { (followers) -> () in
            self.followers = followers
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendTableViewCell", forIndexPath: indexPath) as! FriendPFTableViewCell
        
        let cellUser = filteredFriends[indexPath.row]
        
        cell.username.text = cellUser.name
        
        
        if let propicFile = cellUser.propicFile {
            
            cell.propic.file = propicFile
            
            cell.propic.loadInBackground()
            
        }
        else {
            cell.propic.image = UIImage(named: "avatar.jpg")
        }
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar, searchText: String) {
        searchFriends(searchBar, searchText: searchText)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchFriends(searchBar, searchText: searchText)
    }
    
    @IBAction func onEventsInvite(sender: AnyObject) {
        //        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        //        if let selectedIndexPaths = selectedIndexPaths {
        //            var selectedUsers: [User] = []
        //            for indexPath in selectedIndexPaths {
        //                selectedUsers.append(filteredFriends[indexPath.row])
        //            }
        //        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.tableView.setEditing(false, animated: true)
        self.updateButtons()
        selectedUsers = []
        tableView.reloadData()
        if let selectedUsersDisplay = selectedUsersDisplay {
            selectedUsersDisplay.removeFromSuperview()
        }
    }
    @IBAction func onFriendsInvite(sender: AnyObject) {
        self.tableView.setEditing(true, animated: true)
        self.eventInviteButton.enabled = false
        self.updateButtons()
        addSelectedUsersDisplay()
    }
    
    func updateButtons() {
        if (self.tableView.editing == true) {
            navigationItem.rightBarButtonItem = self.eventInviteButton
            navigationItem.leftBarButtonItem = self.cancelButton
        }
        else {
            navigationItem.rightBarButtonItem = self.addFriendButton
            navigationItem.leftBarButtonItem = self.friendsInviteButton
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedUsers.append(filteredFriends[indexPath.row])
        if(selectedUsers.count == 1) {
            self.eventInviteButton.enabled = true
            updateButtons()
        }
        updateSelectedUserDisplay()
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        for i in 0 ..< selectedUsers.count {
            if(selectedUsers[i].username == filteredFriends[indexPath.row].username) {
                selectedUsers.removeAtIndex(i)
                break
            }
        }
        if(selectedUsers.count == 0) {
            self.eventInviteButton.enabled = false
            updateButtons()
        }
        updateSelectedUserDisplay()
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellUser = filteredFriends[indexPath.row]
        let username = cellUser.username!
        var bool = false
        for user in selectedUsers {
            if(user.username! == username) {
                bool = true
                break
            }
        }
        if(bool) {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
        }
        else{
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "EventInviteSegue" {
            if let destination = segue.destinationViewController as? UINavigationController {
                if let finalDestination = destination.viewControllers[0] as? EventInviteViewController {
                    finalDestination.invitedUsers = selectedUsers
                }
            }
        }
        
        //Below Popover ViewController was not yet implemented.  Keep in case it will be.
//        if segue.identifier == "FriendsPopover" {
//            let dvc = segue.destinationViewController as! FriendsCollectionViewController
//            let controller = dvc.popoverPresentationController
//            if let controller = controller {
//                controller.delegate = self
//            }
//        }
    }
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            if(searchBar?.text == "") {
                filteredFriends = friends
            }
            else {
                filteredFriends = friends.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString((searchBar?.text)!, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            
            tableView.reloadData()
        }
        else if (segmentedControl.selectedSegmentIndex == 1) {
            
            if(searchBar?.text == "") {
                filteredFriends = followers
            }
            else {
                filteredFriends = followers.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString((searchBar?.text)!, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            tableView.reloadData()
        }
    }
    
    
    func searchFriends(searchBar: UISearchBar, searchText: String) {
        if(searchText == "") {
            if (segmentedControl.selectedSegmentIndex == 0) {
                filteredFriends = friends
            }
            else if (segmentedControl.selectedSegmentIndex == 1) {
                filteredFriends = followers
            }
            
            tableView.reloadData()
        }
        else {
            if (segmentedControl.selectedSegmentIndex == 0) {
                filteredFriends = friends.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString(searchText, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            else if (segmentedControl.selectedSegmentIndex == 1) {
                filteredFriends = followers.filter({ (dataItem: User) -> Bool in
                    if((dataItem.username?.rangeOfString(searchText, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                        
                        return true
                    }
                    else {
                        
                        return false
                    }
                })
            }
            
            tableView.reloadData()
            
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //Below 2 functions (updateSelectedUserDisplay, addSelectedUsersDisplay()) involve counting and displaying
    //the number of users selected.  Not yet working, but keep for later. 
    func updateSelectedUserDisplay() {
        //        let uniqueArray = Array(Set(selectedUsers))
        //        let count = uniqueArray.count
        //        var text = ""
        //        if(count == 0) {
        //            text = "No Users Selected"
        //        }
        //        else if(count == 1) {
        //            text = "\(uniqueArray[0].username!)"
        //        }
        //        else if(count == 2) {
        //            text = "\(uniqueArray[0].username!), \(uniqueArray[1].username!)"
        //        }
        //        else {
        //            text = "\(uniqueArray[0].username!), \(uniqueArray[1].username!) and "
        //            if(count == 3) {
        //                text += "1 other user"
        //            }
        //            else {
        //                text += "\(count-2) other users"
        //            }
        //        }
        //        var label = selectedUsersDisplay?.subviews[0] as! UILabel
        //        label.text = text
        //
        //        let tap = UITapGestureRecognizer(target: self, action: "popover:")
        //        tap.numberOfTapsRequired = 1
        //        label.userInteractionEnabled = true
        //        label.addGestureRecognizer(tap)
        //
        //        selectedUsersDisplay?.addSubview(label)
        //        self.navigationController?.view.addSubview(selectedUsersDisplay!)
    }
    
    func addSelectedUsersDisplay() {
        //        let rect = CGRect(x: view.frame.size.width/4, y: (3*view.frame.size.height)/4, width: view.frame.size.width/2, height: view.frame.size.height/9)
        //        selectedUsersDisplay = UIView(frame: rect)
        //        selectedUsersDisplay?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        //        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        //        label.text = "No Users Selected"
        //        selectedUsersDisplay?.addSubview(label)
        //        self.navigationController?.view.addSubview(selectedUsersDisplay!)
    }
    
    func popover() {
        self.performSegueWithIdentifier("FriendsPopover", sender: self)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
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
