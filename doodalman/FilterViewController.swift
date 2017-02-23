//
//  FilterViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 10..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import SwiftRangeSlider


protocol FilterViewDelegate {
    func filterSaved()
}

class FilterViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var priceRange: RangeSlider!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var revertButton: UIBarButtonItem!
    
    var startDatePicker: UIDatePicker = UIDatePicker()
    var endDatePicker: UIDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var delegate: FilterViewDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.none
        self.initDatePicker()
        self.setUI()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func priceChange(_ sender: RangeSlider) {
        let start = Int(sender.lowerValue)
        let end = sender.upperValue == sender.maximumValue ? "제한없음" : "\(Int(sender.upperValue))만원"
        
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
      
        model.filter.startDate = self.startDate.text != "" ? startDatePicker.date : nil
        model.filter.endDate = self.endDate.text != "" ? endDatePicker.date : nil
        
        model.filter.startPrice = self.priceRange.lowerValue != 0 ? Int(self.priceRange.lowerValue) : nil
        model.filter.endPrice = self.priceRange.upperValue != 100 ? Int(self.priceRange.upperValue) : nil
        self.dismiss(animated: true, completion: {
            self.delegate?.filterSaved()
        })
        
        
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
    
    func setUI() {
        let model = DooDalMan.shared
        if let startDate = model.filter.startDate {
            self.startDatePicker.setDate(startDate, animated: false)
            self.startDate.text = self.dateFormatter.string(from: startDate)
        }
        if let endDate = model.filter.endDate {
            self.endDatePicker.setDate(endDate, animated: false)
            self.endDate.text = self.dateFormatter.string(from: endDate)
        }
        if let startPrice = model.filter.startPrice {
            self.priceRange.lowerValue = Double(startPrice)
        }
        if let endPrice = model.filter.endPrice {
            self.priceRange.upperValue = Double(endPrice)
        }
        let start = Int(self.priceRange.lowerValue)
        let end = self.priceRange.upperValue == self.priceRange.maximumValue ? "제한없음" : "\(Int(self.priceRange.upperValue))만원"
        
        priceLabel.text = "\(start) ~ \(end)"

        
    }
    
    func doneDatePick(sender: UIBarButtonItem) {
        
        if startDate.isEditing {
            startDate.text = self.dateFormatter.string(from: startDatePicker.date)
            endDatePicker.minimumDate = startDatePicker.date
            
        } else if endDate.isEditing {
            endDate.text = self.dateFormatter.string(from: endDatePicker.date)
            startDatePicker.maximumDate = endDatePicker.date
        }
        self.view.endEditing(true)
        
    }
    
    func cancelDatePick(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}
