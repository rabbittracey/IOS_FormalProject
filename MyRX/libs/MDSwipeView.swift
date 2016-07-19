//
//  MDSwipeView.swift
//  rx
//
//  Created by EagleForce on 16/2/18.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

@objc protocol MDSwipeViewDataSource : class {
    func numberOfItemsInSwipeView(swipeView:MDSwipeView) -> Int
    func swipeView(swipeView:MDSwipeView,viewForItemAtIndex index:Int, reusingView view:UIView) -> UIView
    
}
@objc protocol MDSwipeViewDelegate : class {
//    optional func swipeViewItemSize(swipwView:MDSwipeView) -> CGSize
    optional func swipeViewDidScroll(swipwView:MDSwipeView,offset:CGFloat)
//    optional func swipeViewCurrentItemIndexDidChange(swipwView:MDSwipeView)
//    optional func swipeViewWillBeginDragging(swipwView:MDSwipeView)
//    optional func swipeViewDidEndDragging(swipwView:MDSwipeView,willDecelerate decelerate:Bool)
//    optional func swipeViewWillBeginDecelerating(swipwView:MDSwipeView)
//    optional func swipeViewDidEndDecelerating(swipwView:MDSwipeView)
//    optional func swipeViewDidEndScrollingAnimation(swipwView:MDSwipeView)
//    optional func swipeView(swipwView:MDSwipeView,shouldSelectItemAtIndex index:Int) ->Bool
    optional func swipeView(swipwView:MDSwipeView,didSelectItemAtIndex index:Int) ->Bool
    
}

class MDSwipeView: UIView , UIScrollViewDelegate {
    @IBOutlet weak var dataSource:MDSwipeViewDataSource?
    @IBOutlet weak var delegate:MDSwipeViewDelegate?
    
    var bounces:Bool = true
    var wrapEnabled = false
    var vertical = false
    var offset:CGFloat {
        return scrollView.contentOffset.x / self.bounds.size.width
    }
    private var scrollView:UIScrollView!
    private var views = [UIView]()
    private var lastIndex:Int = -10000
    
    
    private func setUp() {
        scrollView = UIScrollView()
        scrollView.autoresizingMask = [.FlexibleHeight , .FlexibleWidth ]
        scrollView.autoresizesSubviews = true
        scrollView.delegate = self
        scrollView.delaysContentTouches = true
        scrollView.bounces = bounces && !wrapEnabled
        scrollView.alwaysBounceHorizontal = !vertical && bounces
        scrollView.alwaysBounceVertical = vertical && bounces
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.clipsToBounds = false
        scrollView.decelerationRate = 0
        clipsToBounds = true
        insertSubview(scrollView, atIndex: 0)
        
        for _ in 0...2 {
            let _view = UIView()
            _view.clipsToBounds = true
            _view.hidden = true
            scrollView.addSubview(_view)
            views.append(_view)
        }
                
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    func reloadData() {
        lastIndex = -10000
        setNeedsLayout()
    }
    
    private func renderView(view:UIView , atIndex index:Int) {
        view.subviews.forEach { $0.removeFromSuperview() }
        if let number = dataSource?.numberOfItemsInSwipeView(self) {
            if index >= 0 && index < number {
                view.hidden = false
                view.frame = self.bounds.offsetBy(dx: CGFloat(index) * self.bounds.size.width, dy: 0)
                dataSource?.swipeView(self, viewForItemAtIndex: index, reusingView: view)
                return
            }
        }
        view.hidden = true
    }
    func render() {
        if !userInteractionEnabled { return }
        let offset = scrollView.contentOffset.x
        let index = Int(floor(offset / scrollView.bounds.width + 0.5 ))
        // render index , index+1
        switch index - lastIndex {
        case 0:
            return
        case -1:
            views = [ views[2] , views[0] , views[1] ]
            renderView(views[0], atIndex: index-1)
        case -2:
            views = [ views[1] , views[2] , views[0] ]
            renderView(views[0], atIndex: index-1)
            renderView(views[1], atIndex: index)
        case 2:
            views = [ views[2] , views[0] , views[1] ]
            renderView(views[1], atIndex: index)
            renderView(views[2], atIndex: index+1)
        case 1:
            views = [ views[1] , views[2] , views[0] ]
            renderView(views[2], atIndex: index+1)
        default:
            renderView(views[0], atIndex: index-1)
            renderView(views[1], atIndex: index)
            renderView(views[2], atIndex: index+1)
        }
        lastIndex = index
    }
    
    func fixRender() {
        let offset = scrollView.contentOffset.x
        let index = floor(offset / scrollView.bounds.width + 0.5)
//        scrollView.decelerationRate = 100
        scrollView.setContentOffset(CGPointMake(index * self.bounds.size.width, 0), animated: true)
        delegate?.swipeView?(self, didSelectItemAtIndex: Int(index))
//        UIView.setAnimationCurve(.EaseOut)
    }
    override func layoutSubviews() {
        scrollView.frame = self.bounds
        if let number = dataSource?.numberOfItemsInSwipeView(self) {
            scrollView.contentSize = CGSizeMake(self.bounds.size.width * CGFloat(number), self.bounds.size.height)
        }
        render()
        super.layoutSubviews()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        render()
        delegate?.swipeViewDidScroll?(self, offset: offset)
    }
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.memory = scrollView.contentOffset
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        fixRender()
    }
    func gotoPage(page:Int) {
        if let number = dataSource?.numberOfItemsInSwipeView(self) {
            if page >= 0 && page < number {
                scrollView.decelerationRate = 1
                self.scrollView.setContentOffset(CGPointMake( CGFloat(page) * self.bounds.size.width, 0), animated: true)                
            }
        }
    }
}
