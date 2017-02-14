//
//  RoomViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import KFSwiftImageLoader
class RoomViewController: UIViewController {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var roomAddress: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDate: UILabel!

    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.roomImageView.loadImage(urlString: self.room.thumbnail!)
        self.roomTitle.text = self.room.title
        self.roomAddress.text = self.room.full_addr
        self.roomPrice.text = self.room.displayedPrice
        self.roomDate.text = self.room.displayedDate

    }    
    
    @IBAction func shareRoom(_ sender: UIBarButtonItem) {
        print("share it")
    }
    
    @IBAction func likeRoom(_ sender: UIBarButtonItem) {
        print("like it")
    }

}
