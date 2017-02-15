//
//  ViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 6..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import FontAwesome_swift

class MainViewController: UIViewController, FilterViewDelegate, MapViewDelegate {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    var mapViewController: MapViewController?

    var roomListViewController: RoomListViewController?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        self.filterButton.setTitleTextAttributes(attributes, for: .normal)
        self.filterButton.title = String.fontAwesomeIcon(name: .filter)
        self.toggleButton.setTitleTextAttributes(attributes, for: .normal)
        self.toggleButton.title = String.fontAwesomeIcon(name: .list)

    }
    
    func roomLoaded() {
        let model = DooDalMan.shared
        self.roomCountLabel?.text = "Room Count: \(model.rooms.count)"
        if let mapView = self.mapViewController?.mapView {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(model.rooms)
        }
        if let tableView = self.roomListViewController?.tableView {
            tableView.reloadData()
        }

    }
    
    func filterSaved() {
        self.mapViewController?.fetchRoomData()

    }
    
    @IBAction func showFilter(_ sender: UIBarButtonItem) {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "filterview") as! FilterViewController
        filterVC.delegate = self
        self.present(filterVC, animated: true, completion: nil)
        

    }
    
    @IBAction func toggleView(_ sender: UIBarButtonItem) {
        
        if mapContainerView.alpha == 0 {
            self.toggleButton.title = String.fontAwesomeIcon(name: .list)

            UIView.animate(withDuration: 0.5, animations: {
                self.mapContainerView.alpha = 1
                self.listContainerView.alpha = 0
            })
        } else {
            self.toggleButton.title = String.fontAwesomeIcon(name: .mapO)

            UIView.animate(withDuration: 0.5, animations: {
                self.mapContainerView.alpha = 0
                self.listContainerView.alpha = 1
                
                
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoomList" {
            self.roomListViewController = segue.destination as? RoomListViewController
        } else if segue.identifier == "MapView" {
            self.mapViewController = segue.destination as? MapViewController
            self.mapViewController?.delegate = self
        }
    }
    

}

