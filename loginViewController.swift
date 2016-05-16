//
//  loginViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/8.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import TKSubmitTransition
import SwiftyDrop
import Foundation

class loginViewController: UIViewController,UIViewControllerTransitioningDelegate,UITextFieldDelegate {

    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var UsernameField: UITextField!
    
    var editTextField : UITextField?
    var Signinbutton: TKTransitionSubmitButton!
    var Signupbutton: TKTransitionSubmitButton!
    var screenSize: CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        Signinbutton = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        Signinbutton.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-130)
        //Signinbutton.center = self.view.center
        //Signinbutton.bottom = self.view.frame.height - 60
        Signinbutton.setTitle("Sign in", forState: .Normal)
        Signinbutton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        Signinbutton.addTarget(self, action: "buttononSignin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(Signinbutton)
        
        Signupbutton = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        Signupbutton.center = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height-70)
        //btn.center = self.view.center
        //btn.bottom = self.view.frame.height - 60
        Signupbutton.setTitle("Sign up", forState: .Normal)
        Signupbutton.normalBackgroundColor = UIColor(red:0.51, green:0.84, blue:1.00, alpha:1.0)
        Signupbutton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        Signupbutton.addTarget(self, action: "buttononSignup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(Signupbutton)
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

    }
    

    

    
    override func viewWillAppear(animated: Bool) {
        Signinbutton.hidden = false
        Signupbutton.hidden = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHidden:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttononSignin(button: TKTransitionSubmitButton) {
        Signinbutton.startLoadingAnimation()
        PFUser.logInWithUsernameInBackground(UsernameField.text!, password: PasswordField.text!) { (user:PFUser?, error:NSError?) -> Void in
            if(user != nil){
                
                self.Signupbutton.hidden = true
                self.Signinbutton.startFinishAnimation(0.6, completion: { () -> () in
                    let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoreViewController")
                    
                    secondVC.transitioningDelegate = self
                    
                    self.presentViewController(secondVC, animated: true, completion: nil)
                })
                NSTimer.schedule(delay: 1) { timer in
                    Drop.down("Sign in successfully", state: .Success, duration: 4, action: nil)
                }
                
                
            }else{
                button.failedAnimation(0, completion: nil)
                Drop.down("\(error!.localizedDescription)", state: .Warning, duration: 4, action: nil)
            }
        }
    }
    
    @IBAction func buttononSignup(button:TKTransitionSubmitButton) {
        let newUser = PFUser()
        
        newUser.username = UsernameField.text
        newUser.password = PasswordField.text
        
        Signupbutton.startLoadingAnimation()
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if(success){
                self.Signinbutton.hidden = true
                self.Signupbutton.startFinishAnimation(0.6, completion: { () -> () in
                    let user = User()
                    let userObj = UserObject(success: { (userObjID: String) in
                        user.setObject(userObjID, forKey: "userObjectID")
                        user.userObjectID = userObjID
                        user.saveInBackgroundWithBlock({ (done:Bool, error:NSError?) in
                            if(done) {
                                
                                let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CoreViewController")
                                secondVC.transitioningDelegate = self
                                Drop.down("Sign up successfully", state: .Success, duration: 4, action: nil)
                                self.presentViewController(secondVC, animated: true, completion: nil)
                            }
                            else {
                                print(error)
                            }
                            
                        })
 
                    })

                })
            }else{
                print(error?.localizedDescription)
                button.failedAnimation(0, completion: nil)
                Drop.down("\(error!.localizedDescription)", state: .Warning, duration: 4, action: nil)
            }
        }
    }


    
    
    func keyboardWillShow(aNotification: NSNotification){
        let userInfo: NSDictionary? = aNotification.userInfo
        let aValue: NSValue? = userInfo?.objectForKey(UIKeyboardFrameEndUserInfoKey) as? NSValue
        let keyboardRect = aValue?.CGRectValue()
        let keyboardHeight = keyboardRect?.size.height
        var frame = PasswordField!.frame
        var offset = keyboardHeight
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            if offset > 0{
                self.view.frame = CGRectMake(0, -offset!, self.screenWidth, self.screenHeight)
            }
        })
    }
    
    func keyboardWillHidden(notification: NSNotification){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight)
        })
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
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fadeInAnimator = TKFadeInAnimator()
        return fadeInAnimator
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

}
