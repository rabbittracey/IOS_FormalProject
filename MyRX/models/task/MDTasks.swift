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
        if elapsed >= interval {
            process(self)
            elapsed = 0
        }
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


var Immunization_Version = -1

let TASKS = [
    // syncrony immunization for server
    MDTask(60.seconds) { (task) in
        let account = currentAccount()
        guard account.islogin else {
            return
        }
        getImmunization(Immunization_Version + 1).responseObject { (response:Response<PackImmunization, NSError>) in
            switch(response.result) {
            case .Success(let value):
                Immunization_Version = value.version
                try! currentRealm().write {
                    value.immunizations?.forEach{
                        currentRealm().add($0,update:true)
                    }
                }
                break
            case .Failure(let error):
                print(error)
            }
        }
    },
]