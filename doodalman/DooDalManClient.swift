//
//  models.swift
//  doodalman
//
//  Created by mac on 2017. 2. 8..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

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
        
        photoList <- map["RoomPhotos"]
        full_addr <- map["full_addr"]
        detail <- map["description"]

        
    }
}



class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Int]()
    
    var filter = Filter()
    
    private func makeURLFromParameters(_ url: String, _ parameters: [String:AnyObject]?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Server.APIScheme
        components.host = Constants.Server.APIHost
        components.path = url
        components.queryItems = [URLQueryItem]()

        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    func fetchRooms(_ parameters:[String: AnyObject], _ compeletionHandler: @escaping (_ roomList:[Room]?, _ error:Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            compeletionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
        }
        
 
        let url = makeURLFromParameters("/rooms/list", parameters)
        
        print(url.absoluteString)
        
        Alamofire.request(url).responseObject { (response: DataResponse<RoomsResponse>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            let roomsResponse = response.result.value
            if let rooms = roomsResponse?.rooms {
                self.rooms = rooms
            }
            
            compeletionHandler([], nil)
        }

    }
    
    func fetchRoomInfo(_ room: Room, _ compeletionHandler: @escaping (_ roomInfo: Room?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/rooms/get/\(room.id)", nil)
        
        Alamofire.request(url).responseObject{  (response: DataResponse<Room>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let json = response.result.value else {
                sendError("cannot json parsing")
                return
            }
            
            if let roomInfo:Room = response.result.value {
                
                print(roomInfo)
//                room = roomInfo
            }
            
            print(json)
            
        }
    }
    
    
    
}
