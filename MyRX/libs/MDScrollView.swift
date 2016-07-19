//
//  MDScrollView.swift
//  rx
//
//  Created by EagleForce on 16/2/2.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MDScrollView: UIScrollView {
    var spacing:CGFloat = 5
    private var lastView:UIView?
    override init(frame: CGRect) {
        super.init(frame : frame)
        __init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        __init()
    }
    private func __init() {
        self.scrollEnabled = true
        self.scrollsToTop = true
        self.bounces = true
        self.alwaysBounceVertical = true
        self.flashScrollIndicators()
        
    }
    
//    override func addSubview(view: UIView) {
//        addContentView(view)
//    }
    
    
    func addContentView(contentView : UIView , height : Float = 0) {
        if height != 0 {
            var cframe = contentView.frame
            cframe.size.height = CGFloat(height)
            contentView.frame = cframe
        }
//        let _height = height==0 ? contentView.frame.height : height
        
        super.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSizeMake(0,3)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.5
        // equal containt's width
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: -10))
        // equal height
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: contentView.frame.size.height))
        // left
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 5))
        // top
        self.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: ( self.lastView != nil ? self.lastView : self ) , attribute: .Bottom, multiplier: 1, constant: spacing))
        self.lastView = contentView
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        var height:CGFloat = 0
//        subviews.forEach {
//            $0.frame = CGRectMake(10,height + 10 , bounds.size.width - 20 , $0.bounds.size.height)
//            height += 10 + $0.bounds.size.height
//        }
//        contentSize = CGSizeMake(bounds.size.width, height + 10)
        if let _frame = self.lastView?.frame {
            contentSize = CGSizeMake(_frame.size.width,_frame.size.height + _frame.origin.y + spacing)
        }
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
