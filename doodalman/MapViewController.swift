//
//  ViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 6..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var roomListButton: UIBarButtonItem!
    
    var locationManager: CLLocationManager?
    
    var roomList: [[String:AnyObject]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMap()
        
        
        let roomListURL = URL(string: "http://localhost:3000/rooms/list")!
        
        let task = URLSession.shared.dataTask(with: roomListURL) { (data, response, error) in
            if error == nil {
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                self.roomList = parsedResult["data"]! as! [[String : AnyObject]]
                print(self.roomList[0])
            }
        }
        
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMap() {
        // locationManager
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
        }
        
        // Map Initial State
        let latitude: CLLocationDegrees = 37.497395
        let longitude: CLLocationDegrees = 127.02933
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)

    }
    
    
    @IBAction func showRoomList(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "showRoomList", sender: 1)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoomList" {
            let RoomListVC = segue.destination as! RoomListViewController
            RoomListVC.roomList = self.roomList
        }
    }


}

