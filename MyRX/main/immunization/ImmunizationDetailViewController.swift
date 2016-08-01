//
//  ImmunizationDetail.swift
//  MyRX
//
//  Created by yaowei on 16/7/23.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire
import Foundation


typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"


class ImmunizationDetailViewController: BaseFormViewController {
	var immunization:Immunization!
	var isEdit : Bool!
	override func viewDidLoad() {
		super.viewDidLoad()
		form +++ Section()
			<<< SegmentedRow<String>("segments"){
				$0.options = ["View", "Edit"]
				$0.value = "View"
			}
						
		   +++ Section("What do you want to talk about:")
			<<< SegmentedRow<String>("seg"){
				$0.options = ["Required", "Basic", "Insurance"]
				$0.value = "Films"
			}
			+++ Section(){
				$0.tag = "sport_s"
				$0.hidden = "$seg != 'Required'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
			}
			<<< PushRow<String>() {
				$0.title = "Immunization Name"
				$0.selectorTitle = "Immunization Name"
				$0.options = [
					"adenovirus vaccine, NOS",
					"adenovirus vaccine, type 4, live, oral",
					"adenovirus vaccine, type 7, live, oral",
					"anthrax vaccine",
					"Bacillus Calmette-Guerin vaccine",
					"botulinum antitoxin",
					"Chickenpox vaccine",
					"cholera vaccine",
					"cytomegalovirus immune globulin, intravenous",
					"dengue fever vaccine",
					"diphtheria and tetanus toxoids, adsorbed for pediatric use",
					"diphtheria antitoxin",
					"diphtheria, tetanus toxoids and acellular pertussis vaccine",
					"diphtheria, tetanus toxoids and acellular pertussis vaccine, 5 pertussis antigens",
					"diphtheria, tetanus toxoids and acellular pertussis vaccine, NOS",
					"diphtheria, tetanus toxoids and pertussis vaccine",
					"DTaP-Haemophilus influenzae type b conjugate vaccine",
					"DTaP-hepatitis B and poliovirus vaccine",
					"DTP-Haemophilus influenzae type b conjugate and hepatitis b vaccine",
					"DTP-Haemophilus influenzae type b conjugate vaccine",
					"Haemophilus influenzae type b conjugate and Hepatitis B vaccine",
					"Haemophilus influenzae type b vaccine, conjugate NOS",
					"Haemophilus influenzae type b vaccine, HbOC conjugate",
					"Haemophilus influenzae type b vaccine, PRP-D conjugate",
					"Haemophilus influenzae type b vaccine, PRP-OMP conjugate",
					"Haemophilus influenzae type b vaccine, PRP-T conjugate",
					"hantavirus vaccine",
					"hepatitis A and hepatitis B vaccine",
					"hepatitis A vaccine, adult dosage",
					"hepatitis A vaccine, NOS",
					"hepatitis A vaccine, pediatric dosage, NOS",
					"hepatitis A vaccine, pediatric/adolescent dosage, 2 dose schedule",
					"hepatitis A vaccine, pediatric/adolescent dosage, 3 dose schedule",
					"hepatitis B immune globulin",
					"hepatitis B vaccine, adult dosage",
					"hepatitis B vaccine, dialysis patient dosage",
					"hepatitis B vaccine, NOS",
					"hepatitis B vaccine, pediatric or pediatric/adolescent dosage",
					"hepatitis B, adolescent/high risk infant dosage",
					"hepatitis C vaccine",
					"hepatitis E vaccine",
					"herpes simplex virus, type 2 vaccine",
					"human immunodeficiency virus vaccine",
					"human papilloma virus vaccine",
					"immune globulin, NOS",
					"immune globuline, intramuscular",
					"immune globuline, intravenous",
					"influenza virus vaccine, live, attenuated, for intranasal use",
					"influenza virus vaccine, NOS",
					"influenza virus vaccine, split virus",
					"influenza virus vaccine, whole virus",
					"Japanese encephalitis vaccine",
					"Junin virus vaccine",
					"Leishmaniasis vaccine",
					"Leprosy vaccine",
					"Lyme disease vaccine",
					"malaria vaccine",
					"measles and rubella virus vaccine",
					"measles virus vaccine",
					"measles, mumps and rubella virus vaccine",
					"measles, mumps, rubella, and varicella virus vaccine",
					"melanoma vaccine",
					"meningococcal polysaccharide(meningitis) vaccine",
					"mumps virus vaccine",
					"parainfluenza-3 virus vaccine",
					"pertussis vaccine",
					"plague vaccine",
					"pneumococcal (pneumonia) vaccine, NOS",
					"pneumococcal conjugate vaccine, polyvalent",
					"pneumococcal polysaccharide vaccine",
					"poliovirus vaccine, inactivated",
					"poliovirus vaccine, NOS",
					"poliovirus, live, oral",
					"Q fever vaccine",
					"rabies immune globulin",
					"rabies vaccine, for intradermal injection",
					"rabies vaccine, for intramuscular injection",
					"rabies vaccione, NOS",
					"respiratory syncytial virus immune globulin, intravenous",
					"respiratory syncytial virus monoclonal antibody (palivizumab), intramuscular",
					"rheumatic fever vaccine",
					"Rift Valley fever vaccine",
					"rotavirus vaccine, tetravalent, live, oral",
					"rubella and mumps virus vaccine",
					"rubella virus vaccine",
					"Staphylococcus bacteriophage lysate",
					"tetanus and diphtheria toxoids, adsorbed for adult use",
					"tetanus immune globulin",
					"tetanus toxoid, adsorbed",
					"tetanus toxoid, NOS",
					"tick-borne encephalitis vaccine",
					"tuberculin skin test, NOS",
					"tuberculin skin test, old tuberculin, multipuncture device",
					"tuberculin skin test, purified protein derivative, intradermal",
					"tuberculin skin test, purified protein derivative, multipuncture device",
					"tularemia vaccine",
					"typhoid vaccine, live, oral",
					"typhoid vaccine, NOS",
					"typhoid vaccine, parenteral, acetone-killed, dried (U.S. Military)",
					"typhoid Vi capsular polysaccharide vaccine",
					"vaccinia (smallpox) vaccine",
					"vaccinia (smallpox) vaccine, diluted",
					"vaccinia immune globulin",
					"varicella virus vaccine",
					"varicella zoster immune globulin",
					"Venezuelan equine encephalitis, inactivated",
					"Venezuelan equine encephalitis, live, attenuated",
					"Venezuelan equine encephalitis, NOS",
					"yellow fever vaccine",
					
					
				]
				$0.value = self.immunization.name
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			
			
			
			<<< DateRow("date_administered") {
				$0.value = self.immunization.date_administered
				$0.title = "Date Administered"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			
			+++ Section(){
				$0.tag = "music_s"
				$0.hidden = "$seg != 'Basic'"
			}
			
			<<< DateRow("reImmunization_due_date") {
				$0.value = self.immunization.reImmunization_due_date
				$0.title = "Reimmunization Due Date"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			<<< TextFloatLabelRow( "administrator") {
				$0.title =  "Administrator"
				$0.value = self.immunization.administrator
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< TextFloatLabelRow("source") {
				$0.title =  "Source"
				$0.value = self.immunization.source
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("route_site") {
				$0.title =  "Route Site"
				$0.value = self.immunization.route_site
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("vaccine_lot") {
				$0.title =  "Vaccine Lot"
				$0.value = self.immunization.vaccine_lot
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("vaccine_mfr") {
				$0.title =  "Vaccine MFR"
				$0.value = self.immunization.vaccine_mfr
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			
			<<< DateRow("publication_date") {
				$0.value = self.immunization.publication_date
				$0.title = "Publication Date"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			
			<<< DateRow("date_on_vis") {
				$0.value = self.immunization.date_on_vis
				$0.title = "Date on VIS"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			<<< DateRow("date_given") {
				$0.value = self.immunization.date_given
				$0.title = "Date Given"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			<<< TextFloatLabelRow("clinic_name") {
				$0.title =  "Clinic Name"
				$0.value = self.immunization.clinic_name
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("adverse_react_log") {
				$0.title =  "Adverse React Log"
				$0.value = self.immunization.adverse_reaction_log
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< TextAreaRow("clinic_address") {
				$0.placeholder  = "Clinic Address"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 40)
				$0.value = self.immunization.clinic_address
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< TextAreaRow("notes") {
				$0.placeholder = "Notes"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.immunization.notes
				$0.disabled = "$segments = 'Edit'"
			}
			
			+++ Section(){
				$0.tag = "films_s"
				$0.hidden = "$seg != 'Insurance'"
			}
			<<< TextFloatLabelRow("funding_source") {
				$0.title = "Funding Source"
				$0.value = self.immunization.funding_source
				$0.disabled = "$segments = 'Edit'"
			}

			
			
			
			
			+++ Section()
			<<< ButtonRow("submit") {
				$0.title="Submit"
				}.onCellSelection({ [weak self] (row,cell) in
					self!.updateImmunizations()
					})
			
			<<< ButtonRow("delete") {
				$0.title="Delete"
				}.onCellSelection({ [weak self] (row,cell) in
					self!.deleteImmunizations()
					})
		}
	
	private func updateImmunizations() {
		let values = form.values()
		
		switch Immunization.instance(values) {
		case .Error(let field,let message):
			notification_top.showNotification(field, body: message, onTap: { (Void) in
				
			})
		case .Ok(let immunization):
			try! currentRealm().write({
				
				
				self.immunization.copyfrom(immunization)
				currentRealm().add(self.immunization, update: true)
				
				
			})
			
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	
	private func deleteImmunizations() {
		
		
		try! currentRealm().write({
			
			
			self.immunization.is_archived = true
			currentRealm().add(self.immunization, update: true)
			
			
		})
		
		self.navigationController?.popViewControllerAnimated(true)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
