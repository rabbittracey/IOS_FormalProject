//
//  AppDatas.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper


let HOUR_NAMES:[String] = ["1","2","3","4","5","6","7","8","9","10","11","12"]
let MINUTE_NAMES:[String] = ["00","10","20","30","40","50"]
let FREQUENCY_PICKER_DATASOURCE: [[String]] = [
    ["1","2","3","4","5","6"] ,
    FUNIT.DESCRIPTIONS
]

let WEEKLY_PICKER_DATASOURCE: [[String]] = [
    WeekDay.DESCS ,
    HOUR_NAMES,
    MINUTE_NAMES,
    APM.DESCRIPTIONS
]

let DAYLY_PICKER_DATASOURCE: [[String]] = [
    HOUR_NAMES,
    MINUTE_NAMES,
    APM.DESCRIPTIONS
]

let DRUG_UNIT = ( "tablet","tablets" )

// Reminds
let DailyReminder = [ 13 , 17 , 10 , 20 , 7 ,23 ]
let WeeklyReminder = [ 0 , 3 , 5 , 2 , 6 , 1 ]

let SERVER_URL="http://10.0.80.98:8080"

let COLORS = [
    UIColor(red: 95.0/255, green: 231.0/255, blue: 237.0/255, alpha: 1)
]

enum Gender : String {
    case Male , Female, Other
}

var TOKEN = "qqqqqq" //"7fa8a808-70a9-4f1d-9191-31ec856be0de"

let SERVERURL="http://10.0.80.184:3004"

let GENDER_ADAPT = [
    "M" : "Male",
    "F" : "Female",
    "U" : "Other"
]

let DATEFORMAT = "yyyy-MM-dd".dateFormatter()
let DATETIMEFORMAT = "yyyy-MM-dd HH:mm:ss".dateFormatter()
let TIMEFORMAT = "HH:mm:ss".dateFormatter()

