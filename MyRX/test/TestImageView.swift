//
//  TestImageView.swift
//  MyRX
//
//  Created by EagleForce on 16/3/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@IBDesignable
class TestImageView: UIImageView {
    private weak var origImage:UIImage?
    private var notColorImage:UIImage?
    
    @IBInspectable var notColor:Bool = false {
        didSet {
            if (origImage == nil) {
                origImage = self.image
                notColorImage = TestImageView.convertImageToGrayScale(origImage)
            }
            image = notColor ? notColorImage : origImage
            setNeedsDisplay()
        }
    }
    static func convertImageToGrayScale(image:UIImage?) -> UIImage? {
        if image == nil {
            return nil
        }
        let imageRect = CGRectMake(0, 0, image!.size.width, image!.size.height);
        let colorSpace = CGColorSpaceCreateDeviceGray();
        var context = CGBitmapContextCreate(nil, Int(image!.size.width), Int(image!.size.height), 8, 0, colorSpace, CGImageAlphaInfo.None.rawValue) //kCGImageAlphaNone);
        CGContextDrawImage(context, imageRect, image!.CGImage);
        
        let imageRef = CGBitmapContextCreateImage(context);
        context = CGBitmapContextCreate(nil,Int(image!.size.width), Int(image!.size.height), 8, 0, nil, CGImageAlphaInfo.Only.rawValue) //kCGImageAlphaOnly );
        CGContextDrawImage(context, imageRect, image!.CGImage);
        let mask = CGBitmapContextCreateImage(context);
        return UIImage(CGImage: CGImageCreateWithMask(imageRef, mask)!)
    }
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }

}
