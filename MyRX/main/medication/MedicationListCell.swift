//
//  MedicationListTableViewCell.swift
//  MyRX
//
//  Created by Ji Wang on 7/28/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit

class MedicationListCell: UITableViewCell {

	@IBOutlet var nameLabel : UILabel!
	
	func updateUI(patient_medication:Patient_Medication) {
	nameLabel.text = "Name: "+patient_medication.name
		
	}

}
