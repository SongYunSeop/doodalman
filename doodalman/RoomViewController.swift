//
//  RoomViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import KFSwiftImageLoader
import MapKit

class RoomViewController: UIViewController, SignInDelegate, MKMapViewDelegate {

//    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var roomAddress: UILabel!
    @IBOutlet weak var roomPrice: UILabel!
    @IBOutlet weak var roomDate: UILabel!
    @IBOutlet weak var roomPhotos: UIScrollView!
    @IBOutlet weak var viewTitle: UINavigationItem!

    @IBOutlet weak var roomDescription: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressIcon: UILabel!
    @IBOutlet weak var priceIcon: UILabel!
    @IBOutlet weak var dateIcon: UILabel!
    @IBOutlet weak var infoIcon: UILabel!
    
    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingUI()
        self.initPhotoList()
        self.fetchRoomInfo()
        
    }
    
    func settingUI() {
        self.viewTitle.title = "\(self.room.username!)님의 방"
        self.addressIcon.font = UIFont.fontAwesome(ofSize: 24)
        self.addressIcon.text = String.fontAwesomeIcon(name: .mapMarker)
        self.priceIcon.font = UIFont.fontAwesome(ofSize: 24)
        self.priceIcon.text = String.fontAwesomeIcon(name: .money)

        self.dateIcon.font = UIFont.fontAwesome(ofSize: 24)
        self.dateIcon.text = String.fontAwesomeIcon(name: .calendar)
        self.infoIcon.font = UIFont.fontAwesome(ofSize: 24)
        self.infoIcon.text = String.fontAwesomeIcon(name: .infoCircle)
//        self.roomTitle.text = self.room.title
        self.roomAddress.text = self.room.full_addr
        self.roomPrice.text = self.room.displayedPrice
        self.roomDate.text = self.room.displayedDate
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.likeButton.setTitleTextAttributes(attributes, for: .normal)
        self.likeButton.title = String.fontAwesomeIcon(name: .heartO)
        self.shareButton.setTitleTextAttributes(attributes, for: .normal)
        self.shareButton.title = String.fontAwesomeIcon(name: .shareSquareO)
        self.mapView.delegate = self

        self.mapView.addAnnotation(self.room)
        let region = MKCoordinateRegion(center: self.room.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: false)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       print("test")
        let annotationIdentifier = "room"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "house")
            
        }
        
        return annotationView
        
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
            performUIUpdatesOnMain {
                if httpStatusCode == .Http401_Unauthorized {
                    self.login()
                    
                } else if httpStatusCode == .Http200_OK {
                    self.setLikeButtonUI(result!)
                }
            }
           
        }
    }
    
    func login() {
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "signinview") as! SignInViewController
        let navigationController = UINavigationController(rootViewController: signInVC)
        
        signInVC.delegate = self
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func contact(_ sender: UIButton) {
        let model = DooDalMan.shared
        
        if self.room.isHost {
            self.performSegue(withIdentifier: "contactList", sender: 1)
        } else {
            model.contact(self.room) { (httpStatusCode, contact, error) in
                performUIUpdatesOnMain {
                    if httpStatusCode == .Http401_Unauthorized {
                        self.login()
                        
                    } else if httpStatusCode == .Http200_OK {
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
