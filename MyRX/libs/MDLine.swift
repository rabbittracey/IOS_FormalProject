//
//  MDLine.swift
//  MyRX
//
//  Created by EagleForce on 16/2/26.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class MDLine: UIView {
    @IBInspectable  var lineColor:UIColor = UIColor.blackColor()
//    @IBInspectable  var backLineColor:UIColor = UIColor(white: 231.0/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    override func drawRect(rect: CGRect) {
        // 1
        let currentContext = UIGraphicsGetCurrentContext()
        
        // 2
        CGContextSaveGState(currentContext);
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let startColorComponents = CGColorGetComponents(lineColor.CGColor)
        let endColorComponents = CGColorGetComponents(lineColor.colorWithAlphaComponent(0).CGColor)
        
        // 5
        var colorComponents
        = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        
        // 6
        var locations:[CGFloat] = [0.0, 1.0]
        
        // 7
        let gradient = CGGradientCreateWithColorComponents(colorSpace,&colorComponents,&locations,2)
        
        let startPoint = CGPointMake(bounds.width/2,0)
        let endPoint = CGPointMake(bounds.width/2, self.bounds.height)
        
        // 8
        CGContextDrawLinearGradient(currentContext,gradient,startPoint,endPoint, .DrawsBeforeStartLocation)
        
        // 9
        CGContextRestoreGState(currentContext);
    }
}
