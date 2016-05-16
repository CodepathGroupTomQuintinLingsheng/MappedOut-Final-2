//
//  AddFriendTableViewCell.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/21/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddFriendTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var propic: PFImageView!

    @IBOutlet var statusIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
