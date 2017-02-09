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

struct Room {
    var id: Int?
    var title: String?
    var location: CLLocation?
    var thumbnail: UIImage?
//    var price: Int?
//    var startDate: Date?
//    var endDate: Date?
//    var photos: [UIImage]?
}


class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Room]()
    
    
    
}
