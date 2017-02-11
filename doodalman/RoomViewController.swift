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

    var roomIdx: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = DooDalMan.shared
        
        self.roomImageView.loadImage(urlString:model.rooms[self.roomIdx].thumbnail!)
        self.roomTitle.text = model.rooms[self.roomIdx].title

    }
    
    
    @IBAction func shareRoom(_ sender: UIBarButtonItem) {
        print("share it")
    }
    
    @IBAction func likeRoom(_ sender: UIBarButtonItem) {
        print("like it")
    }

}
