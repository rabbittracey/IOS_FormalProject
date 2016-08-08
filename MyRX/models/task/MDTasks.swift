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
    
    init(tasks : [MDTask],interval:NSTimeInterval = 5.seconds ) {
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

func loadData<T:MDObject where T : MDMappable>() {
	let maxversion = ( currentRealm().objects(T).max("version") as NSNumber? )?.longLongValue ?? -1
	var updates : [T] = []
	print(T.self.className())
	getDatas(updates,version: maxversion+1).respnoseObject { (response:Response<PackDatas<Patient_Immunization>,NSError>) in
		switch(response.result) {
		case .Success(let value):
			print(value)
		case .Failure(let error):
			print(error)
		}
	}
	
}
let TASKS = [
    // syncrony immunization for server
    MDTask(10.seconds) { (task) in
        let account = currentAccount()
        guard account.islogin else {
            return
        }
		let models:[Object.Type] = [ Patient_Immunization.self , Patient_Medication.self]
		models.forEach
			{  Model in
				
			let maxversion = ( currentRealm().objects(Model).max("version") as NSNumber? )?.longLongValue ?? -1
			var updates : [models.Type] = []
			// initial updates
			getDatas(updates,maxversion+1).respnoseObject { (response:Response<PackDatas<Patient_Immunization>,NSError>) in
				switch(response.result)
				{
				case .Success(let value):
					try! currentRealm().write
					 {
						value.immunizations?.forEach
							{
							currentRealm().add($0,update:true)
						    }
					  }
					break
				case .Failure(let error):
					print(error)
				}
			 }
		   }
	}
]

