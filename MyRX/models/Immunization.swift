//
//  Immunization.swift
//  MyRX
//
//  Created by yaowei on 16/7/15.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import Eureka


class Immunization : MDObject , MDMappable {
    dynamic var name = ""
    dynamic var date_administered = NSDate()
    dynamic var reImmunization_due_date:NSDate?
    dynamic var administrator:String?
    dynamic var notes:String?
    dynamic var source:String?
    dynamic var patient_id: String?
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
    dynamic var reminder:ImmunizationReminder?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    func mdmap(map:Map) {
        name <- map[ "name"]
        date_administered<-(map["date_administered"],DateFormatterTransform(dateFormatter: DATEFORMAT))
        reImmunization_due_date<-(map["reimmunization_due_date"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        administrator<-map["administrator"]
        notes<-map["notes"]
        source<-map["source"]
        patient_id<-map["patient_id"]
        funding_source<-map["funding_source"]
        route_site<-map["route_site"]
        vaccine_lot<-map["vaccine_lot"]
        vaccine_mfr<-map["vaccine_mfr"]
        publication_date<-(map["publication_date"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        date_on_vis<-(map["date_on_vis"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        date_given<-(map["date_given"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        adverse_reaction_log<-map["adverse_reaction_log"]
        clinic_name<-map["clinic_name"]
        clinic_address<-map["clinic_address"]
        administrator_affiliation<-map["administrator_affiliation"]
        reminder <- map["reminder"]
    }    
}
class ImmunizationReminder : MDObject , MDMappable {
    dynamic var reminder_date:NSDate?
    
    dynamic var notes:String?
    dynamic var email:String?
    dynamic var immunization:Immunization?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    func mdmap(map:Map) {
        id <- map["id"]
        reminder_date<-(map["reminder_date"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        notes<-map["notes"]
        email<-map["email"]
        
    }
}
class PackImmunization :  Mappable {
    dynamic var version = 0
    dynamic var isContinue = false
    dynamic var immunizations:[Immunization]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    static func valid(map: Map) throws {
        
    }
    func mapping(map:Map) {
        version <- map["next_version"]
        isContinue <- map["continue"]
        immunizations <- map["datas"]
    }
    
}

