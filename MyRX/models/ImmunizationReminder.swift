//
//  ImmunizationReminder.swift
//  MyRX
//
//  Created by Ji Wang on 7/21/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Eureka

class ImmunizationReminder : Object , MDMappable {
    dynamic var id = 0
    dynamic var reminder_date:NSDate?
   
    dynamic var notes:String?
    dynamic var email:String?
    dynamic var immunization:Immunization?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mmapping(map:Map) {
        if map.mappingType == .FromJSON {
            id <- map["id"]
        }       
        reminder_date<-map["reminder_date"],DateFormatterTransform(dateFormatter:DATEFORMAT)
        notes<-map["notes"]
        email<-map["email"]
        
    }
}