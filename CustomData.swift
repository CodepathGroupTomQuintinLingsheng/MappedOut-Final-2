//
//  File.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/23/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import Foundation
import UIKit
class CustomData{
    var mapEvent: Event?
    var markerUser: User?
    init(mapEvent event: Event?, markerUser user: User?){
        mapEvent = event
        markerUser = user
    }
}
