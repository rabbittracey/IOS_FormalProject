//
//  MDTasks.swift
//  MyRX
//
//  Created by yaowei on 16/7/23.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation


class MDTask {
    var inter : NSTimeInterval
    var remainder : NSTimeInterval
    
    init(inter:NSTimeInterval) {
        self.inter = inter
        self.remainder = inter
    }
    
    final func run() {
        
    }
}

protocol Runnable {
    func process()
}

extension Runnable where Self : MDTask {
    final func run(dt:NSTimeInterval) {
        remainder -= dt
        if remainder <= 0 {
            process()
            remainder = inter
        }
    }
}
