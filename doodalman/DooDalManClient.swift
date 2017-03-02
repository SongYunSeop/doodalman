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

enum HttpStatusCode: Int {
    case Http200_OK = 200
    case Http400_BadRequest = 400
    case Http401_Unauthorized = 401
    case Http403_Forbidden = 403
    case Http404_NotFound = 404
    case Http500_InternalServerError = 500
}



// DooDalMan Single tone Model
class DooDalMan {
    
    static let shared = DooDalMan()
    
    // RoomListViewController와 MapViewController에서 사용할 방 리스트
    var rooms = [Room]()
    
    // room history
    // var history = [Int]()
    
    // 필터 모델
    var filter = Filter()
    
    // 방 주인일 경우 Contact 리스트를 볼 수있게 사용하는 모델
    var contacts = [Contact]()
    
    // Auth Token 서버에 요청할 때 포함해서 보내준다
    var authToken: String?
    
    // 찜한 방 리스트
    var likeRooms = [Room]()
    
    // 연락한 방 리스트
    var contactRooms = [Room]()
    
    // 유저 정보
    var userInfo: UserInfo?
    
    
    // MARK: - Make URL From Parameters
    private func makeURLFromParameters(_ url: String, _ parameters: [String:AnyObject]?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Server.APIScheme
        components.host = Constants.Server.APIHost
        components.path = url
        components.queryItems = [URLQueryItem]()

        // 파라미터를 URL Query String으로 추가하기 위해 사용
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        // 로그인이 되어있으면 authToken을 가지고 있음
        if let token = self.authToken {
            let queryToken = URLQueryItem(name: "token", value: token)
            components.queryItems!.append(queryToken)
        }
        
        return components.url!
    }
    
    // MARK: Fetch Room List
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
    
    // MARK: - Fetch Room Info
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
    
    // MARK: - Like Room
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
    
    
    // MARK: - SIGN UP
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
    
    // MARK: - LOG IN
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
    
    // MARK: - LOG IN With Auth Token
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
    
    // MARK: - Log Out
    func logOut(_ compeletionHandler: () -> ()) {
        self.authToken = nil
        UserDefaults.standard.set(false, forKey: "hasSignedBefore")
        UserDefaults.standard.removeObject(forKey: "authToken")
        compeletionHandler()
    }
    
    // MARK: - Contact by Guest
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
    
    // MARK: - Fetch Contact List by Room Host
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
    
    // MARK: - Fetch User Info
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
    
    // MARK: - Add Room
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
