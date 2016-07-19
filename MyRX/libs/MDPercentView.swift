//
//  MDPercentView.swift
//  rx
//
//  Created by EagleForce on 16/2/12.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class MDPercentView: UIView {
    @IBInspectable var count : Int = 10
    private var showCount : Int = 10
    @IBInspectable var enable : Bool = true
    @IBInspectable var fillColor : UIColor = UIColor.lightGrayColor()
    @IBInspectable var backColor : UIColor = UIColor.grayColor()
    @IBInspectable var lockColor : UIColor = UIColor.whiteColor()
    
    @IBInspectable var textColor : UIColor = UIColor.whiteColor()
    @IBInspectable var textSize : CGFloat = 17
    @IBInspectable var textWeight : CGFloat = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        _init()
    }
    
    private func _init() {
        self.backgroundColor = UIColor.clearColor()
        updateCount()
    }
    func updateCount() {
        if showCount != count {
            showCount += showCount > count ? -1 : 1
            setNeedsDisplay()
            NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: #selector(MDPercentView.updateCount), userInfo: nil, repeats: false)
        } else {
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MDPercentView.updateCount), userInfo: nil, repeats: false)
            
        }
    }
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        let radius = min(rect.size.height , rect.size.width) / 2
        let center = rect.center
        
        // background circle
        CGContextSaveGState(context)
        let bpath = UIBezierPath(ovalInRect: center.asCenter(radius * 2, radius * 2))
        backColor.setFill()
        bpath.fill()
        if enable {
            // arc by count
            CGContextSetStrokeColorWithColor(context,fillColor.CGColor);
            let path = CGPathCreateMutable();
            CGContextSetLineWidth(context, radius );
            CGPathAddArc(path, nil, rect.size.width / 2 , rect.size.height / 2  ,  radius / 2 , CGFloat(-M_PI_2), CGFloat(showCount-25)/50.0 * CGFloat(M_PI), false);
            CGContextAddPath(context, path);
            CGContextStrokePath(context);
            
            // percent text
            CGContextSetFillColorWithColor(context, textColor.CGColor)
            CGContextSetTextDrawingMode(context,.Fill)
            let label:NSString="\(showCount)%"
            let style:NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            style.alignment = .Center
            let font : UIFont = UIFont.systemFontOfSize(textSize, weight: textWeight/10)
            label.drawInRect(CGRectMake(0,rect.size.height/2 - font.lineHeight/2,rect.size.width,font.lineHeight), withAttributes: [ NSFontAttributeName : font , NSForegroundColorAttributeName : textColor ,
                NSParagraphStyleAttributeName: style ])
            
        } else {
            lockColor.setStroke()
            lockColor.setFill()
            
            let handPath = UIBezierPath()
            let handRect = center.offset(0, -0.5 * radius).asCenter(0.5 * radius, 0.5 * radius)
            handPath.moveToPoint(handRect[.Left,.Bottom])
            handPath.addCurveToPoint(handRect[.Right,.Bottom], controlPoint1: handRect[.Left,.Top], controlPoint2: handRect[.Right,.Top])
            handPath.lineWidth = radius * 0.1
            handPath.stroke()
            
            let bodyRect = center.offset(0, 0.15 * radius).asCenter(radius, 0.7 * radius)
            UIBezierPath(roundedRect: bodyRect, cornerRadius: 0).fill()
            
            let keyRect = center.asCenter( 0.25 * radius, 0.25 * radius )
            let keyPath = UIBezierPath(ovalInRect: keyRect)
            backColor.setFill()
            keyPath.fill()
            
            let triRect = center.offset(0, 0.15 * radius).asCenter(0.3 * radius, 0.5 * radius)
            let triPath = UIBezierPath()
            triPath.moveToPoint(triRect[.Center,.Top])
            triPath.addLineToPoint(triRect[.Left,.Bottom])
            triPath.addLineToPoint(triRect[.Right,.Bottom])
            triPath.closePath()
            triPath.fill()
        }
        CGContextRestoreGState(context)
        
    }

}
