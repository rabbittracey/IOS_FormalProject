//
//  GlobalUI.swift
//  MyRX
//
//  Created by yaowei on 16/7/11.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import LNRSimpleNotifications
import AudioToolbox

let notification_top:LNRNotificationManager = {
    let noti = LNRNotificationManager()
    noti.notificationsPosition = LNRNotificationPosition.Top
    noti.notificationsBackgroundColor = UIColor.whiteColor()
    noti.notificationsTitleTextColor = UIColor.blackColor()
    noti.notificationsBodyTextColor = UIColor.darkGrayColor()
    noti.notificationsSeperatorColor = UIColor.grayColor()
    
    let alertSoundURL: NSURL? = NSBundle.mainBundle().URLForResource("click", withExtension: "wav")
    if let _ = alertSoundURL {
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(alertSoundURL!, &mySound)
        noti.notificationSound = mySound
    }
    
    return noti
}()
