//
//  EventInvitePFTableViewCell.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/17/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EventInvitePFTableViewCell: PFTableViewCell {

    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventAddress: UILabel!

    @IBOutlet var eventStartTime: UILabel!
    @IBOutlet var eventEndTime: UILabel!
    @IBOutlet var eventPicture: PFImageView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
