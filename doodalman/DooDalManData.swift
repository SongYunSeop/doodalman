//
//  DooDalManData.swift
//  doodalman
//
//  Created by mac on 2017. 2. 16..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import MapKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

enum HttpStatusCode: Int {
    case Http200_OK = 200
    case Http400_BadRequest = 400
    case Http401_Unauthorized = 401
    case Http402_PaymentRequired = 402
    case Http403_Forbidden = 403
    case Http404_NotFound = 404
    case Http500_InternalServerError = 500
}

struct Filter {
    var startDate: Date?
    var endDate: Date?
    var startPrice: Int?
    var endPrice: Int?
    
    var filterData: [String: AnyObject] {
        get {
            var result:[String: AnyObject] = [:]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            if let startDate = self.startDate {
                result["startDate"] = dateFormatter.string(from: startDate) as AnyObject
            }
            if let endDate = self.endDate {
                result["endDate"] = dateFormatter.string(from: endDate) as AnyObject
            }
            
            if let startPrice = self.startPrice {
                result["startPrice"] = startPrice as AnyObject
            }
            
            if let endPrice = self.endPrice {
                result["endPrice"] = endPrice as AnyObject
            }
            
            return result
        }
    }
}


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
        title <- map["title"]
        price <- map["price"]
        
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
        subtitle = "\(self.displayedPrice) / \(self.displayedDate)"


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

class ContactList: Mappable {
    var contacts: [Contact]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        contacts <- map["contactList"]
    }
}

class Contact: Mappable {
    var contactId: Int? = nil
    var contactChats: [Chat]?
    var username: String?
    var thumbnail: String?
    var title: String?
    
    required init(map: Map) { }

    
    func mapping(map: Map) {
        contactId <- map["id"]
        contactChats <- map["ContactChats"]
        username <- map["username"]
        thumbnail <- map["thumbnail"]
        title <- map["title"]
    }
    
}


class Chat: Mappable {
//    var id: Int?
//    var username: String?
    var content: String?
    var isMe: Bool?
//    var timestamp: Date
    
    init(content: String, isMe: Bool) {
        self.content = content
        self.isMe = isMe
    }
    
    required init(map:Map) { }
    
    func mapping(map: Map) {
//        id <- map["id"]
//        username <- map["username"]
        content <- map["content"]
        isMe <- map["isMe"]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//        timestamp <- map["createdAt"]
    }
}

class UserInfo: Mappable {
    var email: String?
    var username: String?
    
    var likeRooms: [Room]?
    var contactRooms: [Room]?
    var hasRoom: Bool?
    var myRoom: Room?
    
//    init(content:)
    
    required init(map: Map) { }
    
    func mapping(map: Map) {
        email <- map["email"]
        username <- map["uesrname"]
        likeRooms <- map["RoomLikes"]
        contactRooms <- map["Contacts"]
        hasRoom <- map["hasRoom"]
        myRoom <- map["Room"]
        
        
    }
    
    
}

