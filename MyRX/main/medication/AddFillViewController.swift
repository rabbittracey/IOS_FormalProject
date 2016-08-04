//
//  AddFillViewController.swift
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

class  AddFillViewController: BaseTableViewController {
	var patient_medication :Patient_Medication!
	@IBAction func onAddNew(sender:AnyObject){
		self.performSegueWithIdentifier("FillDetailSegue",sender: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.patient_medication.fills.count
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("AddFillListCell",forIndexPath: indexPath) as! AddFillListCell
		cell.updateUI(patient_medication.fills[indexPath.row])
		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.performSegueWithIdentifier("FillDetailSegue", sender: patient_medication.fills[indexPath.row])
	}
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 120
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
	
		if let destine = segue.destinationViewController as? FillDetailViewController {
		 destine.patient_medication = patient_medication
		 destine.fill = sender as? Medication_Add_Fill
		}
	}
	
}






