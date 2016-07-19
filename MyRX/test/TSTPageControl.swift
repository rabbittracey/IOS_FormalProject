//
//  TSTPageControl.swift
//  MyRX
//
//  Created by EagleForce on 16/3/16.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class TSTPageControl: UIPageControl {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect:rect.center.asCenter(5, 5))
        currentPageIndicatorTintColor?.setStroke()
        path.stroke()
    }

}
