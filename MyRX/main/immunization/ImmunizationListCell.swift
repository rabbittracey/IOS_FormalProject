//
//  ImmunizationListCell.swift
//  MyRX
//
//  Created by Ji Wang on 7/26/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import UIKit

class ImmunizationListCell: UITableViewCell {
	
	
	@IBOutlet weak var Date: UILabel!
	@IBOutlet weak var Name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func updateUI(immunization:Patient_Immunizations) {
		Name.text = "Name: "+immunization.name
		let formatter = NSDateFormatter()
		formatter.dateStyle = NSDateFormatterStyle.ShortStyle
		formatter.timeStyle = .ShortStyle
		
		let dateString = formatter.stringFromDate(immunization.date_administered)
		    Date.text = "Administrated Date: "+dateString
    }
}
