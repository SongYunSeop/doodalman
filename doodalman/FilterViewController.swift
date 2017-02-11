//
//  FilterViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 10..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class FilterViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var priceRange: RangeSlider!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var revertButton: UIBarButtonItem!
    
    var startDatePicker: UIDatePicker = UIDatePicker()
    var endDatePicker: UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDatePicker()
    }

    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initDatePicker() {
        startDate.inputView = startDatePicker
        endDate.inputView = endDatePicker
        startDatePicker.datePickerMode = UIDatePickerMode.date
        endDatePicker.datePickerMode = UIDatePickerMode.date
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self,
                                         action: #selector(FilterViewController.doneDatePick) )
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self,
                                           action: #selector(FilterViewController.cancelDatePick) )
        
        toolBar.setItems([flexibleSpace, cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.startDate.inputAccessoryView = toolBar
        self.endDate.inputAccessoryView = toolBar
    }
    
    func doneDatePick(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none

        if startDate.isEditing {
            startDate.text = dateFormatter.string(from: startDatePicker.date)
            endDatePicker.minimumDate = startDatePicker.date
            
        } else if endDate.isEditing {
            endDate.text = dateFormatter.string(from: endDatePicker.date)
            startDatePicker.maximumDate = endDatePicker.date
        }
        self.view.endEditing(true)

    }
    
    func cancelDatePick(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    

    
    @IBAction func priceChange(_ sender: RangeSlider) {
        let start = Int(sender.lowerValue)
        let end: Any = sender.upperValue == sender.maximumValue ? "제한없음" : Int(sender.upperValue)
        print("\(start) ~ \(end)")
        priceLabel.text = "\(start) ~ \(end)"
    }
    
    @IBAction func revertFilter(_ sender: UIBarButtonItem) {
        priceRange.lowerValue = 0
        priceRange.upperValue = 100
        priceLabel.text = "0 ~ 제한없음"
        startDate.text = ""
        endDate.text = ""
        startDatePicker.setDate(Date(), animated: false)
        endDatePicker.setDate(Date(), animated: false)
        
    }

    @IBAction func saveFilter(_ sender: UIBarButtonItem) {
        let model = DooDalMan.shared
        
        if self.startDate.text != "" {
            model.filter.startDate = startDatePicker.date
        }
        if self.endDate.text != "" {
            model.filter.endDate = endDatePicker.date
        }
        
        


    }
}
