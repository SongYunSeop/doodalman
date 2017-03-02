//
//  DDMRoom.swift
//  doodalman
//
//  Created by mac on 2017. 3. 2..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import MapKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class RoomsResponse: Mappable {
    var rooms: [Room]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        rooms <- map["rooms"]
    }
}

class Room: NSObject, MKAnnotation, Mappable {
    
    var id: Int?
    var title: String?
    var subtitle: String?
    var thumbnail: String?
    var photoList: [String]?
    var username: String?
    var latitude: Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude! as CLLocationDegrees, longitude: self.longitude! as CLLocationDegrees)
        }
    }
    var price: Int?
    var displayedPrice: String {
        get {
            if let price = self.price {
                return "\(price)원"
            }
            return "No Data"
        }
        
    }
    var startDateString: String?
    var endDateString: String?
    var startDate: Date?
    var endDate: Date?
    var displayedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy.MM.dd"
            if let startDate = self.startDate, let endDate = self.endDate {
                return "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
            }
            
            return "No Data"
        }
    }
    var detail: String?
    
    var full_addr: String?
    
    var isLike: Bool = false
    var isHost: Bool = false
    
    required init(map: Map) { }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        //        title <- map["title"]
        price <- map["price"]
        username <- map["username"]
        title = self.displayedPrice
        thumbnail <- map["thumbnail"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        
        startDateString <- map["startDate"]
        endDateString <- map["endDate"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        startDate = dateFormatter.date(from: startDateString!)
        endDate = dateFormatter.date(from: endDateString!)
        full_addr <- map["full_addr"]
        subtitle = self.displayedDate
        
        
    }
    
}

struct RoomInfo: Mappable {
    var photoList: [String] = []
    var detail: String = ""
    var isLike: Bool = false
    var isHost: Bool = false
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        photoList <- map["RoomPhotos"]
        detail <- map["description"]
        isLike <- map["isLike"]
        isHost <- map["isHost"]
    }
}
