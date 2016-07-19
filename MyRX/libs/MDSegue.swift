//
//  MDSegue.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MDSegue01: UIStoryboardSegue {
    var duration:Double = 0.5
    var curve:Int = 0
    var transition:Int = 1
    var backToRoot:Bool = false
    let window = UIApplication.sharedApplication().keyWindow!
    
    override func perform() {
        if let navi = sourceViewController.navigationController {
            if backToRoot {
                navi.popToRootViewControllerAnimated(false)
            }
            navi.pushViewController(destinationViewController, animated: false)
        } else {
            sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
        }
        UIView.beginAnimations("MDSegue01", context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationRepeatAutoreverses(false)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:curve)!)
        UIView.setAnimationTransition(UIViewAnimationTransition(rawValue: transition)! , forView: window, cache: true)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector(#selector(MDSegue01.segueDidStop(_:)))
        UIView.commitAnimations()
    }
    func segueDidStop(sender:AnyObject) {
        
    }
    func goback(sender:AnyObject) {
        UIView.beginAnimations("MDNavigationBack", context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationRepeatAutoreverses(false)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:0)!)
        UIView.setAnimationTransition(UIViewAnimationTransition(rawValue: 1)! , forView: window, cache: true)
        UIView.commitAnimations()
        sourceViewController.navigationController?.popViewControllerAnimated(false)
    }
}