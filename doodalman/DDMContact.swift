//
//  DDMContact.swift
//  doodalman
//
//  Created by mac on 2017. 3. 2..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

struct ContactList: Mappable {
    var contacts: [Contact] = []
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        contacts <- map["contactList"]
    }
}

class Contact: Mappable {
    var contactId: Int?
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
