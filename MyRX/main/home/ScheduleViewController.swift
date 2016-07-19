//
//  ScheduleViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/3/15.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class ScheduleItemViewController : BaseViewController {
    var index:Int!
}
class ScheduleViewController: HomeTableViewCellViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate {
    var viewCount : Int = 0
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var pageViewController:UIPageViewController!
    var scheduleItemViewControllers = [ScheduleItemViewController]()
    
    private func itemWithIndex(index:Int) -> ScheduleItemViewController? {
        if index < 0 || index >= viewCount {
            return nil
        }
        (index - scheduleItemViewControllers.count + 1).forEach { i,total in
            let item = storyboard?.instantiateViewControllerWithIdentifier("scheduleItem") as! ScheduleItemViewController
            item.index = scheduleItemViewControllers.count
            scheduleItemViewControllers.append(item)
        }
        return scheduleItemViewControllers[index]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cellHeight = 180
//        User.current.reminders
        viewCount = 10
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        addChildViewController(pageViewController)
        pageViewController.didMoveToParentViewController(self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageViewController.view)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: ["view":pageViewController.view]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view":pageViewController.view]))
        pageViewController.setViewControllers([itemWithIndex(0)!], direction:.Forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageControl.numberOfPages = viewCount
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(ScheduleViewController.onPageChange(_:)), forControlEvents: .ValueChanged)
        // Do any additional setup after loading the view.
    }
    func onPageChange(sender:AnyObject) {
        let cindex = (pageViewController.viewControllers![0] as! ScheduleItemViewController).index
        print(pageControl.currentPage)
        pageViewController.setViewControllers([itemWithIndex(pageControl.currentPage)!], direction: (cindex > pageControl.currentPage) ?.Reverse:.Forward, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItemsInSwipeView(swipeView:MDSwipeView) -> Int {
        return viewCount
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return itemWithIndex((viewController as! ScheduleItemViewController).index - 1)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return itemWithIndex((viewController as! ScheduleItemViewController).index + 1)

    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageControl.currentPage = ( pageViewController.viewControllers![0] as! ScheduleItemViewController ).index
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    class func createParentContainer() -> HomeTableViewCellViewController {
//        let container = HomeTableViewCellViewController()
//    }
}
