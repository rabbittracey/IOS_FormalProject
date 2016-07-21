//
//  main.swift
//  Test
//
//  Created by yaowei on 16/7/19.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation

enum A<Value> {
    case Test(Value)
}

let vv = A.Test((10,"1"))
