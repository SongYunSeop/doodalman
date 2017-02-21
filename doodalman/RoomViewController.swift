//
//  RoomViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class RoomViewController: UIViewController, SignInDelegate {

    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var roomAddress: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDate: UILabel!
    @IBOutlet weak var roomPhotos: UIScrollView!
    @IBOutlet weak var viewTitle: UINavigationItem!

    @IBOutlet weak var roomDescription: UITextView!
    
    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingUI()
        self.initPhotoList()
        self.fetchRoomInfo()
        
    }
    
    func settingUI() {
        self.viewTitle.title = self.room.title
        self.roomTitle.text = self.room.title
        self.roomAddress.text = self.room.full_addr
        self.roomPrice.text = self.room.displayedPrice
        self.roomDate.text = self.room.displayedDate
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.likeButton.setTitleTextAttributes(attributes, for: .normal)
        self.likeButton.title = String.fontAwesomeIcon(name: .heartO)
        self.shareButton.setTitleTextAttributes(attributes, for: .normal)
        self.shareButton.title = String.fontAwesomeIcon(name: .shareSquareO)

    }
    
    func fetchRoomInfo() {
        let model = DooDalMan.shared
        model.fetchRoomInfo(self.room) { (roomInfo, error) in
            performUIUpdatesOnMain {
                self.roomDescription.text = self.room.detail
                self.setLikeButtonUI(self.room.isLike)
                for (i , photo) in self.room.photoList!.enumerated() {
                    let imageView = UIImageView()
                    imageView.loadImage(urlString: photo)
                    let xPosition = self.view.frame.width * CGFloat(i + 1)
                    imageView.frame = CGRect(x: xPosition, y: 0, width: self.roomPhotos.frame.width, height: self.roomPhotos.frame.height)
                    self.roomPhotos.contentSize.width = self.roomPhotos.frame.width * CGFloat(i + 2)
                    self.roomPhotos.addSubview(imageView)
                }
            }
        }
        
    }
    
    func initPhotoList() {
        let imageView = UIImageView()
        imageView.loadImage(urlString: self.room.thumbnail!)
        let xPosition = self.view.frame.width * CGFloat(0)
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.roomPhotos.frame.width, height: self.roomPhotos.frame.height)
        self.roomPhotos.contentSize.width = self.roomPhotos.frame.width * CGFloat(1)
        self.roomPhotos.addSubview(imageView)
       
    }
    
    func setLikeButtonUI(_ isLiked: Bool) {
        if isLiked {
            self.likeButton.title = String.fontAwesomeIcon(name: .heart)

        } else {
            self.likeButton.title = String.fontAwesomeIcon(name: .heartO)

        }
    }
    
    
    
    @IBAction func shareRoom(_ sender: UIBarButtonItem) {
        print("share it")
    }
    
    @IBAction func likeRoom(_ sender: UIBarButtonItem) {
        print("like it")
        
        let model = DooDalMan.shared
        
        model.likeRoom(self.room) { (httpStatusCode, result, error) in
            // 옵저버 사용 가능
            if httpStatusCode == .Http401_Unauthorized {
                self.login()
                
            } else if httpStatusCode == .Http200_OK {
                performUIUpdatesOnMain {
                    print("good")
                    self.setLikeButtonUI(result!)

                }
            }
        }
    }
    
    func login() {
        performUIUpdatesOnMain {
            let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signinview") as! SignInViewController
            signInVC.delegate = self
            self.present(signInVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func contact(_ sender: UIButton) {
        let model = DooDalMan.shared
        
        if self.room.isHost {
            self.performSegue(withIdentifier: "contactList", sender: 1)
        } else {
            model.contact(self.room) { (httpStatusCode, contact, error) in
                if httpStatusCode == .Http401_Unauthorized {
                    self.login()
                    
                } else if httpStatusCode == .Http200_OK {
                    performUIUpdatesOnMain {
                        self.performSegue(withIdentifier: "contact", sender: contact!)
                    }
                }
            }
        }
    }
    
    func didSingIn() {
        self.fetchRoomInfo()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactList" {
            let contactListVC = segue.destination as! ContactListViewController
            contactListVC.room = self.room
        } else if segue.identifier == "contact" {
            let contactVC = segue.destination as! ContactViewController
            contactVC.contact = sender as? Contact
        }
    }
    

}
