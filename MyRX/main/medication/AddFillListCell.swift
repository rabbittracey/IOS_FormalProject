//
//  AddFillListCell.swift
//  MyRX
//
//  Created by Ji Wang on 8/2/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit

class AddFillListCell: UITableViewCell {
	
	
	
	@IBOutlet weak var nameLabel: UILabel!
	func updateUI(medication_add_fill:Medication_Add_Fill) {
		let formatter = NSDateFormatter()
		formatter.dateStyle = NSDateFormatterStyle.ShortStyle
		formatter.timeStyle = .ShortStyle		
		let dateString = formatter.stringFromDate(medication_add_fill.date_filled)
		nameLabel.text = "Date Filled: "+dateString
		
	}
	
}
