//
//  ReminderViewController.swift
//  MyRX
//
//  Created by Ji Wang on 8/2/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//
//add some comments
import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire
import Foundation

class RemindersViewController: BaseTableViewController {
	var patient_medication :Patient_Medication!
	
	@IBAction func onAddNew(sender: AnyObject){
		self.performSegueWithIdentifier("ReminderDetailSegue", sender: nil)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.patient_medication.reminders.count
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("ReminderListCell",forIndexPath: indexPath) as! ReminderListCell
		cell.updateUI(patient_medication.reminders[indexPath.row])
		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("ReminderDetailSegue", sender: patient_medication.reminders[indexPath.row])
	}
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 120
	}
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		
		if let destine = segue.destinationViewController as? ReminderDetailViewController {
		 destine.patient_medication = patient_medication
		 destine.reminder = sender as? Medication_Reminder
		}
	}
	
	
}