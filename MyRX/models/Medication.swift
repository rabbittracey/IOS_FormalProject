//
//  Medication.swift
//  MyRX
//
//  Created by Ji Wang on 7/28/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import Eureka


class JSonArrayToListTransform<T:Object where T : MDMappable> : TransformType {
    typealias Object = List<T>
    typealias JSON = [T]
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        return nil
    }
    func transformToJSON(value: Object?) -> JSON? {
        guard let value = value else {
            return nil
        }
        var ret=[T]()
        value.count.forEach { (index, total) in
            ret.append(value[index])
        }
        return ret
    }
    
}
class Medication : MDObject , MDMappable {
	
	dynamic var drug_name = " "
	dynamic var fda_status:String?
	dynamic var ttddrugid:String?
	dynamic var lnm:String?
	dynamic var indication:String?
	dynamic var cas_number:String?
	dynamic var formular:String?
	dynamic var pubchem_cid:String?
	dynamic var pubchem_sid:String?
	dynamic var chebi_id:String?
	dynamic var superdrug_atc:String?
	dynamic var superdrug_cas:String?
	dynamic var ndc:String?
	dynamic var side_effects:String?
    let reminders:List<Immunization> = List<Immunization>()
    
	required convenience init?(_ map: Map) {
		self.init()
	}
	func mdmap(map:Map) {
		drug_name<-map["drug_name"]
		fda_status<-map["fda_status"]
		ttddrugid<-map["ttddrugid"]
		 lnm<-map["Inm"]
		indication<-map["indication"]
		cas_number<-map["cas_number"]
		formular<-map["formular"]
		pubchem_cid<-map["pubchem_cid"]
		pubchem_sid<-map["pubchem_sid"]
		chebi_id<-map["chebi_id"]
		superdrug_atc<-map["superdrug_atc"]
		superdrug_cas<-map["superdrug_cas"]
		ndc<-map["ndc"]
		side_effects<-map["side_effects"]
   }
	
	class func instance(value:[String:Any?]) -> ModelResult<Medication> {
		let medication = Medication()
		
		//need to fix it, how to set the id of the medication
		medication.id = getID()
		guard let name = value["name"] as? String else {
			return .Error(field:"name", message: " The name of medication can not be blank")
		}
		
		
		medication.drug_name=name
		medication.fda_status=value["fda_status"] as? String
		medication.ttddrugid=value["ttddrugid"] as? String
		medication.lnm=value["Inm"] as? String
		medication.indication=value["indication"] as? String
		medication.cas_number=value["cas_number"] as? String
		medication.formular=value["formular"] as? String
		medication.pubchem_cid=value["pubchem_cid"]as? String
		medication.pubchem_sid=value["pubchem_sid"] as? String
		medication.chebi_id=value["chebi_id"] as? String
		medication.superdrug_atc=value["superdrug_atc"] as? String
		medication.superdrug_cas=value["superdrug_cas"] as? String
		medication.ndc=value["ndc"] as? String
		medication.side_effects=value["side_effects"] as? String

		
		
		return .Ok(medication)
	}
	func copyfrom(let medication:Medication) {
		
	
		if self.drug_name != medication.drug_name{
			self.drug_name = medication.drug_name
		}
		if self.fda_status != medication.fda_status{
			self.fda_status = medication.fda_status
		}
		if self.ttddrugid != medication.ttddrugid{
			self.ttddrugid = medication.ttddrugid
		}
		if self.lnm != medication.lnm{
			self.lnm = medication.lnm
		}
		if self.indication != medication.indication{
			self.indication = medication.indication
		}
		if self.cas_number != medication.cas_number{
			self.cas_number = medication.cas_number
		}
		if self.formular != medication.formular{
			self.formular = medication.formular
		}
		if self.pubchem_cid != medication.pubchem_cid{
			self.pubchem_cid = medication.pubchem_cid
		}
		if self.pubchem_sid != medication.pubchem_sid{
			self.pubchem_sid = medication.pubchem_sid
		}
		if self.chebi_id != medication.chebi_id{
			self.chebi_id = medication.chebi_id
		}
		if self.superdrug_atc != medication.superdrug_atc{
			self.superdrug_atc = medication.superdrug_atc
		}
		if self.superdrug_cas != medication.superdrug_cas{
			self.superdrug_cas = medication.superdrug_cas
		}
		if self.ndc != medication.ndc{
			self.ndc = medication.ndc
		}
		
		if self.side_effects != medication.side_effects{
			self.side_effects = medication.side_effects
		}
		
		
		
		
	}
	
}

