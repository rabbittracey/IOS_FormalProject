//
//  Immunization.swift
//  MyRX
//
//  Created by yaowei on 16/7/15.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Eureka


class Immunization : Object , MDMappable {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var date_administered = NSDate()
    dynamic var reImmunization_due_date:NSDate?
    dynamic var administrator:String?
    dynamic var notes:String?
    dynamic var source:String?
    dynamic var funding_source:String?
    dynamic var route_site:String?
    dynamic var vaccine_lot:String?
    dynamic var vaccine_mfr:String?
    dynamic var publication_date:NSDate?
    dynamic var date_on_vis:NSDate?
    dynamic var date_given:NSDate?
    dynamic var adverse_reaction_log:String?
    dynamic var clinic_name:String?
    dynamic var clinic_address:String?
    dynamic var administrator_affiliation:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mmapping(map:Map) {
        name <- map["name"]
        name <-- (map["name"],"\\d")
    }
}