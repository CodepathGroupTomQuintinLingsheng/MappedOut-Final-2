//
//  CustomCell.swift
//  Expandable
//
//  Created by Gabriel Theodoropoulos on 28/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func dateWasSelected(selectedDateString: String)
    
    func enddateWasSelected(selectedDateString: String)
    
    func maritalStatusSwitchChangedState(isOn: Bool)
    
    func textfieldTextWasChanged(newText: String, parentCell: CustomCell)
    
    func sliderDidChangeValue(newSliderValue: String)
    
    func textviewTextWasChanged(newText: String, parentCell: CustomCell)
}

class CustomCell: UITableViewCell, UITextFieldDelegate,UITextViewDelegate {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var lblSwitchLabel: UILabel!
    
    @IBOutlet weak var swMaritalStatus: UISwitch!
    
    @IBOutlet weak var slExperienceLevel: UISlider!
    
    @IBOutlet weak var EnddatePicker: UIDatePicker!
    
    @IBOutlet weak var picCellLabel: UILabel!
    
    @IBOutlet weak var picCellImage: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    // MARK: Constants
    
    let bigFont = UIFont(name: "Avenir-Book", size: 17.0)
    
    let smallFont = UIFont(name: "Avenir-Light", size: 17.0)
    
    let primaryColor = UIColor.whiteColor()
    
    let secondaryColor = UIColor.lightGrayColor()
    
    
    // MARK: Variables
    
    var delegate: CustomCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if textLabel != nil {
            textLabel?.font = bigFont
            textLabel?.textColor = primaryColor
        }
        
        if detailTextLabel != nil {
            detailTextLabel?.font = smallFont
            detailTextLabel?.textColor = secondaryColor
        }
        
        if textField != nil {
            textField.font = bigFont
            textField.delegate = self
        }
        
        if lblSwitchLabel != nil {
            lblSwitchLabel.font = bigFont
        }
        
        if slExperienceLevel != nil {
            slExperienceLevel.minimumValue = 0.0
            slExperienceLevel.maximumValue = 10.0
            slExperienceLevel.value = 0.0
        }
        
        if textView != nil {
            textView.font = bigFont
            textView.delegate = self
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: IBAction Functions
    
    @IBAction func setDate(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        
        if delegate != nil {
            delegate.dateWasSelected(dateString)
        }
    }
    @IBAction func setEndDate(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
        let dateString = dateFormatter.stringFromDate(EnddatePicker.date)
        
        if delegate != nil {
            delegate.enddateWasSelected(dateString)
        }
    }
    
    @IBAction func handleSwitchStateChange(sender: AnyObject) {
        if delegate != nil {
            delegate.maritalStatusSwitchChangedState(swMaritalStatus.on)
        }
    }
    
    
    @IBAction func handleSliderValueChange(sender: AnyObject) {
        if delegate != nil {
            delegate.sliderDidChangeValue("\(Int(slExperienceLevel.value))")
        }
    }
    
    
    // MARK: UITextFieldDelegate Function
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if delegate != nil {
            delegate.textviewTextWasChanged(textView.text!, parentCell: self)
        }
        
        return true
    }
    

    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if delegate != nil {
            delegate.textfieldTextWasChanged(textField.text!, parentCell: self)
        }
        
        return true
    }
    
}
