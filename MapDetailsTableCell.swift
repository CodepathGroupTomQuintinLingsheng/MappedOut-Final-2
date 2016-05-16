//
//  MapDetailsTableCell.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 4/14/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class MapDetailsTableCell: UITableViewCell {
    
   
  
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var attendingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.bounds.height/2
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
