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

import JWT

import SocketIO

class DooDalMan {
    
    static let shared = DooDalMan()
    
    var rooms = [Room]()
    
    var history = [Int]()
    
    var filter = Filter()
    
    var contactClient: Contact?
    
    
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
    
    func fetchRoomInfo(_ room: Room, _ compeletionHandler: @escaping (_ roomInfo: RoomInfo?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/rooms/get/\(room.id!)", nil)
        
        Alamofire.request(url).responseObject{  (response: DataResponse<RoomInfo>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let roomInfo:RoomInfo = response.result.value else {
                sendError("cannot json parsing")
                return
            }
            
            room.detail = roomInfo.detail
            room.photoList = roomInfo.photoList
            room.isLike = roomInfo.isLike
            room.isHost = roomInfo.isHost
            
            compeletionHandler(roomInfo, nil)
            
        }
    }
    
    func likeRoom(_ room: Room, _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ result: Bool?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/rooms/like/\(room.id!)", nil)
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let result = response.result.value else {
                sendError("cannot json parsing")
                return
            }
            guard let statusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                sendError("cannot find HttpStatusCode")
                return
            }
            
            compeletionHandler(statusCode, result as? Bool,  nil)
            
            
        }
    }
    
    func signUp(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping (_ result: Bool?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/signup", nil)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess {
                print("success")
            } else {
                print("fail: \(response.result.error?.localizedDescription)")
                print("fail: \(response.result.value)")
                return
            }
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
            }
        }
        
        
    }
    
    
    func signIn(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let token = JWT.encode(parameters, algorithm: .hs256("doodalman".data(using: .utf8)!))
        
        self.signIn(withToken: token, compeletionHandler)
        
    }
    
    func signIn(withToken token: String, _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {

        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        let url = makeURLFromParameters("/auth/signin", nil)
        
        Alamofire.request(url, method:. post, parameters: ["token": token], encoding: JSONEncoding.default).responseJSON { response in
            if response.result.isSuccess {
                print("success")
            } else {
                print("fail: \(response.result.error?.localizedDescription)")
                print("fail: \(response.result.value)")
                return
            }
            
            guard let statusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                sendError("cannot find HttpStatusCode")
                return
            }
            UserDefaults.standard.set(true, forKey: "hasSignedBefore")

            UserDefaults.standard.set(token, forKey: "authToken")
            
            
            compeletionHandler(statusCode, nil)
            
        }

        
    }
    
    func contact(_ room: Room, _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/rooms/contact/\(room.id!)", nil)
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default).responseObject{  (response: DataResponse<Contact>) in

            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }

            
            guard let statusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                sendError("cannot find HttpStatusCode")
                return
            }
            
            guard statusCode == HttpStatusCode.Http200_OK else {
                compeletionHandler(statusCode, nil)
                return
            }
            
            guard let contact:Contact = response.result.value else {
                sendError("cannot json parsing")
                return
            }

            self.contactClient = contact
            
            compeletionHandler(statusCode, nil)
            
            
        }
    }
    
}
