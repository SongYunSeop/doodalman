//
//  TestMapViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 13..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

protocol RoomDataDelegate {
    func roomLoaded()
    
    func showRoom(_ room: Room)
    
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var gpsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var delegate: RoomDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.initMap()
        self.gpsButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        self.gpsButton.setTitle(String.fontAwesomeIcon(name: .locationArrow), for: .normal)
    }
    
    func initMap() {
        // default location
        let center = CLLocationCoordinate2D(latitude: 37.497395, longitude: 127.02933)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: false)
        self.mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
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
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let room = view.annotation as? Room {
//            self.delegate?.showRoom(room)
//        }
//    }

    func fetchRoomData() {
        let centerLat = self.mapView.region.center.latitude as AnyObject
        let centerLon = self.mapView.region.center.longitude as AnyObject
        let spanLat = self.mapView.region.span.latitudeDelta as AnyObject
        let spanLon = self.mapView.region.span.longitudeDelta as AnyObject
        
        var parameters:[String: AnyObject] = ["centerLat": centerLat, "centerLon": centerLon, "spanLat": spanLat, "spanLon": spanLon]
        
        let model = DooDalMan.shared

        
        for (key,value) in model.filter.filterData {
            parameters.updateValue(value, forKey: key)
        }

        model.fetchRooms(parameters ) { roomList, error in
            performUIUpdatesOnMain {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(model.rooms)
                self.delegate?.roomLoaded()
            }
        }
    }
    
    @IBAction func getUserLocation(_ sender: UIButton) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Better to make this class property
        let annotationIdentifier = "room"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "annotation")
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let room = view.annotation
        self.delegate?.showRoom(room as! Room)
    }

    


}


extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        print("Place coordinate: \(place.coordinate)")
        dismiss(animated: true, completion: nil)
        
        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
