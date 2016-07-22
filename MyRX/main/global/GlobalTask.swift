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

let TASKS = [
    // update Immunization
    {
        let account = currentAccount()
        guard account.islogin else {
            return
        }
        getImmunization().responseObject { (response:Response<PackImmunization, NSError>) in
            switch(response.result) {
            case .Success(let value):
                print(value)
                try! currentRealm().write {
                    value.immunizations?.forEach{
                        currentRealm().add($0)
                    }
                }
                break
            case .Failure(let error):
                print(error)
            }
        }
    },
    {
        
    }
]