//
//  NotificationCell.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/4/21.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate {
    func eventisacceptted(acceptted: Bool,parentcell:NotificationCell)
}

class NotificationCell: UITableViewCell {

    @IBOutlet weak var eventnamelabel: UILabel!
    
    @IBOutlet weak var invitedbyLabel: UILabel!
    
    @IBOutlet weak var starttimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var delegate: NotificationCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onaccept(sender: AnyObject) {
        if(delegate != nil){
            delegate.eventisacceptted(true,parentcell:self)
        }
    }

    @IBAction func oncancel(sender: AnyObject) {
        if(delegate != nil){
            delegate.eventisacceptted(false,parentcell:self)
        }
    }
}
