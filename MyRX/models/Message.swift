//
//  Message.swift
//  MyRX
//
//  Created by yaowei on 16/7/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Message: Object,Mappable {
    dynamic var id = 0
    dynamic var title = ""
    dynamic var date:NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var abstract:String?
    dynamic var unread = true
    dynamic var message = ""

    required convenience init?(_ map:Map) {
        self.init()
    }
    
    func mapping(map:Map) {
        id <- map["id"]
        title <- map["title"]
        date <- (map["date"],DateTransform())
        abstract <- map["abstract"]
        unread <- map["unread"]
        message <- map["message"]
    }
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
