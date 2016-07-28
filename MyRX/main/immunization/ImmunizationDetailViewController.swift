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

class ImmunizationDetailViewController: BaseFormViewController {
	var immunization:Immunization!
	var isEdit : Bool!
	override func viewDidLoad() {
		super.viewDidLoad()
		form +++ Section("Basic Information")
			
			
			
			<<< SegmentedRow<String>("segments"){
				$0.options = ["View", "Edit"]
				$0.value = "Edit"
			}
			
			<<< TextFloatLabelRow("name") {
				$0.title = "Immunization Name"
				$0.value = self.immunization.name
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			
			<<< DateRow("date_administered") {
				$0.value = self.immunization.date_administered
				$0.title = "Date Administered"
				$0.disabled = "$segments = 'Edit'"
				
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
			
			<<< TextFloatLabelRow("notes") {
				$0.title =  "Notes"
				$0.value = self.immunization.notes
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
			
			<<< TextFloatLabelRow("clinic_address") {
				$0.title = "Clinic Address"
				$0.value = self.immunization.clinic_address
				$0.disabled = "$segments = 'Edit'"
			}
			
			+++ Section("Insurance Information")
			<<< TextFloatLabelRow("funding_source") {
				$0.title = "Funding Source"
				$0.value = self.immunization.funding_source
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			//            +++ Section(" ")
			//            <<< ButtonRow("Submit") {
			//                $0.title = "Submit"
			//                try! currentRealm().write {
			//                    immunization.id = getID()
			//                    currentRealm().add(immunization,update: true)
			//                }
			//                navigationController?.popViewControllerAnimated(true)
			//
			//                }.cellSetup({ (cell, row) in
			//                    cell.imageView?.image = UIImage(named: "icon_account")
			//                })
			
			
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
