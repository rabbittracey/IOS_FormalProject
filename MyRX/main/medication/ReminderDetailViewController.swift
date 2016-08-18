//
//  ReminderDetailViewController.swift
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



class ReminderDetailViewController: BaseFormViewController{
	var patient_medication :Patient_Medications!
	var reminder : Medication_Reminders?
	var isNew : Bool = false
	var isEdit : Bool!
	override func viewDidLoad() {
		super.viewDidLoad()
		if let _ = reminder {
			form +++ Section()
				<<< SegmentedRow<String>("segments"){
					$0.options = ["View", "Edit"]
					$0.value = "View"
			}
			
		} else {
			form +++ Section()
				<<< SegmentedRow<String>("segments"){
					$0.options = ["View"]
					$0.value = "View"
					$0.hidden = true
			}
			isNew = true
			isEdit = true
			reminder = Medication_Reminders()
			reminder!.id = globalData().getUUID()
		}
		
		form +++ Section()
			<<< TextFloatLabelRow("reminder_name") {
				$0.value = self.reminder!.name
				$0.title = "Reminder Name"
				$0.disabled = "$segments = 'Edit'"
			}

			<<< DateRow( "reminder_time") {
				$0.title =  "Reminder Time"
				$0.value = self.reminder!.reminder_time
				$0.disabled = "$segments = 'Edit'"
			}
			<<< TextFloatLabelRow("recurrence") {
				$0.value = self.reminder!.recurrence
				$0.title = "Recurrence"
				$0.disabled = "$segments = 'Edit'"
			}
			<<< TextFloatLabelRow("send_reminders_to") {
				$0.title =  "Send Reminders To"
				$0.value = self.reminder!.send_reminders_to
				$0.disabled = "$segments = 'Edit'"
			}
			<<< TextFloatLabelRow("send_text_message") {
				$0.title =  "Send Text Message"
				$0.value = self.reminder!.send_text_message
				$0.disabled = "$segments = 'Edit'"
			}
			
			+++ Section()
			<<< ButtonRow("submit") {
				$0.title="Submit"
				}.onCellSelection({ [weak self] (row,cell) in
					self!.updateReminders()
					})
			<<< ButtonRow("delete") {
				$0.title="Delete"
				}.onCellSelection({ [weak self] (row,cell) in
					self?.deleteReminders()
					})
}
	
	
	private func updateReminders() {
		let values = form.values()
		
		switch Medication_Reminders.instance(values) {
		case .Error(let field,let message):
			notification_top.showNotification(field, body: message, onTap: { (Void) in
			})
		case .Ok(let reminder):
			try! currentRealm().write({
				self.reminder!.copyfrom(reminder)
				currentRealm().add(self.reminder!, update: true)
				if (isNew) {
					patient_medication.reminders.append(self.reminder!)
				}
			})
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	private func deleteReminders() {
		try! currentRealm().write({
            currentRealm().delete(self.reminder!)			
		})
		self.navigationController?.popViewControllerAnimated(true)
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
