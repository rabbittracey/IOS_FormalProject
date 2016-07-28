//
//  ForTest.swift
//  MyRX
//
//  Created by Ji Wang on 7/25/16.
//  Copyright © 2016 EagleForce. All rights reserved.
//

import Foundation

var ids : Int64 = 50000
func getID() -> Int64 {
    ids += 1
    return ids
}