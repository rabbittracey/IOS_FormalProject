//
//  FillDetailViewController.swift
//  MyRX
//
//  Created by Ji Wang on 8/3/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire
import Foundation




class FillDetailViewController: BaseFormViewController{
	var patient_medication :Patient_Medication!
	var fill: Medication_Add_Fill?
	var isNew :Bool = false
	var isEdit : Bool!
	override func viewDidLoad() {
		super.viewDidLoad()
		if let _=fill{
		form +++ Section()
			<<< SegmentedRow<String>("segments"){
				$0.options = ["View", "Edit"]
				$0.value = "View"
			}
		}else{
			form+++Section()
				<<< SegmentedRow<String>("segments"){
					$0.options=["View"]
					$0.value="View"
			}
			isNew=true
			isEdit = true
			fill = Medication_Add_Fill()
		}
		
			
		form +++ Section()
			
			<<< DateRow( "date_filled") {
				$0.title =  "Date Filled"
				$0.value = self.fill!.date_filled
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< DateRow("next_refilled_date") {
				$0.value = self.fill!.next_refilled_date
				$0.title = "Next Refilled Date"
				$0.disabled = "$segments = 'Edit'"
				
			}
		
		
			
			<<< TextFloatLabelRow("days_supply") {
				$0.title =  "Days Supply"
				$0.value = self.fill!.days_supply
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("refills_left") {
				$0.title =  "Refills Left"
				$0.value = self.fill!.refills_left
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< TextFloatLabelRow("pharmacy_name") {
				$0.title =  "Pharmacy Name"
				$0.value = self.fill!.pharmacy_name
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("pharmacy_phone_number") {
				$0.title =  "Pharmacy Phone Number"
				$0.value = self.fill!.pharmacy_phone_number
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("prescription_number") {
				$0.title = "Prescription Number"
				$0.value = self.fill!.prescription_number
				$0.disabled = "$segments = 'Edit'"
			}
			<<< TextFloatLabelRow("lot_number") {
				$0.title = "Lot Number"
				$0.value = self.fill!.lot_number
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< TextAreaRow("notes") {
				$0.placeholder = "Notes"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.fill!.notes
				$0.disabled = "$segments = 'Edit'"
			}
			<<< TextAreaRow("source") {
				$0.placeholder = "source"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.fill!.source
				$0.disabled = "$segments = 'Edit'"
			}
			
			+++ Section()
			<<< ButtonRow("submit") {
				$0.title="Submit"
				}.onCellSelection({ [weak self] (row,cell) in
					self!.updateFills()
					})
			<<< ButtonRow("delete") {
				$0.title="Delete"
				}.onCellSelection({ [weak self] (row,cell) in
					self?.deleteFills()
					})
}
	
	
	private func updateFills() {
		let values = form.values()
		
		switch Medication_Add_Fill.instance(values) {
		case .Error(let field,let message):
			notification_top.showNotification(field, body: message, onTap: { (Void) in
				
			})
		case .Ok(let fill):
			try! currentRealm().write({
				self.fill!.copyfrom(fill)
				currentRealm().add(self.fill!, update: true)
				if (isNew) {
					patient_medication.fills.append(self.fill!)
				}
			})
			
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	private func deleteFills() {
		try! currentRealm().write({
			patient_medication.fills.delete(self.fill!)
		})
		self.navigationController?.popViewControllerAnimated(true)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
			}
	
	
}

