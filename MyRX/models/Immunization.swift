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
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func instance(value:[String:Any?]) -> ModelResult<Immunization> {
        let immunization = Immunization()
        
        //need to fix it, how to set the id of the immunization
        immunization.id = getID()
        guard let name = value["name"] as? String else {
            return .Error(field:"name", message: " The name of immunization can not be blank")
        }
        guard let date_administered = value["date_administered"] as? NSDate else {
            return .Error(field: "date_administered", message: "The name of date administered can not be blank")
        }
        immunization.name=name
        immunization.date_administered=date_administered
        
        immunization.reImmunization_due_date=value["reImmunization"] as? NSDate
        immunization.administrator=value["administrator"] as? String
        immunization.notes = value["notes"] as? String
        immunization.source=value["source"] as? String
        immunization.patient_id=value["patient_id"] as?  String
        immunization.funding_source=value["funding_source"] as?  String
        immunization.route_site=value["route_site"] as?  String
        immunization.vaccine_lot=value["vaccine_lot"] as?  String
        immunization.vaccine_mfr=value["vaccine_mfr"] as?  String
        immunization.publication_date=value["publication_date"] as? NSDate
        immunization.date_on_vis=value["date_on_vis"] as? NSDate
        immunization.date_given=value["date_given"] as? NSDate
        immunization.adverse_reaction_log=value["adverse_reaction_log"] as?  String
        immunization.clinic_name=value["clinic_name"] as?  String
        immunization.administrator_affiliation=value["administrator_affiliation"] as?  String
        immunization.reminder=nil
        
        return .Ok(immunization)
    }
    func copyfrom(let immunization:Immunization) {
        if self.name != immunization.name{
            self.name = immunization.name
        }
        if self.date_administered != immunization.date_administered{
            self.date_administered = immunization.date_administered
        }
        if self.notes != immunization.notes{
            self.notes = immunization.notes
        }
        if self.source != immunization.source{
            self.source = immunization.source
        }
        if self.patient_id != immunization.patient_id{
            self.patient_id = immunization.patient_id
        }
        if self.funding_source != immunization.funding_source{
            self.funding_source = immunization.funding_source
        }
        if self.route_site != immunization.route_site{
            self.route_site = immunization.route_site
        }
        if self.vaccine_lot != immunization.vaccine_lot{
            self.vaccine_lot = immunization.vaccine_lot
        }
        if self.vaccine_mfr != immunization.vaccine_mfr{
            self.vaccine_mfr = immunization.vaccine_mfr
        }
        if self.publication_date != immunization.publication_date{
            self.publication_date = immunization.publication_date
        }
        if self.date_on_vis != immunization.date_on_vis{
            self.date_on_vis = immunization.date_on_vis
        }
        if self.date_given != immunization.date_given{
            self.date_given = immunization.date_given
        }
        if self.adverse_reaction_log != immunization.adverse_reaction_log{
            self.adverse_reaction_log = immunization.adverse_reaction_log
        }
        
        if self.clinic_name != immunization.clinic_name{
            self.clinic_name = immunization.clinic_name
        }
        if self.administrator_affiliation != immunization.administrator_affiliation{
            self.administrator_affiliation = immunization.administrator_affiliation
        }
        if self.version != immunization.version{
            self.version = immunization.version
        }
        if self.is_archived != immunization.is_archived{
            self.is_archived = immunization.is_archived
        }
        
        
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
//    dynamic var version:Int64 = 0
    dynamic var isContinue = false
    dynamic var immunizations:[Immunization]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    static func valid(map: Map) throws {
        
    }
    func mapping(map:Map) {
//        version <- map["next_version"]
        isContinue <- map["continue"]
        immunizations <- map["datas"]
    }
    
}

