//
//  DDMFilterViewController.swift
//  doodalman
//
//  Created by mac on 2017. 3. 4..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class DDMFilterViewController: UIViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var filterTableView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func closeFilter(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func clearFilter(_ sender: UIButton) {
        print("clear")
    }
    
    @IBAction func saveFilter(_ sender: UIButton) {
        print("save")
    }
    
    
}
