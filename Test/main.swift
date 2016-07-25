//
//  main.swift
//  Test
//
//  Created by yaowei on 16/7/19.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation

class A {
    func vv() {
        print("A")
    }
}

protocol B{
    func jjj()
}

extension B where Self : A {
    func vvv() {
        jjj()
        print("B")
    }
}

class C : A , B {
    func jjj() {
        print("C")
    }
}

C().vvv()