//
//  RoomAddTableViewController.swift
//  doodalman
//
//  Created by mac on 2017. 2. 22..
//  Copyright © 2017년 song. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit


class RoomAddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var roomPhotos: UICollectionView!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPlaceHolder: UIImageView!
    @IBOutlet weak var roomDescription: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoPlaceHolder: UIImageView!
    

    var photos = Array<UIImage>()
    
    var postCode = ""
    var address = ""
    var startDatePicker: UIDatePicker = UIDatePicker()
    var endDatePicker: UIDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var place: GMSPlace?
    var centerAnnotation: MKPointAnnotation?
    var subAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.none
        self.initDatePicker()
        self.roomDescription.delegate = self
        if self.roomDescription.text == "" {
            self.textViewDidEndEditing(self.roomDescription)
        }
        self.mapView.delegate = self
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if indexPath.section == 0 && indexPath.row == 0 {

        } else if indexPath.section == 0 && indexPath.row == 1 {
            imagePickerShow(.photoLibrary)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            self.priceLabel.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 1{
            self.startDate.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 2 {
            self.endDate.becomeFirstResponder()
        } else if indexPath.section == 2 {
            self.roomDescription.becomeFirstResponder()
        } else if indexPath.section == 3 && indexPath.row == 0 {
            let autocompleteController = GMSAutocompleteViewController()
            let filter = GMSAutocompleteFilter()
            filter.country = "KR"

            autocompleteController.autocompleteFilter = filter
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        } else if indexPath.section == 4 {
            self.addRoom()
        }
    }
    
    func imagePickerShow(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.photoPlaceHolder.alpha = 0
            self.photos.append(image)
            dismiss(animated: true, completion: nil)
            self.roomPhotos.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = roomPhotos.dequeueReusableCell(withReuseIdentifier: "roomPhoto", for: indexPath) as! RoomPhotoCollectionViewCell
        
        cell.photo.image = self.photos[indexPath.row]
        cell.photoIndexLabel.text = "\(indexPath.row + 1) / \(self.photos.count)"
        cell.photoIndexLabel.layer.cornerRadius = 12.0
        return cell
    }
    
    func initDatePicker() {
        startDate.inputView = startDatePicker
        endDate.inputView = endDatePicker
        startDatePicker.datePickerMode = UIDatePickerMode.date
        endDatePicker.datePickerMode = UIDatePickerMode.date
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self,
                                         action: #selector(FilterViewController.doneDatePick) )
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self,
                                           action: #selector(FilterViewController.cancelDatePick) )
        
        toolBar.setItems([flexibleSpace, cancelButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.startDate.inputAccessoryView = toolBar
        self.endDate.inputAccessoryView = toolBar
    }
    
    func doneDatePick(sender: UIBarButtonItem) {
        
        if startDate.isEditing {
            startDate.text = self.dateFormatter.string(from: startDatePicker.date)
            endDatePicker.minimumDate = startDatePicker.date
            
        } else if endDate.isEditing {
            endDate.text = self.dateFormatter.string(from: endDatePicker.date)
            startDatePicker.maximumDate = endDatePicker.date
        }
        self.view.endEditing(true)
        
    }
    
    func cancelDatePick(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "this is placeholder"
            textView.textColor = UIColor.lightGray
        }
        
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "this is placeholder" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        textView.becomeFirstResponder()
    }
    
    func addRoom() {
//        self.dismiss(animated: true, completion: nil)

        if self.priceLabel.text == "" || self.startDate.text == "" || self.endDate.text == "" || self.roomDescription.text == "" || self.centerAnnotation == nil {
            let alert = UIAlertController(title: "모든 정보를 입력해주세요", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let price = self.priceLabel.text as AnyObject
            let startDate = self.startDate.text as AnyObject
            let endDate = self.endDate.text as AnyObject
            let description = self.roomDescription.text as AnyObject
            let latitude = "\((self.centerAnnotation?.coordinate.latitude)!)" as AnyObject
            let longitude = "\((self.centerAnnotation?.coordinate.longitude)!)" as AnyObject
            let full_addr = self.centerAnnotation?.title as AnyObject
            let model = DooDalMan.shared
            
            let parameters: [String: AnyObject] = ["latitude": latitude, "longitude": longitude, "price":price, "startDate":startDate, "endDate": endDate, "description": description, "full_addr": full_addr, "photos": self.photos  as AnyObject, "address": self.subAddress as AnyObject]
            
            model.addRoom(parameters) { (result, error) in
                print("room add success")
                self.navigationController?.popViewController(animated: true)

            }

        }
        
    }


}


extension RoomAddTableViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.subAddress = ""
        for component in place.addressComponents! {
            if component.type.range(of: "local") != nil || component.type.range(of: "level") != nil {
                self.subAddress = "\(component.name) " + self.subAddress
            }
        }
        self.place = place
        self.addressLabel.text = place.formattedAddress
        
        if self.centerAnnotation == nil {
            self.centerAnnotation = MKPointAnnotation()
            self.mapView.addAnnotation(self.centerAnnotation!)
            self.mapPlaceHolder.alpha = 0
        }
        
        self.mapView.dequeueReusableAnnotationView(withIdentifier: "center")
        self.centerAnnotation?.coordinate = place.coordinate
        self.centerAnnotation?.title = place.formattedAddress
        
        let region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
        dismiss(animated: true, completion: nil)


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

extension RoomAddTableViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("conwe")
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "center"
        print("aowiefjwaoeifjawfe")
        if annotation is MKUserLocation { return nil }
        
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "house")
            
        }

        
        return annotationView
    }
}

