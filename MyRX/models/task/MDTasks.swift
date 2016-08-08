//
//  MDTasks.swift
//  MyRX
//
//  Created by yaowei on 16/7/23.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import Realm
import RealmSwift

class MDTask {
    let interval : NSTimeInterval
    var elapsed : NSTimeInterval
    let process : (MDTask) -> Void
    let name : String
    init(_ interval:NSTimeInterval,name:String="Task",process : (MDTask)->Void) {
        self.interval = interval
        self.elapsed = 0.0
        self.process = process
        self.name = name
    }
    
    final func run(dt:NSTimeInterval) {
        elapsed += dt
        if elapsed >= interval - 0.1 {
            process(self)
            elapsed = 0
        }
    }
    final func immediately() {
        elapsed = interval
    }
}

class GlobalTaskQueue {
    let interval:NSTimeInterval
    var timer : NSTimer?
    var last:NSDate
    
    init(tasks : [MDTask],interval:NSTimeInterval = 5 ) {
        self.interval = interval
        self.last = NSDate() //.timeIntervalSince1970
    }
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(self.interval, target: self, selector: #selector(GlobalTaskQueue.run), userInfo: nil, repeats: true)
    }
    func resume() {
        timer?.invalidate()
        self.start()
    }
    func pause() {
        timer?.invalidate()
        timer = nil
    }
    func stop() {
        pause()
    }
    @objc func run() {
        let _last = NSDate()
        let dt = _last.timeIntervalSinceDate(self.last)
        TASKS.forEach { [dt] (task:MDTask)-> Void in
            task.run(dt)
        }
        self.last = _last
    }
}
extension NSNumber : MinMaxType {}

class SynModel<T:MDObject where T : MDMappable> {
    var updates : [T]!
    let batch_no : Int
    
    init() {
        batch_no = globalData().getBatchNo()
    }
    func loadUpdates() {
        // load update date
        
        // update this data batch no
        if updates.count > 0 {
            try! currentRealm().write({
                updates.forEach { (data) in
                    data.batch_id = self.batch_no
                }
            })
        }
    }
    func loadData() {
        let maxversion = ( currentRealm().objects(T).max("version") as NSNumber? )?.longLongValue ?? -1
        getDatas(updates,version:maxversion+1).responseObject { (response : Response<T, NSError>) in
            switch(response.result) {
            case .Success(let value):
                print(value)
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func start() {
        loadUpdates()
        loadData()
    }
}

let TASKS = [
    // syncrony immunization for server
    MDTask(10.seconds) { (task) in
        let account = currentAccount()
        guard account.islogin else {
            return
        }
        // Patient_Medication
        SynModel<Patient_Medication>().start()
//        let tables = [Patient_Medication.self,Medication_reminder.self]
//        
//        tables.foreach {
//            getDatas<$0>.responseObject { ( response:Response<Pack<$0>,NSError> ) in
//                
//            }
//        }
//        let maxversion = ( currentRealm().objects(Patient_Immunization.self).max("version") as NSNumber? )?.longLongValue ?? -1
//        
//        getImmunization(maxversion + 1).responseObject { (response:Response<PackImmunization, NSError>) in
//            switch(response.result) {
//            case .Success(let value):
//                try! currentRealm().write {
//                    value.immunizations?.forEach{
//                        currentRealm().add($0,update:true)
//                    }
//                }
//                break
//            case .Failure(let error):
//                print(error)
//            }
//        }
        
    },
]

