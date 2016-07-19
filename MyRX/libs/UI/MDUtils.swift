//
//  MDUtils.swift
//  MyRX
//
//  Created by yaowei on 16/7/14.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation

func + <K, V>(lhs: [K : V]?, rhs: [K : V]?) -> [K : V]? {
    if let lhs = lhs {
        if let rhs = rhs {
            var combined = lhs
            
            for (k, v) in rhs {
                combined[k] = v
            }
            
            return combined
            
        }
        return lhs
    }
    return rhs
}

