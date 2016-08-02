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


class Patient_Medication : MDObject , MDMappable {
	dynamic var name = " "
	dynamic var date_started = NSDate()
	dynamic var strength: String?
	dynamic var strength_unit = " "
	dynamic var dosage: String?
	dynamic var dosage_unit = " "
	dynamic var frequency = " "
	dynamic var route = " "
	dynamic var is_discontinued = false
	dynamic var discontinued_date: NSDate?
	dynamic var prescribed_by: String?
	dynamic var date_prescribed: NSDate?
	dynamic var refills_left: String?
	dynamic var are_substitutions_allowed = false
	dynamic var prescription_quantity: String?
	dynamic var instructions: String?
	dynamic var side_effects: String?
	dynamic var notes: String?
	dynamic var patient_id = " "
	dynamic var ndc: String?
	

	required convenience init?(_ map: Map) {
		self.init()
	}
	func mdmap(map:Map) {
		name<-map["name"]
		date_started<-map["date_started"]
		strength<-map["strength"]
		strength_unit<-map["strength_unit"]
		dosage<-map["dosage"]
		dosage_unit<-map["dosage_unit"]
		frequency<-map["frequency"]
		route<-map["route"]
		is_discontinued<-map["is_discontinued"]
		discontinued_date<-map["discontinued_date"]
		prescribed_by<-map["prescribed_by"]
		date_prescribed<-map["date_prescribed"]
		refills_left<-map["refills_left"]
		are_substitutions_allowed<-map["are_substitutions_allowed"]
		prescription_quantity<-map["prescription_quantity"]
		instructions<-map["instructions"]
		side_effects<-map["side_effects"]
		notes<-map["notes"]
		patient_id<-map["patient_id"]
		ndc<-map["ndc"]
	}
	
	class func instance(value:[String:Any?]) -> ModelResult<Patient_Medication> {
		let patient_medication = Patient_Medication()
		
		//need to fix it, how to set the id of the medication
		patient_medication.id = getID()
		guard let name = value["name"] as? String else {
			return .Error(field:"name", message: " The name of medication can not be blank")
		}
		
		
		patient_medication.name=name
		patient_medication.date_started = (value["date_started"] as? NSDate)!
		patient_medication.strength=value["strength"] as? String
		patient_medication.strength_unit = (value["strength_unit"] as? String)!
		patient_medication.dosage=value["dosage"] as? String
		patient_medication.dosage_unit = (value["dosage_unit"] as? String)!
		patient_medication.frequency=(value["frequency"] as? String)!
		patient_medication.route=(value["route"] as? String)!
		patient_medication.is_discontinued=(value["is_discontinued"] as? Bool)!
		patient_medication.discontinued_date=value["discontinued_date"] as? NSDate
		patient_medication.prescribed_by=value["prescribed_by"] as? String
		patient_medication.date_prescribed=value["date_prescribed"] as? NSDate;	patient_medication.refills_left=value["refills_left"] as? String
		
		patient_medication.are_substitutions_allowed = (value["are_substitutions_allowed"] as? Bool)!
		patient_medication.prescription_quantity=value["prescription_quantity"] as? String
		patient_medication.instructions=value["instructions"] as? String
		patient_medication.side_effects=value["side_effects"] as? String
		patient_medication.notes=value["notes"] as? String
		patient_medication.patient_id=(value["patient_id"] as? String)!
		patient_medication.ndc=value["fda_status"] as? String
	    return .Ok(patient_medication)
	}
	func copyfrom(let patient_medication:Patient_Medication) {
		
		
		if self.name != patient_medication.name{
			self.name = patient_medication.name
		}
		if self.date_started != patient_medication.date_started{
			self.date_started = patient_medication.date_started
		}
		if self.strength != patient_medication.strength{
			self.strength = patient_medication.strength
		}
		if self.strength_unit != patient_medication.strength_unit{
			self.strength_unit = patient_medication.strength_unit
		}
		if self.dosage != patient_medication.dosage{
			self.dosage = patient_medication.dosage
		}
		
		if self.dosage_unit != patient_medication.dosage_unit{
			self.dosage_unit = patient_medication.dosage_unit
		}
		
		if self.frequency != patient_medication.frequency{
			self.frequency = patient_medication.frequency
		}
		
		if self.route != patient_medication.route{
			self.route = patient_medication.route
		}

		if self.is_discontinued != patient_medication.is_discontinued{
			self.is_discontinued = patient_medication.is_discontinued
		}
		
		if self.discontinued_date != patient_medication.discontinued_date{
			self.discontinued_date = patient_medication.discontinued_date
		}
		
		if self.prescribed_by != patient_medication.prescribed_by{
			self.prescribed_by = patient_medication.prescribed_by
		}
		if self.date_prescribed != patient_medication.date_prescribed{
			self.date_prescribed = patient_medication.date_prescribed
		}
		if self.refills_left != patient_medication.refills_left{
			self.refills_left = patient_medication.refills_left
		}
		if self.are_substitutions_allowed != patient_medication.are_substitutions_allowed{
			self.are_substitutions_allowed = patient_medication.are_substitutions_allowed
		}
		if self.prescription_quantity != patient_medication.prescription_quantity{
			self.prescription_quantity = patient_medication.prescription_quantity
		}
		if self.instructions != patient_medication.instructions{
			self.instructions = patient_medication.instructions
		}
		if self.side_effects != patient_medication.side_effects{
			self.side_effects = patient_medication.side_effects
		}
		if self.notes != patient_medication.notes{
			self.notes = patient_medication.notes
		}
		if self.patient_id != patient_medication.patient_id{
			self.patient_id = patient_medication.patient_id
		}
		if self.ndc != patient_medication.ndc{
			self.ndc = patient_medication.ndc
		}
	}
}

class Medication_Reminders : MDObject , MDMappable {
	
	dynamic var name = " "
	dynamic var reminder_time:NSDate?
	dynamic var recurrence:String?
	dynamic var send_reminders_to:String?
	dynamic var send_text_message:String?
	dynamic var medication:Medication?
	
	required convenience init?(_ map: Map) {
		self.init()
	}
	func mdmap(map:Map) {
		name<-map["name"]
		reminder_time<-map["reminder_time"]
		recurrence<-map["recurrence"]
		send_reminders_to<-map["send_reminders_to"]
		send_text_message<-map["send_text_message"]
		medication<-map["Medication"]
	}
	
	class func instance(value:[String:Any?]) -> ModelResult<Medication_Reminders> {
		let medication_reminder = Medication_Reminders()
		
		//need to fix it, how to set the id of the medication
		medication_reminder.id = getID()
		guard let name = value["name"] as? String else {
			return .Error(field:"name", message: " The name of medication reminder can not be blank")
		}
		
		
		medication_reminder.name=name
		medication_reminder.reminder_time=value["reminder_time"] as? NSDate
		medication_reminder.recurrence=value["recurrence"] as? String
		medication_reminder.send_reminders_to=value["send_reminders_to"] as? String
		medication_reminder.send_text_message=value["send_text_message"] as? String
		medication_reminder.medication=value["medication"] as? Medication
		
		
		
		return .Ok(medication_reminder)
	}
	func copyfrom(let medication_reminder:Medication_Reminders) {
		
		if self.name != medication_reminder.name{
			self.name = medication_reminder.name
		}
		if self.reminder_time != medication_reminder.reminder_time{
			self.reminder_time = medication_reminder.reminder_time
		}
		if self.recurrence != medication_reminder.recurrence{
			self.recurrence = medication_reminder.recurrence
		}
		if self.send_reminders_to != medication_reminder.send_reminders_to{
			self.send_reminders_to = medication_reminder.send_reminders_to
		}
		if self.send_text_message != medication_reminder.send_text_message{
			self.send_text_message = medication_reminder.send_text_message
		}
		if self.medication != medication_reminder.medication{
			self.medication = medication_reminder.medication
		}
	}
}

class Medication_Add_Fills : MDObject , MDMappable {
	
	dynamic var date_filled = NSDate()
	dynamic var next_refilled_date:NSDate?
	dynamic var days_supply:String?
	dynamic var refills_left:String?
	dynamic var pharmacy_name:String?
	dynamic var pharmacy_phone_number:String?
	dynamic var prescription_number: String?
	dynamic var lot_number:String?
	dynamic var source: String?
	dynamic var notes: String?
	dynamic var medicaiton: Medication
	
	required convenience init?(_ map: Map) {
		self.init()
	}
	func mdmap(map:Map) {
		date_filled<-map["date_filled"]
		next_refilled_date<-map["next_refilled_date"]
		days_supply<-map["days_supply"]
		refills_left<-map["refills_left"]
		pharmacy_name<-map["pharmacy_name"]
		pharmacy_phone_number<-map["pharmacy_phone_number"]
		prescription_number<-map["prescription_number"]
		lot_number<-map["lot_number"]
		source<-map["source"]
		notes<-map["notes"]
		medicaiton<-map["medication"]
	}
	
	class func instance(value:[String:Any?]) -> ModelResult<Medication_Add_Fills> {
		let medication_add_fill = Medication_Add_Fills()
		
		//need to fix it, how to set the id of the medication
		medication_add_fill.id = getID()
		
		
		medication_add_fill.date_filled=value["date_filled"] as? NSDate
		medication_add_fill.next_refill_date=value["next_refill_date"] as? NSDate
		medication_add_fill.days_supply=value["days_supply"] as? String
		medication_add_fill.refills_left=value["refills_left"] as? String
		medication_add_fill.pharmacy_name=value["pharmacy_name"] as? String
		medication_add_fill.pharmacy_phone_number=value["pharmacy_phone_number"] as? String
		medication_add_fill.prescription_number=value["prescription_number"] as? String
		medication_add_fill.lot_number=value["lot_number"] as? String
		medication_add_fill.source=value["source"] as? String
		medication_add_fill.notes=value["notes"] as? String
		medication_add_fill.medication=value["medication"] as? Medication
		
		
		
		return .Ok(medication_add_fill)
	}
	func copyfrom(let medication_add_fill:Medication_Add_Fills) {
		
		if self.date_filled != medication_add_fill.date_filled{
			self.date_filled = medication_add_fill.date_filled
		}
		if self.next_refilled_date != medication_add_fill.next_refilled_date{
			self.next_refilled_date = medication_add_fill.next_refilled_date
		}
		if self.days_supply != medication_add_fill.days_supply{
			self.days_supply = medication_add_fill.days_supply
		}
		if self.refills_left != medication_add_fill.refills_left{
			self.refills_left = medication_add_fill.refills_left
		}
		if self.pharmacy_name != medication_add_fill.pharmacy_name{
			self.pharmacy_name = medication_add_fill.pharmacy_name
		}
		if self.pharmacy_phone_number != medication_add_fill.pharmacy_phone_number{
			self.pharmacy_phone_number = medication_add_fill.pharmacy_phone_number
		}
		if self.prescription_number != medication_add_fill.prescription_number{
			self.prescription_number = medication_add_fill.prescription_number
		}
		if self.lot_number != medication_add_fill.lot_number{
			self.lot_number = medication_add_fill.lot_number
		}
		if self.source != medication_add_fill.source{
			self.source = medication_add_fill.source
		}
		if self.notes != medication_add_fill.notes{
			self.notes = medication_add_fill.notes
		}
		if self.medicaiton != medication_add_fill.medicaiton{
			self.medicaiton = medication_add_fill.medicaiton
		}

		
	}
}



