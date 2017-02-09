//
//  ViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 6..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var roomListButton: UIBarButtonItem!
    @IBOutlet weak var roomCountLabel: UILabel!
    
    var roomList: [[String:AnyObject]]!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initMap()
        
        self.fetchRoomData()

    }
    
    func initMap() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func fetchRoomData() {
        
        let roomListURL = URL(string: "http://localhost:3000/rooms/list")!
        
        let task = URLSession.shared.dataTask(with: roomListURL) { (data, response, error) in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let roomList = parsedResult["data"] as? [[String: AnyObject]] else {
                print("No data: Room List")
                return
            }
            
            let model = DooDalMan.shared
            
            for (index, data) in roomList.enumerated() {
                let thumbnail: UIImage
                if let imageData = try? Data(contentsOf: URL(string: data["thumbnail"] as! String)!) {
                    thumbnail = UIImage(data: imageData)!
                } else {
                    thumbnail = UIImage(named: "default")!
                }

                let room = Room(
                    id: index,
                    title: data["title"] as? String,
                    location: CLLocation(latitude: data["lat"] as! CLLocationDegrees, longitude: data["lon"] as! CLLocationDegrees),
                    thumbnail: thumbnail
                )
                
                model.rooms.append(room)
                
            }
            
            performUIUpdatesOnMain {
                self.roomCountLabel?.text = "Room Count: \(model.rooms.count)"
            }
            
        }
        
        task.resume()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        self.mapView.delegate = self

        
    }
    
    
    @IBAction func showRoomList(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showRoomList", sender: 1)
    }
    
    private func makeURLFromParameters(_ url: String, _ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Server.APIScheme
        components.host = Constants.Server.APIHost
        components.path = url
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }


    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region.center)
    }


}

