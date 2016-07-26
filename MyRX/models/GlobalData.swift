//
//  GlobalData.swift
//  MyRX
//
//  Created by yaowei on 16/7/26.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import Alamofire

class MDIDRange : Object {
    dynamic var table = ""
    dynamic var start01 = 0
    dynamic var end01 = 0
    dynamic var start02 = 0
    dynamic var end02 = 0
    
    func getID() -> Int {
        var ret = -1
        if self.end01 > self.start01 {
            ret = self.start01
            self.start01 += 1
        } else {
            self.start01 = self.start02
            self.end01 = self.end02
            if self.end01 > self.start01 {
                ret = self.start01
                self.start01 += 1
            }
        }
        self.apply()
        return ret
    }
    func apply() {
        guard end02 <= start02 else {
            return
        }
        applyIDs(self.table).responseJSON { [ weak self ] (response:Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let value):
                self?.addRange(value["start"] as! Int,end:value["end"] as! Int)
                break
            case .Failure(let error):
                print(error)
            }
        }
    }
    func addRange(start:Int,end:Int) {
        if end01 <= start01 {
            (start01,end01) = (start,end)
            (start02,end02) = (0,0)
        } else {
            (start02,end02) = (start,end)
        }
    }
}
class GlobalData : Object {
    dynamic var immunizationIDs:MDIDRange!
    dynamic var immunizationReminderIDs : MDIDRange!
    class func create() ->GlobalData {
        let data = GlobalData(value: [
            "immunizationIDs" : [ "table" : "immunization" ],
            "immunizationReminderIDs" : [ "table" : "immunizationReminder" ]
            ])
        data.immunizationIDs.apply()
        data.immunizationReminderIDs.apply()
        return data
    }
}