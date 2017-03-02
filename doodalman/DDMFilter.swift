//
//  DDMFilter.swift
//  doodalman
//
//  Created by mac on 2017. 3. 2..
//  Copyright © 2017년 song. All rights reserved.
//

import Foundation

// 필터 모델
struct Filter {
    var startDate: Date?
    var endDate: Date?
    var startPrice: Int?
    var endPrice: Int?
    
    var filterData: [String: AnyObject] {
        get {
            var result:[String: AnyObject] = [:]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            
            if let startDate = self.startDate {
                result["startDate"] = dateFormatter.string(from: startDate) as AnyObject
            }
            if let endDate = self.endDate {
                result["endDate"] = dateFormatter.string(from: endDate) as AnyObject
            }
            
            if let startPrice = self.startPrice {
                result["startPrice"] = startPrice as AnyObject
            }
            
            if let endPrice = self.endPrice {
                result["endPrice"] = endPrice as AnyObject
            }
            
            return result
        }
    }
}
