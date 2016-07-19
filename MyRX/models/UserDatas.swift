//
//  UserDatas.swift
//  MyRX
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class Reminder : NSObject,NSCoding {
    let drugName:String
    var image:UIImage?
    let start:NSDate
    let quantity:Int
    let dose:Int
    let reminders : [ReminderItemModel]
    
    var tooks : [NSDate:Bool] = [:]
    var schedules : [NSDate] = []
    
    init(drugName:String,quantity:Int , dose:Int , reminders:[ReminderItemModel] , start:NSDate = NSDate() ) {
        self.drugName = drugName
        self.quantity = quantity
        self.dose = dose
        self.reminders = reminders.sort({ (first, second) -> Bool in
            return first.count < second.count
        })
        self.start = start
        super.init()
        
        let gen = self.generate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm:ss a"
        while let date = gen.next() {
            tooks[date] = false
            schedules.append(date)
            print(formatter.stringFromDate(date))
            
        }
        print(tooks.count)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(drugName , forKey: "drugName")
        aCoder.encodeObject(start, forKey: "start")
        if let img = image {
            aCoder.encodeObject(UIImagePNGRepresentation(img), forKey: "image")
        }
        aCoder.encodeObject(quantity, forKey: "quantity")
        aCoder.encodeObject(dose, forKey: "dose")
        aCoder.encodeObject(reminders.map { $0.count }, forKey: "reminders")
        aCoder.encodeObject(tooks, forKey:"tooks")
    }
    required init?(coder aDecoder: NSCoder) {
        drugName = aDecoder.decodeObjectForKey("drugName") as! String
        if let imgData = aDecoder.decodeObjectForKey("image") as? NSData {
            image = UIImage(data: imgData)
        }
        start = aDecoder.decodeObjectForKey("start") as! NSDate
        quantity = aDecoder.decodeObjectForKey("quantity") as! Int
        dose = aDecoder.decodeObjectForKey("dose") as! Int
        reminders = (aDecoder.decodeObjectForKey("reminders") as! [Int]).map { ReminderItemModel.instance($0) }
        tooks = aDecoder.decodeObjectForKey("tooks") as! [NSDate:Bool]
        schedules = tooks.keys.sort({ (d1:NSDate, d2:NSDate) -> Bool in
            d1.compare(d2) == .OrderedAscending
        })
    }
    
    func generate() -> ReminderGenerator {
        return ReminderGenerator(quantity: quantity, dose: dose, start: start, reminders: reminders)
    }
}

class User : NSObject,NSCoding {
    static let KEY = "USER"
    let uuid:String
    var reminders : [ Reminder ]
    var objVersion = 0
    override init() {
        uuid=NSUUID().UUIDString
        reminders = []
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(uuid, forKey: "uuid")
        aCoder.encodeObject(reminders, forKey: "reminders")
    }
    required init?(coder aDecoder: NSCoder) {
        uuid = aDecoder.decodeObjectForKey("uuid") as! String
        reminders = aDecoder.decodeObjectForKey("reminders") as! [Reminder]
    }
    
    static let current:User = {
        if let userData = NSUserDefaults.standardUserDefaults().objectForKey(User.KEY) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(userData) as! User
        }
        let user = User()
        
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: User.KEY)
        return user
    }()
    
    static func save() {
        current.objVersion += 1
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(current), forKey: User.KEY)
    }
    
    func isLogin() -> Bool {
        return true
    }
}
