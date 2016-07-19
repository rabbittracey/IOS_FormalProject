//
//  MDTopAlignedLabel.swift
//  MyRX
//
//  Created by EagleForce on 16/2/29.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class MDTopAlignedLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: font],
                context: nil).size
            super.drawTextInRect(CGRectMake(0, 0, CGRectGetWidth(self.frame), ceil(labelStringSize.height)))
        } else {
            super.drawTextInRect(rect)
        }
    }
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.blackColor().CGColor
//    }
}
