//
//  GlobalTask.swift
//  MyRX
//
//  Created by yaowei on 16/7/21.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
infix operator ~> {}

func ~> <R> (
    backgroundClosure: () -> R,
    mainClosure:       (result: R) -> ())
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), {
            mainClosure(result: result)
        })
    }
}

private class NSTimerActor {
    var block: () -> ()
    
    init(block: () -> ()) {
        self.block = block
    }
    
    dynamic func fire() {
        block()
    }
}

extension NSTimer {
    convenience init(_ intervalFromNow: NSTimeInterval, block: () -> ()) {
        let actor = NSTimerActor(block: block)
        self.init(timeInterval: intervalFromNow, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: false)
    }
    
    convenience init(every interval: NSTimeInterval, block: () -> ()) {
        let actor = NSTimerActor(block: block)
        self.init(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: true)
    }
    
    class func schedule(intervalFromNow: NSTimeInterval, block: () -> ()) -> NSTimer {
        let timer = NSTimer(intervalFromNow, block: block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
    
    class func schedule(every interval: NSTimeInterval, block: () -> ()) -> NSTimer {
        let timer = NSTimer(every: interval, block: block)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
}

let TASKS = [
    // update Immunization
    {
        let account = currentAccount()
        guard account.islogin else {
            return
        }
        getImmunization().responseArray(completionHandler: { (response:Response<[Immunization],NSError>) in
            switch response.result {
            case .Failure:
                notification_top.showNotification("System Error", body: "Please check your network,and try it again", onTap: nil)
            case .Success(let results):
                notification_top.showNotification("Test", body: "\(results.count)", onTap: nil)
                break
            }
        })
    },
    {
        
    }
]