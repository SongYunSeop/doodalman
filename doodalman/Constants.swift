//
//  Constants.swift
//  doodalman
//
//  Created by mac on 2017. 2. 7..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation

// MARK: - Constants

struct Constants {
    
    // MARK: Server
    struct Server {
        static let APISchema = "http"
        static let APIHost = "localhost:3000"
        static let APIPath = "/"

    }
    
    // MARK: Server Parameter Keys
    struct ParameterKey {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"

    }
}
