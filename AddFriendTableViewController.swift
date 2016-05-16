//
//  AddFriendTableViewController.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/21/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddFriendTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    let searchBar = UISearchBar()
    var searchText: String?
    
    var allUsers: [User]?
    var filteredUsers: [User]?
    var friends: [User]?
    var username: String?
    let currentUser = User()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        self.searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        self.searchBar.frame.size.width = self.view.frame.size.width
        self.searchBar.becomeFirstResponder()
        username = PFUser.currentUser()?.username
        allUsers = []
        
        
        User.getAllUsers { (users: [User]) in
            self.allUsers = users
            for i in 0 ..< self.allUsers!.count {
                if(self.allUsers![i].name == self.currentUser.name) {
                    //print(self.currentUser.username)
                    self.allUsers!.removeAtIndex(i)
                    break
                }
            }
        }
        friends = []
        currentUser.getFriends { (friends) in
            self.friends = friends
        }
        
        let keyTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        keyTap.cancelsTouchesInView = false
        view.addGestureRecognizer(keyTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredUsers = filteredUsers {
            //print(filteredUsers.count)
            return filteredUsers.count
        }
        else {
            //print(0)
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddFriendTableViewCell", forIndexPath: indexPath) as! AddFriendTableViewCell
        let user = filteredUsers![indexPath.row]
        cell.name.text = user.username
        if let propicFile = user.propicFile {
            cell.propic.file = user.propicFile
            cell.propic.loadInBackground()
        }
        else {
            cell.propic.image = UIImage(named: "avatar.jpg")
        }
        
        var isMyFriend = false;
        let username = user.username
        for friend in friends! {
            if (friend.username! == username) {
                isMyFriend = true
                break
            }
        }
        if (isMyFriend){
            
            cell.statusIcon.image = UIImage(named: "check")
            let tap = UITapGestureRecognizer(target: self, action: "didRemoveFriend:")
            tap.numberOfTapsRequired = 1
            cell.statusIcon.userInteractionEnabled = true
            cell.statusIcon.addGestureRecognizer(tap)
        }
        else {
            
            cell.statusIcon.image = UIImage(named: "plus")
            let tap = UITapGestureRecognizer(target: self, action: "didAddFriend:")
            tap.numberOfTapsRequired = 1
            cell.statusIcon.userInteractionEnabled = true
            cell.statusIcon.addGestureRecognizer(tap)
        }
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            filteredUsers = []
            
        }
        else {
            filteredUsers = allUsers!.filter({ (dataItem: User) -> Bool in
                if((dataItem.username?.rangeOfString((searchBar.text)!, options: .CaseInsensitiveSearch, range: nil, locale: nil)) != nil) {
                    return true
                }
                else {
                    
                    return false
                }
            })
        }
        
        tableView.reloadData()
    }
    
    
    func didAddFriend(sender: UITapGestureRecognizer) {
        let tapLocation = sender.locationInView(self.tableView)
        
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        let currentUser = User()
        let loadedUser = filteredUsers![indexPath!.row]
        currentUser.addFriend((loadedUser))
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! AddFriendTableViewCell
        cell.statusIcon.image = UIImage(named: "check")
        currentUser.getFriends { (friends) in
            self.friends = friends
            self.tableView.reloadData()
        }
    }
    
    func didRemoveFriend(sender: UITapGestureRecognizer) {
        let tapLocation = sender.locationInView(self.tableView)
        
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        let currentUser = User()
        let loadedUser = filteredUsers![indexPath!.row]
        currentUser.removeFriend((loadedUser))
        let cell = tableView.cellForRowAtIndexPath(indexPath!) as! AddFriendTableViewCell
        cell.statusIcon.image = UIImage(named: "plus")
        currentUser.getFriends { (friends) in
            self.friends = friends
            self.tableView.reloadData()
        }
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
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
