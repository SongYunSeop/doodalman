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
    
    var contacts = [Contact]()
    
    var authToken: String?
    
    var likeRooms = [Room]()
    
    var contactRooms = [Room]()
    
    var userInfo: UserInfo?
    
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
        
        if let token = self.authToken {
            let queryToken = URLQueryItem(name: "token", value: token)
            components.queryItems!.append(queryToken)
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
    
    func signUp(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/signup", nil)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let statusCode:HttpStatusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                return
            }
            
            if statusCode == HttpStatusCode.Http200_OK {
                if let result = response.result.value {
                    let JSON = result as! Dictionary<String, AnyObject>
                    let token = JSON["token"]!
                    UserDefaults.standard.set(true, forKey: "hasSignedBefore")
                    UserDefaults.standard.set(token, forKey: "authToken")
                    self.authToken = token as? String
                }
            } else {
                UserDefaults.standard.set(false, forKey: "hasSignedBefore")
                UserDefaults.standard.set(nil, forKey: "authToken")
                self.authToken = nil
            }
            
            compeletionHandler(statusCode, nil)

        }
        
        
    }
    
    func logIn(_ parameters: [String: AnyObject], _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/login", nil)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }

            guard let statusCode:HttpStatusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                return
            }
            
            if statusCode == HttpStatusCode.Http200_OK {
                if let result = response.result.value {
                    let JSON = result as! Dictionary<String, AnyObject>
                    let token = JSON["token"]!
                    UserDefaults.standard.set(true, forKey: "hasSignedBefore")
                    UserDefaults.standard.set(token, forKey: "authToken")
                    self.authToken = token as? String
                }
            } else {
                UserDefaults.standard.set(false, forKey: "hasSignedBefore")
                UserDefaults.standard.set(nil, forKey: "authToken")
                self.authToken = nil
            }
            
            compeletionHandler(statusCode, nil)
        }
    }
    
    func logIn(withToken token: String, _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/authToken", nil)
        
        Alamofire.request(url, method: .post, parameters: ["token": token], encoding: JSONEncoding.default).responseJSON { response in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            guard let statusCode:HttpStatusCode = HttpStatusCode(rawValue: (response.response?.statusCode)!) else {
                return
            }
            
            if statusCode == HttpStatusCode.Http200_OK {
                if let result = response.result.value {
                    let JSON = result as! Dictionary<String, AnyObject>
                    let token = JSON["token"]!
                    UserDefaults.standard.set(true, forKey: "hasSignedBefore")
                    UserDefaults.standard.set(token, forKey: "authToken")
                    self.authToken = token as? String
                }
            } else if statusCode == HttpStatusCode.Http401_Unauthorized {
                UserDefaults.standard.set(false, forKey: "hasSignedBefore")
                UserDefaults.standard.removeObject(forKey: "authToken")
                

            }
            
            compeletionHandler(statusCode, nil)
        }

        
    }
    
    func logOut(_ compeletionHandler: () -> ()) {
        self.authToken = nil
        UserDefaults.standard.set(false, forKey: "hasSignedBefore")
        UserDefaults.standard.removeObject(forKey: "authToken")
        compeletionHandler()
    }
    
    func contact(_ room: Room, _ compeletionHandler: @escaping (_ httpStatusCode: HttpStatusCode?, _ contact: Contact?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
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
                compeletionHandler(statusCode, nil, nil)
                return
            }
            
            guard let contact:Contact = response.result.value else {
                sendError("cannot json parsing")
                return
            }

            compeletionHandler(statusCode, contact, nil)
            
        }
    }
    
    
    func fetchContactList(_ room: Room, _ compeletionHandler: @escaping (_ result: [Contact]?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/rooms/contact/\(room.id!)", nil)
        
        Alamofire.request(url).responseObject { (response:  DataResponse<ContactList>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            let roomsResponse = response.result.value
            if let contacts = roomsResponse?.contacts {
                self.contacts = contacts
            }
            compeletionHandler([], nil)

        }
    }
    
    func fetchUserContactList( _ compeletionHandler: @escaping (_ result: [Contact]?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/contacts", nil)
        
        Alamofire.request(url).responseObject { (response:  DataResponse<RoomsResponse>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            let roomsResponse = response.result.value
            if let rooms = roomsResponse?.rooms {
                self.contactRooms = rooms
            }
            compeletionHandler([], nil)
            
        }
    }
    
    func fetchLikeRooms( _ compeletionHandler: @escaping (_ result: [Contact]?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/likes", nil)
        
        Alamofire.request(url).responseObject { (response: DataResponse<RoomsResponse>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            let roomsResponse = response.result.value
            if let rooms = roomsResponse?.rooms {
                self.likeRooms = rooms
            }
            compeletionHandler([], nil)
        }

    }
    
    func fetchUserInfo(_ compeletionHandler: @escaping (_ result: [Contact]?, _ error: Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        
        let url = makeURLFromParameters("/auth/info", nil)
        
        Alamofire.request(url).responseObject { (response: DataResponse<UserInfo>) in
            guard response.result.isSuccess else {
                sendError("There was an error with your request: \(response.error)")
                return
            }
            
            if let userInfo = response.result.value {
                self.userInfo = userInfo
            }
            
            compeletionHandler([], nil)
        }

    }
    
    func addRoom(_ parameters:[String: AnyObject], _ compeletionHandler: @escaping (_ roomList:[Room]?, _ error:Error?) -> ()) {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey: error]
            compeletionHandler(nil, NSError(domain: "someError", code: 1, userInfo: userInfo))
        }
        let url = makeURLFromParameters("/rooms/add", nil)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in parameters {
                    if key == "photos" {
                        let photos = value as! [UIImage]
                        for photo in photos {
                            
                            if let imageData = UIImageJPEGRepresentation(photo.resize(size: CGSize(width: 375 * 2, height: 256 * 2)), 0.5) {

                                multipartFormData.append(imageData, withName: "roomPhoto", fileName: "roomPhoto.jpg", mimeType: "image/jpeg")

                            }
                        }
                    }
                    else {
                        multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    print("encode weif")
                    upload.responseJSON { response in
                        debugPrint(response)
                        compeletionHandler(nil, nil)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }

        )

    }
}
