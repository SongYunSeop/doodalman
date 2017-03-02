//
//  DDMChat.swift
//  doodalman
//
//  Created by mac on 2017. 3. 2..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper


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
