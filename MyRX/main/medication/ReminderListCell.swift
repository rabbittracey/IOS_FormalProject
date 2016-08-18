//
//  ReminderListCell.swift
//  MyRX
//
//  Created by Ji Wang on 8/2/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit

class ReminderListCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	
	func updateUI(medication_reminder:Medication_Reminders) {
		nameLabel.text = "Reminder Name: "+medication_reminder.name
		
	}
	
}
