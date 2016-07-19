//
//  MDSwipeImageView.swift
//  MyRX
//
//  Created by EagleForce on 16/3/24.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class MDSwipeImageView: UIImageView {
    @IBInspectable var secondImage:UIImage?
    @IBInspectable var value:Bool = false {
        didSet {
            if ( oldValue == value ) {
                return
            }
            let _tmp = self.image
            self.image = secondImage
            secondImage = _tmp
            UIView.beginAnimations("MDSwipeImageView", context: nil)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationRepeatAutoreverses(false)
            UIView.setAnimationCurve(.EaseInOut)
            UIView.setAnimationTransition(value ? .FlipFromLeft : .FlipFromRight , forView: self, cache: true)
            UIView.commitAnimations()
        }
    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        value = !value
//    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
