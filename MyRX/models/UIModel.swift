//
//  UIModel.swift
//  rx
//
//  Created by EagleForce on 16/2/9.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation

class ScheduleItemModel {
    let title : String
    var count : Int = 0
    
    init(title:String,count:Int) {
        self.title = title
        self.count = count
    }
    convenience init(title:String) {
        self.init(title:title,count:0)
    }
    init(title:String,values:[Int]) {
        self.title = title
        self.values = values
    }
    func toString() ->String {
        return "\(count)"
    }
    var type:String {
        return "normal"
    }
    var values:[Int] {
        get {
            return [count]
        }
        set {
            count = newValue[0]
        }
    }
}
class NumberItemModel : ScheduleItemModel {
    var unit : (String,String)!
    convenience init(title: String,count:Int, unit: (String,String)) {
        self.init(title: title, count: count)
        self.unit = unit
    }
    override var type:String {
        return "number"
    }
    override func toString() -> String {
        return "\(count) \(count>1 ? unit.1 : unit.0)"
    }
}
class PickerItemModel : ScheduleItemModel {
    var datasource:[[String]] {
        get {
            fatalError("Datasource has not been implemented")
        }
    }
    override var type:String {
        return "picker"
    }
}
class FrequencyItemModel : PickerItemModel {
    convenience init(times:Int , funit:FUNIT) {
        self.init(title: "Frequency",values:[times-1,funit.rawValue])
    }
    convenience init(count:Int) {
        self.init(title:"Frequency",count:count)
    }
    override var datasource: [[String]] {
        get {
            return FREQUENCY_PICKER_DATASOURCE
        }
    }
    override var values:[Int] {
        get {
            return [ count & 0xF, count > 0xF ? 1 : 0 ]
        }
        set {
            count = newValue[0] + (newValue[1] > 0 ? 0x10 : 0)
        }
    }
    override func toString() -> String {
        var txt = ""
        switch count & 0xF {
        case 0:
            txt = "once"
        case 1:
            txt = "twice"
        default:
            txt = "\(count & 0xF + 1) times"
        }
        return "\(txt) per \( count > 0xF ? "week" : "day")"
    }
    func isWeekly() -> Bool {
        return FrequencyItemModel.isWeekly(count)
    }
    static func isWeekly(value:Int) -> Bool {
        return value > 0xF
    }
    
}

class ReminderItemModel : PickerItemModel {
    override var values:[Int] {
        get {
            //hours                        minute                   APM
            var ret:[Int] = [ min(11,(count & 0x78) >> 3) , min(5,(count & 0x7)) , (count & 0x80) >> 7 ]
            //per week
            if count & 0x700 != 0x700 {
                ret.insert(((count & 0x700)>>8), atIndex: 0)
            }
            return ret
        }
        set {
            var index = 0
            count = 0x700
            if newValue.count > 3 {
                count = newValue[0] << 8
                index += 1
            }
            count += (min(1,newValue[index+2]) << 7 )
            count += (min(11,newValue[index]) << 3)
            count += min(5,newValue[index+1])
            
        }
    }
    convenience init(count: Int) {
        self.init(title:"Reminder",count:count)
    }
    convenience init(values:[Int]) {
        self.init(title:"Reminder",values: values)
    }
    class func instance(count:Int) -> ReminderItemModel {
        return ( count & 0x700  != 0x700 ) ? WeeklyReminderItemModel(count: count) : DailyReminderItemModel(count:count)
    }
    func nextDate(from:NSDate) -> NSDate {
        fatalError("NextDate has not been implemented")
    }
}
class DailyReminderItemModel : ReminderItemModel {
    override var datasource:[[String]] {
        get {
            return DAYLY_PICKER_DATASOURCE
        }
    }
    convenience init?(hour:Int,tenMinute:Int,apm:APM) {
        guard hour >= 1 && hour <= 12 && tenMinute <= 5 && tenMinute >= 0 else {
            return nil
        }
        self.init(values: [hour-1,tenMinute,apm.rawValue])
    }
    override func toString() -> String {
        var vs = values
        return "\(HOUR_NAMES[vs[0]]):\(MINUTE_NAMES[vs[1]]) \(APM.DESCRIPTIONS[vs[2]])"
    }
    override func nextDate(from: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components([.Year,.Month,.Day], fromDate: from)
        var vs = values
        comp.hour = (vs[0]+1).apm(APM(rawValue: vs[2])!)
        comp.minute = vs[1] * 10
        let date = cal.dateFromComponents(comp)!
        if from.compare(date) == .OrderedAscending {
            return date
        }
        return date.dateByAddingTimeInterval(24*3600)
    }
}
class WeeklyReminderItemModel : ReminderItemModel {
    override var datasource:[[String]] {
        get {
            return WEEKLY_PICKER_DATASOURCE
        }
    }
    convenience init?(weekday:WeekDay , hour:Int,tenMinute:Int,apm:APM) {
        guard weekday != WeekDay.Not && hour >= 1 && hour <= 12 && tenMinute <= 5 && tenMinute >= 0 else {
            return nil
        }
        self.init(values: [weekday.rawValue,hour,tenMinute,apm.rawValue])
    }
    override func toString() -> String {
        var vs = values
        return "\(WeekDay.DESCS[vs[0]]) \(HOUR_NAMES[vs[1]]):\(MINUTE_NAMES[vs[2]]) \(APM.DESCRIPTIONS[vs[3]])"
    }
    override func nextDate(from: NSDate) -> NSDate {
        let cal = NSCalendar.currentCalendar()
        let comp = cal.components([.YearForWeekOfYear,.WeekOfYear], fromDate: from)
        var vs = values
        comp.weekday = vs[0] + 1
        comp.hour = (vs[1]+1).apm(APM(rawValue: vs[3])!)
        comp.minute = vs[2] * 10
        let date = cal.dateFromComponents(comp)!
        if from.compare(date) == .OrderedAscending {
            return date
        }
        return cal.dateByAddingUnit(.WeekOfYear, value: 1, toDate: date, options: .MatchNextTime)!
    }
}
class ReminderGenerator : GeneratorType {
    let reminders : [ReminderItemModel]
    var current : NSDate
    var rindex : Int
    var quantity : Int
    let dose : Int
    init(quantity:Int , dose:Int , start:NSDate , reminders:[ReminderItemModel]) {
        self.quantity = quantity
        self.dose = dose
        self.reminders = reminders.sort { return $0.count < $1.count }
        self.current = self.reminders[0].nextDate(start)
        rindex = 0
        for index in 1.stride(to: reminders.count, by: 1) {
            let _current = self.reminders[index].nextDate(start)
            if self.current.compare(_current) == .OrderedDescending {
                self.current = _current
                self.rindex = index
                break
            }
        }
    }
    func next() -> NSDate? {
        if quantity > 0 {
            quantity -= dose
            let result = current
            rindex = ( rindex + 1 ) % self.reminders.count
            current = self.reminders[rindex].nextDate(current)
            return result
        }
        return nil
    }
}
//class WeeklyReminderItemModel : ReminderItemModel {
//    init?(weekday:WeekDay,hour:Int,tenMinute:Int,apm:APM) {
//        super.init(title: "Reminder", datasource: weekday == .Not ? DAYLY_PICKER_DATASOURCE : WEEKLY_PICKER_DATASOURCE)
//        if hour < 1 || hour > 12 || tenMinute > 5 || tenMinute < 0 {
//            return nil
//        }
//        self.values = [ weekday.rawValue , hour-1 , tenMinute ,apm.rawValue]
//    }
//    convenience init?(hour:Int,tenMinute:Int,apm:APM) {
//        self.init(weekday:.Not,hour:hour,tenMinute:tenMinute,apm:apm)
//    }
//    init(count:Int) {
//        super.init(title: "Reminder", datasource: ReminderItemModel.isWeekly(count) ? WEEKLY_PICKER_DATASOURCE : DAYLY_PICKER_DATASOURCE)
//        self.count = count
//    }
//    override func toString() -> String {
//        var vs = values
//        var ret:String = ""
//        if vs.count > 3 {
//            ret = WeekDay.DESCS[vs[0]]
//            vs.removeFirst()
//        }
//        ret = ret + " \(HOUR_NAMES[vs[0]]):\(MINUTE_NAMES[vs[1]]) \(APM.DESCRIPTIONS[vs[2]])"
//        return ret
//    }
//    func isWeekly() -> Bool {
//        return ReminderItemModel.isWeekly(count)
//    }
//    static func isWeekly(value:Int) -> Bool {
//        return value & 0x700 != 0x700
//    }
//    
//    var weekDay:WeekDay {
//        return WeekDay(rawValue:(count & 0x700)>>8)!
//    }
//    
//    func nextDate(after:NSDate) -> NSDate {
//        let cal=NSCalendar.currentCalendar()
//        let comp
//    }
//}