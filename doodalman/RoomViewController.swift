//
//  RoomViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!

//    var room: [String:AnyObject]!
    var roomIdx: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let model = DooDalMan.shared
        
        self.roomImageView.image = model.rooms[self.roomIdx].thumbnail
        self.roomTitle.text = model.rooms[self.roomIdx].title
        
//        let imageURL = URL(string: (room["thumbnail"] as? String)!)
//        let imageData = try? Data(contentsOf: imageURL!)
//        
//        self.roomImageView.image = UIImage(data: imageData!)
//        
//        self.roomTitle.text = room["title"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareRoom(_ sender: UIBarButtonItem) {
        print("share it")
    }
    
    @IBAction func likeRoom(_ sender: UIBarButtonItem) {
        print("like it")
    }

}
