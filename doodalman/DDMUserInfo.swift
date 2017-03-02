//
//  DDMUserInfo.swift
//  doodalman
//
//  Created by mac on 2017. 3. 2..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class UserInfo: Mappable {
    var email: String?
    var username: String?
    
    var likeRooms: [Room]?
    var contactRooms: [Room]?
    var hasRoom: Bool?
    var myRoom: Room?
    
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
