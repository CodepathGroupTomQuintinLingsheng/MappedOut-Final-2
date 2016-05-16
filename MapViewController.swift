//
//  MapViewController.swift
//  MappedOut
//
//  Created by Quintin Frerichs on 3/10/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import Parse
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchBar()
    
    var eventMarkers : [MKAnnotationView] = []
    var eventMarkersAnnotation: [MapPin] = []
    let schoolPosition = CLLocationCoordinate2DMake(38.6480, -90.3050)
    var manager: CLLocationManager!
    let currentPositionMarker = MKAnnotationView()
    let currentPositionMarkerAnnotation = MapPin()
    var mapEvents: [Event]?
    var isLocation: Bool = false
    var filteredData: [Event] = []
    var user = User()
    
    var firsttimeload : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        firsttimeload = true
//        if(user.eventsInvitedTo != nil){
//            Event.getEventsbyIDs(user.eventsInvitedTo!, orderBy: "updatedAt") { (events: [Event]) in
//                self.mapEvents = events
//                self.populate()
//            }
//        }
//        else{
//            Event.getNearbyEvents(CLLocation(latitude: 38.6480, longitude: -90.3050), orderBy: "updatedAt") { (events: [Event]) in
//                self.mapEvents = events
//                self.populate()
//            }
//        }
        user.getAllEvents { (events: [Event]) in
            self.mapEvents = events
            self.populate()
        }
        var recognizer = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
       
        self.tableView.addGestureRecognizer(recognizer)
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.searchBar.frame.size.width = self.view.frame.size.width
        self.searchBar.frame.origin.y = 20
        self.searchBar.tintColor = UIColor.redColor()
        self.searchBar.barTintColor = UIColor.blackColor()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.sizeToFit()
        self.tableView.frame.size.width = self.view.frame.size.width
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        
        
        myMapView.delegate = self
        currentPositionMarkerAnnotation.coordinate = schoolPosition
        currentPositionMarker.annotation = currentPositionMarkerAnnotation
        let span = MKCoordinateSpanMake(0.010,0.010)
        let region = MKCoordinateRegion(center: schoolPosition, span: span)
        myMapView.setRegion(region, animated: true)
        myMapView.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height-70)
        self.view.addSubview(myMapView)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(tableView)
        tableView.hidden = true
        manager = CLLocationManager()
        manager.delegate = self
        self.manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLocationTrue", name: "isLocationNotificationTrue" , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setLocationFalse", name: "isLocationNotificationFalse", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        user = User()
        
        user.getAllEvents { (events: [Event]) in
            self.mapEvents = events
            self.populate()
        }
    }
    
    func setLocationTrue(){
        isLocation = true
        myMapView.showsUserLocation = true
    }

    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
    }
    func setLocationFalse(){
        isLocation = false
        myMapView.showsUserLocation = false
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            myMapView.showsUserLocation = true
        }
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let newLocation = locations.last
        self.view = self.view
    
        if myMapView.showsUserLocation{
            currentPositionMarkerAnnotation.coordinate = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
            if user.username != nil{
                currentPositionMarkerAnnotation.title = "\(user.username!)"
            }
            if(firsttimeload == true){
                let startLocation = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
                let span = MKCoordinateSpanMake(0.010,0.010)
                let region = MKCoordinateRegion(center: startLocation, span: span)
                myMapView.setRegion(region, animated: true)

                firsttimeload = false
            }
            currentPositionMarkerAnnotation.imageName = "userdot"
            currentPositionMarkerAnnotation.title = "Tap To View Profile"
            currentPositionMarker.annotation = currentPositionMarkerAnnotation
            myMapView.addAnnotation(currentPositionMarkerAnnotation)
            
            
        }
        
        
    }
    func populate(){
        if mapEvents != nil{
            var i = 0
            for (_, event) in mapEvents!.enumerate(){
                let eventLocation = CLLocationCoordinate2DMake(event.location!.coordinate.latitude, event.location!.coordinate.longitude)
                eventMarkersAnnotation.append(MapPin(coordinate: eventLocation, title: event.name, subtitle: nil, event: event, imageName: "Marker-96"))
                eventMarkers.append(MKAnnotationView())
                eventMarkers[i].annotation = (eventMarkersAnnotation[i])

                myMapView.addAnnotation(eventMarkersAnnotation[i])
                i = i+1
            }
        }
    }
    func didTap(recognizer: UIGestureRecognizer){
        
        if recognizer.state == UIGestureRecognizerState.Ended{
            let tapLocation = recognizer.locationInView(self.tableView)
            if let tappedIndexPath = tableView.indexPathForRowAtPoint(tapLocation) {
                if let tappedCell = self.tableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    let eventOfInterest = filteredData[tappedIndexPath.row]
                    if(eventOfInterest.location != nil){
                        let locationOfEvent = CLLocationCoordinate2DMake(eventOfInterest.location!.coordinate.latitude, eventOfInterest.location!.coordinate.longitude)
                        let span = MKCoordinateSpanMake(0.010,0.010)
                        let region = MKCoordinateRegion(center: locationOfEvent, span: span)
                        myMapView.setRegion(region, animated: true)
                        tableView.hidden = true
                        searchBar.showsCancelButton = false
                        searchBar.text = ""
                        searchBar.resignFirstResponder()
                    }
                }
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        
        self.searchBar.showsCancelButton = true
        
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MapPin) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        let cpa = annotation as! MapPin
        anView!.image = UIImage(named: cpa.imageName!)
        return anView
    }
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.tableView.hidden = false
        return true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        UIView.animateWithDuration(0.3) {
            searchBar.showsCancelButton = false
            self.tableView.hidden = true
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = mapEvents!
        } else {
            filteredData = mapEvents!.filter({(dataItem: Event) -> Bool in
                if (dataItem.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableCell
        cell.eventNameLabel.text = filteredData[indexPath.row].name
        
        return cell
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let tap = UITapGestureRecognizer(target: self, action:"tappedTitle:")
        view.addGestureRecognizer(tap)
    }
    func mapView(mapView: MKMapView, didDeSelectAnnotationView view: MKAnnotationView){
        view.removeGestureRecognizer(view.gestureRecognizers!.last!)
    }
    func tappedTitle(sender: UITapGestureRecognizer){
        let view = sender.view as! MKAnnotationView
        if let annotation = view.annotation as? MapPin{
            if(annotation.event != nil){
                self.performSegueWithIdentifier("EventSegue", sender: view)
            }
            else{
                self.performSegueWithIdentifier("UserSegue", sender: view)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let marker = sender as? MKAnnotationView{
            if segue.identifier == "EventSegue"{
                let destination = segue.destinationViewController as! MapDetailsViewController
                if(marker.annotation as? MapPin != nil){
                    let e = marker.annotation as? MapPin
                    let event = e!.event
                    destination.event = event
                }
                
            }
            else if segue.identifier == "UserSegue"{
                let destination = segue.destinationViewController as! UserDetailsViewController
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

