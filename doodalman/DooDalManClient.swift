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
import SwiftyJSON

class Room: NSObject, MKAnnotation {
    var id: Int?
    var title: String?
    var thumbnail: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(id:Int, title: String, thumbnail: UIImage, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.coordinate = coordinate
    }
    


//    var price: Int?
//    var startDate: Date?
//    var endDate: Date?
//    var photos: [UIImage]?
    
    
}

struct Filter {
    var startPrice: Int?
    var endPirce: Int?
    var startDate: Date?
    var endDate: Date?
}


class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Room]()
    
    
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
    
    
    func fetchRooms(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping ((_ roomList: [[String:AnyObject]]?, _ error: NSError? ) -> ()) ) -> Void {
        let url = makeURLFromParameters("/rooms/list", parameters)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                compeletionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // SwiftyJSON
            // let parsedResult = JSON(data: data)

            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
//
            guard let roomList = parsedResult["data"] as? [[String: AnyObject]] else {
                sendError("No data: Room List")
                return
            }
            
            compeletionHandler(roomList, nil)
            
        }
        
        task.resume()

        
    }
    
    func fetchRoomsByGps(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping ((_ roomList: [[String:AnyObject]]?, _ error: NSError? ) -> ()) ) -> Void  {
        
        let url = makeURLFromParameters("/rooms/list", parameters)
        
        compeletionHandler(nil, nil)
    
    }
    
    
}
