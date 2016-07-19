//
//  MDThread.swift
//  MyRX
//
//  Created by yaowei on 16/7/11.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation

/// Return a thread-local object, creating it if it has not already been created
///
/// :param: create closure that will be invoked to create the object
/// :returns: object of type T
public func cachedThreadLocalObjectWithKey<T: AnyObject>(key: String, create: () -> T) -> T {
    let threadDictionary = NSThread.currentThread().threadDictionary
    if let cachedObject = threadDictionary[key] as! T? {
        return cachedObject
    }
    else {
        let newObject = create()
        threadDictionary[key] = newObject
        return newObject
    }
}
