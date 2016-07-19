//
//  MDCornerView.swift
//  rx
//
//  Created by EagleForce on 16/2/17.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit


@IBDesignable
class MDCornerView: UIView {
    @IBInspectable  var  topLeft : Bool = true {
        didSet {
            if topLeft { corners.insert(.TopLeft) } else { corners.remove(.TopLeft) }
        }
    }
    @IBInspectable  var  topRight : Bool = true {
        didSet {
            if topRight { corners.insert(.TopRight) } else { corners.remove(.TopRight) }
        }
    }

    @IBInspectable  var  bottomLeft : Bool = true {
        didSet {
            if bottomLeft { corners.insert(.BottomLeft) } else { corners.remove(.BottomLeft) }
        }
    }

    @IBInspectable  var  bottomRight : Bool = true {
        didSet {
            if bottomRight { corners.insert(.BottomRight) } else { corners.remove(.BottomRight) }
        }
    }

    @IBInspectable  var  cornerRadii : CGSize = CGSize(width: 5, height: 5)
    @IBInspectable  var  color : UIColor = UIColor.grayColor()
    
    var corners:UIRectCorner = [.TopLeft,.TopRight,.BottomLeft,.BottomRight]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
//        let context = UIGraphicsGetCurrentContext();
//        CGContextClearRect(context, rect);
//        UIColor.clearColor().setFill()
//        UIBezierPath(rect: rect).fill()
       
        color.setFill()
        UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: cornerRadii).fill()
    }
//    override func layoutSubviews() {
//        let mask = CAShapeLayer()
//        mask.path =
//        super.layoutSubviews()
//    }

}
