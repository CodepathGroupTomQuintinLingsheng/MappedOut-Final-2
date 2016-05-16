//
//  SettinsTableViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 4/3/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import SwiftyDrop
let isLocationNotificationTrue = "isLocationNotificationTrue"
let isLocationNotificationFalse = "isLocationNotificationFalse"
class SettinsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var chosenProfilePicture: UIImage?
    @IBOutlet weak var profilePictureView: PFImageView!
    
    @IBOutlet weak var coverPictureView: PFImageView!
    
    @IBOutlet weak var clickCell: UITableViewCell!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    let user = User()
    
    let vc2 = UIImagePickerController()
    let vc = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(user.propicFile != nil){
            profilePictureView.file = user.propicFile

            profilePictureView.loadInBackground()
        }
        if(user.coverpicFile != nil){
            coverPictureView.file = user.coverpicFile

            coverPictureView.loadInBackground()
        }
        
        profilePictureView.layer.cornerRadius = profilePictureView.bounds.height/2
        profilePictureView.clipsToBounds = true
        
        profilePictureView.layer.borderWidth = 2
        profilePictureView.layer.borderColor = UIColor.whiteColor().CGColor
        
        locationSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func stateChanged(switchState: UISwitch){
        if locationSwitch.on{
            NSNotificationCenter.defaultCenter().postNotificationName("isLocationNotificationTrue", object: nil)
            
        }
        else{
            NSNotificationCenter.defaultCenter().postNotificationName("isLocationNotificationFalse", object: nil)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1 && indexPath.row == 0){
            
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else if (indexPath.section == 2 && indexPath.row == 0){
            self.dismissViewControllerAnimated(false, completion: nil)
            PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
                self.dismissViewControllerAnimated(true, completion: nil)
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
                
                User.logOut()
            }
        }else if(indexPath.section == 1 && indexPath.row == 1){
            
            vc2.delegate = self
            vc2.allowsEditing = true
            vc2.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(vc2, animated: true, completion: nil)

        }
    }
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if picker == vc{
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                chosenProfilePicture = pickedImage
                profilePictureView.image = pickedImage
                user.updateProfile(user.name, picture: pickedImage)
                
            
            }
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                chosenProfilePicture = pickedImage

                coverPictureView.image = pickedImage
                user.updatecoverpic(user.name, picture: pickedImage)
                
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func onLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
            
            self.dismissViewControllerAnimated(true, completion: nil)
            //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as! loginViewController
            //        self.presentViewController(vc, animated: true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
            
            User.logOut()
            Drop.down("Logout Successfully", state: .Info, duration: 4, action: nil)
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
