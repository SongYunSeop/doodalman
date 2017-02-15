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

    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var roomAddress: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDate: UILabel!
    @IBOutlet weak var roomPhotos: UIScrollView!
    @IBOutlet weak var navitationItem: UINavigationItem!

    @IBOutlet weak var roomDescription: UITextView!
    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navitationItem.title = self.room.title
        self.roomTitle.text = self.room.title
        self.roomAddress.text = self.room.full_addr
        self.roomPrice.text = self.room.displayedPrice
        self.roomDate.text = self.room.displayedDate
        self.roomDescription.text = self.room.detail
        self.initPhotoList()
        
    }
    
    func fetchRoomInfo() {
        let model = DooDalMan.shared
        model.fetchRoomInfo(self.room) { (room, error) in
            print("good")
        }
        
    }
    
    func initPhotoList() {
        let imageView = UIImageView()
        imageView.loadImage(urlString: self.room.thumbnail!)
        let xPosition = self.view.frame.width * CGFloat(0)
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.roomPhotos.frame.width, height: self.roomPhotos.frame.height)
        self.roomPhotos.contentSize.width = self.roomPhotos.frame.width * CGFloat(1)
        self.roomPhotos.addSubview(imageView)

        
        for (i, photo) in room.photoList!.enumerated() {
            let imageView = UIImageView()
            imageView.loadImage(urlString: photo)
            let xPosition = self.view.frame.width * CGFloat(i + 1)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.roomPhotos.frame.width, height: self.roomPhotos.frame.height)
            self.roomPhotos.contentSize.width = self.roomPhotos.frame.width * CGFloat(i + 2)
            self.roomPhotos.addSubview(imageView)
            
        }
       
    }
    
    
    
    @IBAction func shareRoom(_ sender: UIBarButtonItem) {
        print("share it")
    }
    
    @IBAction func likeRoom(_ sender: UIBarButtonItem) {
        print("like it")
    }

}
