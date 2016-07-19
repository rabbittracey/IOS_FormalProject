//
//  MyRxTableViewCell.swift
//  rx
//
//  Created by EagleForce on 16/2/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MyRxTableViewCell: UITableViewCell {
    @IBOutlet weak var drugImageView:UIImageView!
    @IBOutlet weak var drugNameLabel:UILabel!
    @IBOutlet weak var drugRemainingLabel: UILabel!
    
    @IBOutlet weak var lifetimePercentView: MDPercentView!
    @IBOutlet weak var lifetimeLabel: UILabel!
    
    @IBOutlet weak var communityPercentView: MDPercentView!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var CommunityPercentViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var currentMonthPercentView: MDPercentView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var currentMonthPercentViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bestMonthPercentView: MDPercentView!
    @IBOutlet weak var bestMonthLabel: UILabel!
    @IBOutlet weak var bestMonthPercentViewConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     }
    func updateWithData(reminder:Reminder!) {
        drugImageView.layer.cornerRadius = 8
        drugImageView.layer.masksToBounds = true
        if reminder.image != nil {
            drugImageView.image = reminder.image
        }
        drugNameLabel.text = reminder.drugName
        drugRemainingLabel.text = "\(reminder.quantity) \(reminder.quantity > 1 ? DRUG_UNIT.1 : DRUG_UNIT.0) remaining"
        
        // percentView
        lifetimePercentView.count = 100.random
        communityPercentView.count = 100.random
        currentMonthPercentView.count = 100.random
        let c = (frame.size.width - 225 ) / 3
        
        CommunityPercentViewConstraint.constant = c
        currentMonthPercentViewConstraint.constant = c
        bestMonthPercentViewConstraint.constant = c
        setNeedsUpdateConstraints()
        
        let nf = NSDateFormatter()
        nf.dateFormat = "MMM"
        
        currentMonthLabel.text = nf.stringFromDate(NSDate())
    }
}
