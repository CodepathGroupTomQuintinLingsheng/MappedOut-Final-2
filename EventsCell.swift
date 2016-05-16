//
//  EventsCell.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/20.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit

class EventsCell: UITableViewCell {
    @IBOutlet weak var EventName: UILabel!

    @IBOutlet weak var EventTime: UILabel!
    @IBOutlet weak var EventLocation: UILabel!
    
    @IBOutlet weak var Locationlabel: UILabel!
    @IBOutlet weak var EventEndtime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
