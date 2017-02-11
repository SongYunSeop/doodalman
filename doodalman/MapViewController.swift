//
//  ViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 6..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var testButton: UIBarButtonItem!
    @IBOutlet weak var roomListButton: UIBarButtonItem!
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var navigationButton: UIButton!
    
    var roomList: [[String:AnyObject]]!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.mapView.delegate = self

        self.initMap()



    }
    
    func initMap() {
        // default
        let center = CLLocationCoordinate2D(latitude: 37.497395, longitude: 127.02933)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
//        self.fetchRoomData()
    }
    
    func fetchRoomData() {
        let centerLat = self.mapView.region.center.latitude
        let centerLon = self.mapView.region.center.longitude
        let spanLat = self.mapView.region.span.latitudeDelta
        let spanLon = self.mapView.region.span.longitudeDelta

        let parameters = ["centerLat": centerLat, "centerLon": centerLon, "spanLat": spanLat, "spanLon": spanLon]
        
        let model = DooDalMan.shared

        model.fetchRooms(parameters as [String : AnyObject]) { roomList, error in
            performUIUpdatesOnMain {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(model.rooms)
                self.roomCountLabel?.text = "Room Count: \(model.rooms.count)"
            }
        }
    }
    
    @IBAction func showRoomList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showRoomList", sender: 1)
    }
    
    @IBAction func getUserLocation(_ sender: UIButton) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.roomIdx = sender as! Int
        }
    }

}


extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            self.locationManager.stopUpdatingLocation()
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("moved!")
        self.fetchRoomData()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let room = view.annotation as? Room {
            performSegue(withIdentifier: "showRoom", sender: room.id)
        }
    }
    
}
