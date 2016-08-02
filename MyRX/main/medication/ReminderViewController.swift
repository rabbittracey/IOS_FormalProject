//
//  ReminderViewController.swift
//  MyRX
//
//  Created by Ji Wang on 8/2/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire
import Foundation

class ReminderViewController: BaseTableViewController {
	var patient_medication :Patient_Medication!
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.patient_medication.reminders
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MedicationListCell",forIndexPath: indexPath) as! MedicationListCell
		cell.updateUI(self.results[indexPath.row])
		//        cell.textLabel?.text = self.results[indexPath.row].name
		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("MedicationDetailSegue", sender: self.results[indexPath.row])
	}
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 120
	}
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		let patient_medication = (sender as? Patient_Medication) ?? Patient_Medication()
		if let destine = segue.destinationViewController as? MedicationDetailViewController {
		 destine.patient_medication = patient_medication
		}
	}
	
	
}