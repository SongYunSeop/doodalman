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
    
    var roomList: [[String:AnyObject]]!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMap()
        

    }
    
    func initMap() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func fetchRoomData() {
        let centerLat = self.mapView.region.center.latitude
        let centerLon = self.mapView.region.center.longitude
        let spanLat = self.mapView.region.span.latitudeDelta
        let spanLon = self.mapView.region.span.longitudeDelta

        let parameters = ["centerLat": centerLat, "centerLon": centerLon, "spanLat": spanLat, "spanLon": spanLon]
        
        let model = DooDalMan.shared

        
        model.fetchRooms(parameters as [String : AnyObject]) { roomList, error in
            
            model.rooms = []
            performUIUpdatesOnMain {
                self.mapView.removeAnnotations(self.mapView.annotations)

            }

            for (index, data) in (roomList?.enumerated())! {
                let thumbnail: UIImage
                if let imageData = try? Data(contentsOf: URL(string: data["thumbnail"] as! String)!) {
                    thumbnail = UIImage(data: imageData)!
                } else {
                    thumbnail = UIImage(named: "default")!
                }
                let coordinate = CLLocationCoordinate2D(latitude: data["lat"] as! CLLocationDegrees, longitude: data["lon"] as! CLLocationDegrees)
            
                let room = Room(
                    id: index,
                    title: (data["title"] as? String)!,
                    thumbnail: thumbnail,
                    coordinate: coordinate
                )
            
                model.rooms.append(room)
                performUIUpdatesOnMain {
                    self.mapView.addAnnotation(room)

                }
            }
                        
            performUIUpdatesOnMain {
                self.roomCountLabel?.text = "Room Count: \(model.rooms.count)"
            }
        }
        
    }
   
    
    @IBAction func showRoomList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showRoomList", sender: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.roomIdx = sender as! Int
        }
    }

}


extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: false)
        self.locationManager.stopUpdatingLocation()
        self.mapView.delegate = self
        
//        let parameters = ["centerLat": location!.coordinate.latitude, "centerLon": location!.coordinate.longitude, "spanLat": 0.02, "spanLon": 0.02]
//
//        
//        let model = DooDalMan.shared
//        
//        
//        model.fetchRooms(parameters as [String : AnyObject]) { roomList, error in
//            
//            model.rooms = []
//            performUIUpdatesOnMain {
//                self.mapView.removeAnnotations(self.mapView.annotations)
//            }
//
//            
//            for (index, data) in (roomList?.enumerated())! {
//                let thumbnail: UIImage
//                if let imageData = try? Data(contentsOf: URL(string: data["thumbnail"] as! String)!) {
//                    thumbnail = UIImage(data: imageData)!
//                } else {
//                    thumbnail = UIImage(named: "default")!
//                }
//                let coordinate = CLLocationCoordinate2D(latitude: data["lat"] as! CLLocationDegrees, longitude: data["lon"] as! CLLocationDegrees)
//                
//                let room = Room(
//                    id: index,
//                    title: (data["title"] as? String)!,
//                    thumbnail: thumbnail,
//                    coordinate: coordinate
//                )
//                
//                model.rooms.append(room)
//            }
//            
//            performUIUpdatesOnMain {
//                self.roomCountLabel?.text = "Room Count: \(model.rooms.count)"
//                self.mapView.addAnnotations(model.rooms)
//            }
//        }


        
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("moved!")
//        self.fetchRoomData()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let room = view.annotation as? Room {
            performSegue(withIdentifier: "showRoom", sender: room.id)
        }
    }
    
}
