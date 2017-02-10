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


class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Room]()
    
    
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
    
}
