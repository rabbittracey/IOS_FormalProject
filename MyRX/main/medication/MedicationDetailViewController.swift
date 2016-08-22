//
//  MedicationDetailViewController.swift
//  MyRX
//
//  Created by Ji Wang on 7/28/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire
import Foundation

class MedicationDetailViewController: BaseFormViewController{
	var patient_medication :Patient_Medications?
	var isEdit : Bool!
	var isNew :Bool = false
	override func viewDidLoad() {
		super.viewDidLoad()
		if let _=patient_medication{
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
					$0.hidden = true
			}
			isNew=true
			isEdit = true
			patient_medication = Patient_Medications()
			patient_medication!.id = globalData().getUUID()
		}
			patient_medication?.name="adsfadf"
			form +++ Section()
			<<< SegmentedRow<String>("seg"){
				$0.options = ["Required", "Basic"]
				$0.value = "Required"
			}
			+++ Section(){
				$0.tag = "sport_s"
				$0.hidden = "$seg != 'Required'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
			}
			<<< LabelRow("name") {
				$0.title = "Medication Name"
//				$0.selectorTitle = "Medication Name"
//				var options:[String] = []
//				10.forEach({  (index, total) in
//					options.append("\(index)/\(total)")
//				})
//				$0.options = options
				$0.value = self.patient_medication!.name
				$0.disabled = "$segments = 'Edit'"
			}.onCellSelection({ (cell, row) in
				self.insertViewControllerWithId("SearchDrug", inView: self.view,storyboard: UIStoryboard(name: "Main", bundle: nil))

			})
				
			<<< TextFloatLabelRow( "strength_unit") {
				$0.title =  "Strength Unit"
				$0.value = self.patient_medication!.strength_unit
				$0.disabled = "$segments = 'Edit'"
			}
			
			
			<<< DateRow("date_started") {
				$0.value = self.patient_medication!.date_prescribed
				$0.title = "Date Started"
				$0.disabled = "$segments = 'Edit'"
				
			}
			
			<<< TextFloatLabelRow("dosage_unit") {
				$0.title =  "Dosage Unit"
				$0.value = self.patient_medication!.dosage_unit
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("frequency") {
				$0.title =  "Frequency"
				$0.value = self.patient_medication!.frequency
				$0.disabled = "$segments = 'Edit'"
			}
	
		

			<<< TextFloatLabelRow("route") {
				$0.title =  "Route"
				$0.value = self.patient_medication!.route
				$0.disabled = "$segments = 'Edit'"
			}
			
			<<< TextFloatLabelRow("patient_id") {
				$0.title =  "Patient ID"
				$0.value = self.patient_medication!.patient_id
				$0.disabled = "$segments = 'Edit'"
			}
			
				<<< SwitchRow("is_discontinued") {
					$0.title = "Is Discontinued "
					$0.value = self.patient_medication!.is_discontinued
					$0.disabled = "$segments = 'Edit'"
		}
			<<< SwitchRow("are_substitutions_allowed") {
				$0.title = "Are Substitutions Allowed"
				$0.value = self.patient_medication!.are_substitutions_allowed
				$0.disabled = "$segments = 'Edit'"
			}

			
			+++ Section(){
				$0.tag = "music_s"
				$0.hidden = "$seg != 'Basic'"
			}
			
				<<< TextFloatLabelRow( "strength") {
					$0.title =  "Strength"
					$0.value = self.patient_medication!.strength
					$0.disabled = "$segments = 'Edit'"
				}
				
				<<< TextFloatLabelRow("dosage") {
					$0.title =  "Dosage"
					$0.value = self.patient_medication!.dosage
					$0.disabled = "$segments = 'Edit'"
				}
			<<< TextFloatLabelRow("prescribed_by") {
				$0.title =  "Prescribed By"
				$0.value = self.patient_medication!.prescribed_by
				$0.disabled = "$segments = 'Edit'"
		    }
			
			
			
			<<< DateRow("discontinued_date") {
				$0.value = self.patient_medication!.discontinued_date
				$0.title = "Discontinued Date"
				$0.disabled = "$segments = 'Edit'"
				
			}
			<<< DateRow("date_prescribed") {
				$0.value = self.patient_medication!.date_prescribed
				$0.title = "Date Prescribed"
				$0.disabled = "$segments = 'Edit'"
		}
			<<< TextFloatLabelRow("refills_left") {
				$0.title =  "Refills Left"
				$0.value = self.patient_medication!.refills_left
				$0.disabled = "$segments = 'Edit'"
		}
			<<< TextFloatLabelRow("prescription_quantity") {
				$0.title =  "Prescription Quantity"
				$0.value = self.patient_medication!.prescription_quantity
				$0.disabled = "$segments = 'Edit'"
		}
			<<< TextFloatLabelRow("ndc") {
				$0.title =  "NDC code"
				$0.value = self.patient_medication!.ndc
				$0.disabled = "$segments = 'Edit'"
		}
		
			<<< TextAreaRow("notes") {
				$0.placeholder = "Notes"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.patient_medication!.notes
				$0.disabled = "$segments = 'Edit'"
		}
			<<< TextAreaRow("instructions") {
				$0.placeholder = "Instructions"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.patient_medication!.instructions
				$0.disabled = "$segments = 'Edit'"
		}
			<<< TextAreaRow("side_effects") {
				$0.placeholder = "Side Effects"
				$0.textAreaHeight = .Dynamic(initialTextViewHeight: 50)
				$0.value = self.patient_medication!.side_effects
				$0.disabled = "$segments = 'Edit'"
		}
	
		+++ Section()
			<<< ButtonRow("submit") {
				$0.title="Submit"
			}.onCellSelection({ [weak self] (row,cell) in
				self!.updateMedications()
			})
			<<< ButtonRow("delete") {
				$0.title="Delete"
			}.onCellSelection({ [weak self] (row,cell) in
				self?.deleteMedications()
			})
		 if(isNew == false) {
		   form +++ Section()
			  <<< ButtonRow() { (row: ButtonRow) -> Void in
				  row.title = "View Reminder"
			     }.onCellSelection({  [weak self]  (cell, row) in
				  self?.performSegueWithIdentifier("ReminderSegue", sender: nil)
			     })
	          <<< ButtonRow() { (row: ButtonRow) -> Void in
	                row.title = "View Fills"
	                   }  .onCellSelection({  [weak self]  (cell, row) in
					self?.performSegueWithIdentifier("FillSegue", sender: nil)
	                 })
		     }
	}

	func updateMedicationName(name:String) {
		patient_medication!.name = name
		let nameRow = (form.rowByTag("name") as? LabelRow)
		nameRow?.value = name
		nameRow?.updateCell()
	}

	private func updateMedications() {
		let values = form.values()
		
		switch Patient_Medications.instance(values) {
		case .Error(let field,let message):
			notification_top.showNotification(field, body: message, onTap: { (Void) in
				
			})
		case .Ok(let patient_medication):
			try! currentRealm().write({
				self.patient_medication!.copyfrom(patient_medication)
//				if ( isNew ) {
//					self.patient_medication!.id = globalData().getUUID()
//				}
				currentRealm().add(self.patient_medication!, update: true)
				
				
			})
			
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	
	private func deleteMedications() {
		
		
		try! currentRealm().write({
			
			
			self.patient_medication!.is_archived = true
			currentRealm().add(self.patient_medication!, update: true)
			
			
		})
		
		self.navigationController?.popViewControllerAnimated(true)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destine = segue.destinationViewController as? RemindersViewController{
			destine.patient_medication = patient_medication
		} else if let destine = segue.destinationViewController as? AddFillViewController {
			destine.patient_medication = patient_medication
		}
	}
	
	
}
