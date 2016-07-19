//
//  MDRuleView.swift
//  MyRX
//
//  Created by EagleForce on 16/3/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class MDRuleView: UIView {
    @IBInspectable  var interval:CGFloat = 100
    @IBInspectable  var subInterval:CGFloat = 50
    @IBInspectable  var lineColor:UIColor = UIColor.grayColor()
    @IBInspectable  var lineWidth:CGFloat = 1
    @IBInspectable  var subLineColor:UIColor = UIColor.grayColor()
    @IBInspectable  var subLineWidth:CGFloat = 0.5
    @IBInspectable  var textSize:CGFloat = 11
    @IBInspectable  var textWeight:CGFloat = 1
    @IBInspectable  var textColor:UIColor = UIColor(white: 0.4, alpha: 1)

    @IBInspectable  var installed:Bool = false {
        didSet {
//            self.hidden = !installed
        }
    }
    
    private let style:NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
    private var font : UIFont!

    func setUp() {
//        self.hidden = !installed
        print("-----------")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private func drawLineFrom(point1:CGPoint , to point2:CGPoint , width:CGFloat) {
        let path = UIBezierPath()
        path.moveToPoint(point1)
        path.addLineToPoint(point2)
        path.lineWidth = width
        path.stroke()
        
    }
    
    private func drawString(string:String , at point:CGPoint , size:CGFloat) {
        NSString(string: string).drawInRect(point.asCenter(150, 40), withAttributes: [ NSFontAttributeName : font.fontWithSize(size) , NSForegroundColorAttributeName : textColor ,
            NSParagraphStyleAttributeName: style ])
        
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        style.alignment = .Center
        font = UIFont.systemFontOfSize(textSize, weight: textWeight/10)
        for i in CGFloat(0).stride(to: rect.size.width, by: interval) {
//        for var i:CGFloat = 0 ; i < rect.size.width ; i += interval {
            lineColor.set()
            drawLineFrom(CGPointMake(i,0), to: CGPointMake(i,rect.size.height), width: lineWidth)
            drawString("\(Int(i))", at: CGPoint(x: i, y: 50),size:textSize)
            subLineColor.set()
            for j in (i+subInterval).stride(to:i+interval,by: subInterval) {
//            for var j = i + subInterval ; j < i + interval ; j += subInterval {
                drawLineFrom(CGPointMake(j,0), to: CGPointMake(j,rect.size.height), width: subLineWidth)
            }
        }

        for i in CGFloat(0).stride(to: rect.size.height, by: interval) {
//        for var i:CGFloat = 0 ; i < rect.size.height ; i += interval {
            lineColor.set()
            drawLineFrom(CGPointMake(0,i), to: CGPointMake(rect.size.width,i), width: lineWidth)
            drawString("\(Int(i))", at: CGPoint(x: 50, y: i),size:textSize)
            subLineColor.set()
            for j in (i+subInterval).stride(to:i+interval,by: subInterval) {
//            for var j = i + subInterval ; j < i + interval ; j += subInterval {
                drawLineFrom(CGPointMake(0,j), to: CGPointMake(rect.size.width,j), width: subLineWidth)
            }
        }
        
        drawString("\(Int(rect.size.width)) X \(Int(rect.size.height))", at: rect.center,size:textSize*2)

    }

}
