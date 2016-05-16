//
//  MapPin.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 4/28/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import MapKit
class MapPin: NSObject, MKAnnotation {
    let schoolPosition = CLLocationCoordinate2DMake(38.6480, -90.3050)
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var event: Event?
    var imageName: String?
    override init(){
       coordinate = schoolPosition
        super.init()
    }
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, event: Event?, imageName: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.event = event
        self.imageName = imageName
        super.init()
    }
   
}
