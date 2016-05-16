//
//  UserObject.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/20/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserObject: NSObject {
    var eventsInvitedTo: [String]?
    var followerIDs: [String]?
    
    init(object: PFObject) {
        super.init()
        self.eventsInvitedTo = object.objectForKey("eventsInvitedTo") as? [String]
        self.followerIDs = object.objectForKey("followerIDs") as? [String]
        
    }
    
    init(success: (String)->()) {
        super.init()
        self.eventsInvitedTo = []
        self.followerIDs = []
        
        let userObj = PFObject(className: "UserObject")
        
        userObj["eventsInvitedTo"] = self.eventsInvitedTo
        userObj["followerIDs"] = self.followerIDs
        
        userObj.saveInBackgroundWithBlock { (done: Bool, error: NSError?) in
            if (done) {
                success(userObj.objectId!)
            }
        }
    }
}
