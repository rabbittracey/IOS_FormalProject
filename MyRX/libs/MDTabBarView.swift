//
//  MDTabBarView.swift
//  rx
//
//  Created by EagleForce on 16/2/19.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@objc protocol MDTabBarViewDataSource : MDSwipeViewDataSource {
    func tabViewTitleByIndex(index:Int) -> String
}

class MDTabBarView: UIView , MDSwipeViewDelegate {
    @IBOutlet weak var dataSource:MDTabBarViewDataSource?
    @IBInspectable var tabBarHeight:CGFloat = 40
    @IBInspectable var tabBarBackgroundColor:UIColor = UIColor.grayColor()
    @IBInspectable var tabBarSelectColor:UIColor = UIColor.brownColor()
    
    @IBInspectable var tabBarFontSize:CGFloat = 15
    @IBInspectable var tabBarFontWeight:CGFloat = 0
    @IBInspectable var tabBarSelectFontWeight:CGFloat = 1
    @IBInspectable var tabBarFontColor:UIColor = UIColor.whiteColor()

    @IBInspectable var select : Int = 0
    private var tabBarBackgroundView:UIView!
    private var tabBarSelectView:MDCornerView!
    private var tabBarTitleLabels = [UILabel]()
    private var tabBarSelectBlock:MDCornerView!
    private var contentView:MDSwipeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    func setUp() {
        tabBarBackgroundView = UIView()
        addSubview(tabBarBackgroundView)
        
        contentView = MDSwipeView()
        contentView.delegate = self
        addSubview(contentView)
        tabBarSelectBlock = MDCornerView()
        tabBarSelectBlock.cornerRadii = CGSizeMake(10,10)
        tabBarSelectBlock.bottomLeft = false
        tabBarSelectBlock.bottomRight = false
        tabBarBackgroundView.addSubview(tabBarSelectBlock)
        
        clipsToBounds = true
        if dataSource != nil{
            reloadData()
        }
    }
    func reloadData() {
        contentView.dataSource = dataSource
        contentView.reloadData()
        if let _datas = dataSource {
            
            tabBarTitleLabels.forEach {
                $0.removeFromSuperview()
            }
            tabBarTitleLabels.removeAll()
            let num = _datas.numberOfItemsInSwipeView(contentView)
            num.forEach {
                let label=UILabel()
                label.text = _datas.tabViewTitleByIndex($0.0)
                label.autoresizingMask = [ .FlexibleWidth , .FlexibleHeight ]
                label.backgroundColor = UIColor.clearColor()
                label.textAlignment = .Center
                label.font = UIFont.systemFontOfSize(tabBarFontSize, weight: $0.0 == select ? tabBarSelectFontWeight : tabBarFontWeight)
                label.textColor = tabBarFontColor
                let tap = UITapGestureRecognizer(target: self, action: #selector(MDTabBarView.onClick(_:)))
                tap.numberOfTapsRequired = 1
                label.userInteractionEnabled = true
                label.addGestureRecognizer(tap)
                self.tabBarTitleLabels.append(label)
                self.tabBarBackgroundView.addSubview(label)
            }
        }
        setNeedsLayout()
    }
    func onClick(tapRecognizer:UITapGestureRecognizer) {
        let touchPoint = tapRecognizer.locationInView(contentView)
        select = Int(touchPoint.x * CGFloat(tabBarTitleLabels.count) / contentView.frame.size.width)
        tabBarTitleLabels.count.forEach {
            tabBarTitleLabels[$0.0].font = UIFont.systemFontOfSize(tabBarFontSize, weight:  $0.0 == select ? tabBarSelectFontWeight : tabBarFontWeight)
        }
        contentView.gotoPage(select)
    }
    override func layoutSubviews() {
        tabBarBackgroundView.backgroundColor = tabBarBackgroundColor
        tabBarBackgroundView.frame = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, tabBarHeight))
        contentView.frame = CGRectMake(0, tabBarHeight, bounds.size.width, bounds.size.height - tabBarHeight)
        if tabBarTitleLabels.count > 0 {
            let blockSize = CGSizeMake(bounds.size.width / CGFloat(tabBarTitleLabels.count), tabBarHeight)
            tabBarSelectBlock.color = tabBarSelectColor
            tabBarTitleLabels.count.forEach {
                let label = self.tabBarTitleLabels[$0.0]
                label.frame = CGRect(origin: CGPointMake(CGFloat($0.0) * blockSize.width, 0),size:blockSize)
            }
            tabBarSelectBlock.frame =  CGRect(origin: CGPointMake(CGFloat(select) * blockSize.width, 0),size:blockSize)
        }
        super.layoutSubviews()
    }
    func swipeViewDidScroll(swipwView:MDSwipeView,offset:CGFloat) {
        let blockSize = CGSizeMake(bounds.size.width / CGFloat(tabBarTitleLabels.count), tabBarHeight)
        tabBarSelectBlock.frame =  CGRect(origin: CGPointMake(offset * blockSize.width, 0),size:blockSize)
    }
    func swipeView(swipwView: MDSwipeView, didSelectItemAtIndex index: Int) -> Bool {
        select = index
        tabBarTitleLabels.count.forEach {
            tabBarTitleLabels[$0.0].font = UIFont.systemFontOfSize(tabBarFontSize, weight:  $0.0 == select ? tabBarSelectFontWeight : tabBarFontWeight)
        }
        return true
    }
}
