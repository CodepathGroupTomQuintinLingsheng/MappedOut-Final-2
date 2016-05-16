//
//  CreateViewController.swift
//  MappedOut
//
//  Created by 吕凌晟 on 16/3/19.
//  Copyright © 2016年 Codepath. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import SwiftyDrop
import MapKit
protocol receivelocation {
    func didselectedloc(location:CLLocation, locationDescription: String)
}
class CreateViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,CustomCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,receivelocation{
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var tblExpandable: UITableView!
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRowsPerSection = [[Int]]()
    var eventname : String?
    var eventstarttime: NSDate?
    var eventendtime: NSDate?
    var eventdescription: String?
    var ispublic :Bool?
    var address: String?
    
    var placePicker: GMSPlacePicker?
    var placesClient: GMSPlacesClient?
    var selectedlocation: CLLocation?
    var currentlocation : CLLocationCoordinate2D?
    var selectedImage : UIImage?
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self

        locationManager.startUpdatingLocation()
        
        //placesClient = GMSPlacesClient()
        closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        closeButton.layer.cornerRadius = 25
        //closeButton.layer.bound = 1
        
        doneButton.layer.cornerRadius = 25
        doneButton.clipsToBounds = true
        //closeButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        //UITableViewHeaderFooterView.appearance().tintColor = UIColor.whiteColor()
        configureTableView()
        
        loadCellDescriptors()
        let selectMapview = storyboard!.instantiateViewControllerWithIdentifier("selectmap") as! SelectMapViewController
        selectMapview
            .receivelocationDelegate = self
        //print(cellDescriptors)
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Locationlati")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Locationlongti")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Address")
    }
    
    override func viewWillAppear(animated: Bool) {
        address = NSUserDefaults.standardUserDefaults().valueForKey("Address") as? String
        if(NSUserDefaults.standardUserDefaults().valueForKey("Locationlati") != nil){
            selectedlocation = CLLocation(latitude: NSUserDefaults.standardUserDefaults().valueForKey("Locationlati") as! Double, longitude: NSUserDefaults.standardUserDefaults().valueForKey("Locationlongti") as! Double   )
            self.cellDescriptors[1][4].setValue(address, forKey: "primaryTitle")
            //self.tblExpandable.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
            tblExpandable.reloadData()
        }
    }
    
    func configureTableView() {
        tblExpandable.delegate = self
        tblExpandable.dataSource = self
        tblExpandable.tableFooterView = UIView(frame: CGRectZero)
        
        tblExpandable.registerNib(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tblExpandable.registerNib(UINib(nibName: "TextfieldCell", bundle: nil), forCellReuseIdentifier: "idCellTextfield")
        tblExpandable.registerNib(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellDatePicker")
        tblExpandable.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        tblExpandable.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        tblExpandable.registerNib(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "idCellSlider")
        tblExpandable.registerNib(UINib(nibName: "TextviewCell", bundle: nil), forCellReuseIdentifier: "idCellTextview")
        tblExpandable.registerNib(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "idCellLocation")
        tblExpandable.registerNib(UINib(nibName: "EndDatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellEndDatePicker")
        tblExpandable.registerNib(UINib(nibName: "PicCell", bundle: nil), forCellReuseIdentifier: "idCellPic")
        tblExpandable.registerNib(UINib(nibName: "PicSourceCell", bundle: nil), forCellReuseIdentifier: "idCellPicSource")
        tblExpandable.registerNib(UINib(nibName: "PicSourceCell2", bundle: nil), forCellReuseIdentifier: "idCellPicSource2")
    }
    
    func loadCellDescriptors() {
        if let path = NSBundle.mainBundle().pathForResource("CellDescriptor", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            tblExpandable.reloadData()
        }
    }

    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String:AnyObject]]).count - 1) {
                let isvisible = (currentSectionCells as! [[String:AnyObject]])[row]
                if isvisible["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }
    }
    
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (cellDescriptors[indexPath.section] as! [AnyObject])[indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Basic Information"
            
        case 1:
            return "Addtional Information"
            
        default:
            return "Description"
        }
    }
    

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(currentCellDescriptor["cellIdentifier"] as! String, forIndexPath: indexPath) as! CustomCell
        
        if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
            if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                cell.textLabel?.text = primaryTitle as? String
            }
            
            if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                cell.detailTextLabel?.text = secondaryTitle as? String
            }
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellTextfield" {
            cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSwitch" {
            cell.lblSwitchLabel.text = currentCellDescriptor["primaryTitle"] as? String
            
            let value = currentCellDescriptor["value"] as? String
            cell.swMaritalStatus.on = (value == "true") ? true : false
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellValuePicker" {
            cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }
        else if currentCellDescriptor["cellIdentifier"] as! String == "idCellSlider" {
            let value = currentCellDescriptor["value"] as! String
            cell.slExperienceLevel.value = (value as NSString).floatValue
        }else if currentCellDescriptor["cellIdentifier"] as! String == "idCellTextview" {
            
        }else if currentCellDescriptor["cellIdentifier"] as! String == "idCellLocation" {
            cell.textLabel?.text = currentCellDescriptor["primaryTitle"] as? String
        }else if currentCellDescriptor["cellIdentifier"] as! String == "idCellPic" {
            cell.picCellLabel.text = currentCellDescriptor["secondaryTitle"] as? String
            cell.picCellImage.image = self.selectedImage
        }else if currentCellDescriptor["cellIdentifier"] as! String == "idPicSourceCell" {
            cell.detailTextLabel!.text = currentCellDescriptor["secondaryTitle"] as? String
            //cell.picCellImage.image = self.selectedImage
        }else if currentCellDescriptor["cellIdentifier"] as! String == "idPicSourceCell2" {
            cell.detailTextLabel!.text = currentCellDescriptor["secondaryTitle"] as? String
            //cell.picCellImage.image = self.selectedImage
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath)
        
        switch currentCellDescriptor["cellIdentifier"] as! String {
        case "idCellNormal":
            return 50.0
            
        case "idCellDatePicker":
            return 270.0
        
        case "idCellEndDatePicker":
            return 270.0
            
        case "idCellTextview":
            return 200.0
            
        case "idCellValuePicker":
            return 50.0
        
        case "idCellPic":
            return 66.0
            
        default:
            return 50.0
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let section = cellDescriptors[indexPath.section] as! NSArray
        
        if ((cellDescriptors[indexPath.section] as? NSMutableArray)![indexOfTappedRow] as![String: AnyObject])["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if (section[indexOfTappedRow] as![String: AnyObject])["isExpanded"] as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            cellDescriptors[indexPath.section][indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + ((section[indexOfTappedRow] as![String: AnyObject])["additionalRows"] as! Int)) {
                cellDescriptors[indexPath.section][i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        else {
            if (section[indexOfTappedRow] as![String: AnyObject])["cellIdentifier"] as! String == "idCellLocation" {

                
//                let center = currentlocation
//                let northEast = CLLocationCoordinate2DMake(center!.latitude + 0.001, center!.longitude + 0.001)
//                let southWest = CLLocationCoordinate2DMake(center!.latitude - 0.001, center!.longitude - 0.001)
//                let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//                let config = GMSPlacePickerConfig(viewport: viewport)
//                placePicker = GMSPlacePicker(config: config)
//                
//                placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
//                    if let error = error {
//                        print("Pick Place error: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    if let place = place {
//                        print("Place name \(place.name)")
//                        self.address = place.name
//                        self.selectedlocation = CLLocation.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
//                        print("Place address \(place.formattedAddress)")
//                        print("Place attributions \(place.attributions)")
//                        self.cellDescriptors[indexPath.section][4].setValue(place.name, forKey: "primaryTitle")
//                        self.tblExpandable.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
//                    } else {
//                        print("No place selected")
//                    }
//                })
                
                self.navigationController!.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("selectmap") as! SelectMapViewController, animated: true)


            }
            
            if (section[indexOfTappedRow] as![String: AnyObject])["cellIdentifier"] as! String == "idCellPicSource2" {
                
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                
                self.presentViewController(vc, animated: true, completion: nil)

                
            }
            
            if (section[indexOfTappedRow] as![String: AnyObject])["cellIdentifier"] as! String == "idCellPicSource" {
                
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                vc.sourceType = UIImagePickerControllerSourceType.Camera
                
                self.presentViewController(vc, animated: true, completion: nil)
                
                
            }
            
            
        }
        
        getIndicesOfVisibleRows()
        tblExpandable.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        self.selectedImage = editedImage
        tblExpandable.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didselectedloc(location: CLLocation, locationDescription: String) {
        self.address = locationDescription
        self.selectedlocation = location
        //print(address)
        self.cellDescriptors[1][4].setValue(locationDescription, forKey: "primaryTitle")
        //self.tblExpandable.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        tblExpandable.reloadData()
    }
    
    // MARK: CustomCellDelegate Functions
    func textviewTextWasChanged(newText: String, parentCell: CustomCell) {
        self.eventdescription = newText
        //print(eventdescription)
        tblExpandable.reloadData()
        
    }
    
    
    func dateWasSelected(selectedDateString: String) {
        let dateCellSection = 1
        let dateCellRow = 0
        
        cellDescriptors[dateCellSection][dateCellRow].setValue(selectedDateString, forKey: "primaryTitle")
        
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        eventstarttime = dateFormatter.dateFromString(selectedDateString)
        
        //print(eventstarttime)
        //self.eventstarttime = selectedDateString

        tblExpandable.reloadData()
    }
    
    func enddateWasSelected(selectedDateString: String) {
        let dateCellSection = 1
        let dateCellRow = 2
        
        cellDescriptors[dateCellSection][dateCellRow].setValue(selectedDateString, forKey: "primaryTitle")
        
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        eventendtime = dateFormatter.dateFromString(selectedDateString)
        
        //print(eventendtime)
        tblExpandable.reloadData()
    }
    
    
    func maritalStatusSwitchChangedState(isOn: Bool) {
        let maritalSwitchCellSection = 0
        let maritalSwitchCellRow = 3
        
        let valueToStore = (isOn) ? "true" : "false"
        let valueToDisplay = (isOn) ? "Private" : "Public"
        
        
        if(isOn){
            self.ispublic=false
        }else{
            self.ispublic=true
        }
        cellDescriptors[maritalSwitchCellSection][maritalSwitchCellRow].setValue(valueToStore, forKey: "value")
        cellDescriptors[maritalSwitchCellSection][maritalSwitchCellRow - 1].setValue(valueToDisplay, forKey: "primaryTitle")
        tblExpandable.reloadData()
    }
    
    
    func textfieldTextWasChanged(newText: String, parentCell: CustomCell) {
        let parentCellIndexPath = tblExpandable.indexPathForCell(parentCell)
        let section = cellDescriptors[0] as! NSArray
        let currentFullname = (section[0] as![String: AnyObject])["primaryTitle"] as! String
        let fullnameParts = currentFullname.componentsSeparatedByString(" ")
        
        var newFullname = ""
        
        if parentCellIndexPath?.row == 1 {
            if fullnameParts.count == 2 {
                newFullname = "\(newText) \(fullnameParts[1])"
            }
            else {
                newFullname = newText
            }
        }
        else {
            newFullname = "\(fullnameParts[0]) \(newText)"
        }
        
        eventname = newFullname
        cellDescriptors[0][0].setValue(newFullname, forKey: "primaryTitle")
        tblExpandable.reloadData()
    }
    
    
    func sliderDidChangeValue(newSliderValue: String) {
        cellDescriptors[2][0].setValue(newSliderValue, forKey: "primaryTitle")
        cellDescriptors[2][1].setValue(newSliderValue, forKey: "value")
        
        tblExpandable.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.None)
    }
    



    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentlocation = locations[0].coordinate
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    
    @IBAction func onFinished(sender: AnyObject) {
        let user = User()
        
        
        //print(eventdescription)
        
        if(eventname == nil){
            Drop.down("No Event name", state: DropState.Default , duration: 3, action: nil)
        }else if(eventdescription == nil){
            Drop.down("No Description", state: DropState.Default , duration: 3, action: nil)
        }else if(selectedlocation == nil){
            Drop.down("No Location", state: DropState.Default , duration: 3, action: nil)
        }else if(selectedImage == nil){
            Drop.down("No Image", state: DropState.Default , duration: 3, action: nil)
        }else if(eventstarttime == nil){
            Drop.down("No Start time", state: DropState.Default , duration: 3, action: nil)
        }else if(eventendtime == nil){
            Drop.down("No End time", state: DropState.Default , duration: 3, action: nil)
        }else if(ispublic == nil){
            Drop.down("Public or Private?", state: DropState.Default , duration: 3, action: nil)
        }else{
            let event = Event(name: eventname!, owner: user, description: eventdescription, location: selectedlocation, picture: selectedImage, startDate: eventstarttime, endDate: eventendtime, isPublic: ispublic!, address: address)
        

            self.dismissViewControllerAnimated(true, completion: nil)
            Drop.down("uploading", state: DropState.Info, duration: 3, action: nil)
        }
        
        
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
