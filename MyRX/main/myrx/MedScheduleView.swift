//
//  MedScheduleView.swift
//  MyRX
//
//  Created by EagleForce on 16/4/14.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MedScheduleView: UIView,UITableViewDataSource {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var abstract: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    weak var reminder : Reminder?
    let formatter = NSDateFormatter()
    func initWithReminder(reminder:Reminder) {
        self.reminder = reminder
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        title.text = "First on \(formatter.stringFromDate(reminder.schedules[0]))"
//        reminder.
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminder?.tooks.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mschedule-cell")
        let label = cell?.viewWithTag(50) as! UILabel
        let icon = cell?.viewWithTag(51) as! UIImageView
        let date = reminder!.schedules[indexPath.row]
        
        label.text = "\(formatter.stringFromDate(date))"
        if date.compare(NSDate()) == .OrderedDescending {
            icon.image = UIImage.init(imageLiteral: "under-icon")
        } else {
            if ( reminder!.tooks[date]! ) {
                icon.image = UIImage.init(imageLiteral: "took-icon")
            } else {
                icon.image = UIImage.init(imageLiteral: "miss-icon")
            }
        }
        return cell!
    }

}
