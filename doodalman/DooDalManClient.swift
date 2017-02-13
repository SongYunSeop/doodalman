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
    
    func check(_ room: Room) -> Bool {
        if let filterStartDate = self.startDate, let roomStartDate = room.startDate, roomStartDate < filterStartDate   {
            return false
        }
        if let filterEndDate = self.endDate, let roomEndDate = room.endDate, filterEndDate < roomEndDate {
            return false
        }
        if let filterStartPrice = self.startPrice, let roomPrice = room.price, roomPrice < (filterStartPrice * 10000) {
            return false
        }
        
        if let filterEndPrice = self.endPrice, let roomPrice = room.price, (filterEndPrice * 10000) < roomPrice {
            return false
        }
        return true
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
    var latitude: Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude! as CLLocationDegrees, longitude: self.longitude! as CLLocationDegrees)
        }
    }
    var price: Int?
    var startDateString: String?
    var endDateString: String?
    var startDate: Date?
    var endDate: Date?
    var photoList: [String]?

    
    
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
        
        photoList <- map["photoList"]

        
    }
}

class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Int]()
    
    var filter = Filter()
    
    var filterdRooms: [Room] {
        get {
            return self.rooms.filter({self.filter.check($0)})
        }
    }
    
    
    private func makeURLFromParameters(_ url: String, _ parameters: [String:AnyObject]?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Server.APIScheme
        components.host = Constants.Server.APIHost
        components.path = url
        if Constants.Server.APIHost == "localhost" {
            components.port = 3000
        }
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
    
    func fetchRoomInfo(_ roomId: Int, _ compeletionHandler: @escaping (_ roomInfo: Room?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/room/get/\(roomId)", nil)
        
        Alamofire.request(url).responseJSON{ response in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let json = response.result.value else {
                sendError("cannot json parsing")
                return
            }
            
            print(json)
            
        }
    }
    
    
    
}
