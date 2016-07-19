//
//  MyMedicationViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/3/17.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
class MyMedicationItemViewController : BaseViewController {
    var index:Int!
    
    private func addMedication(index:Int) {
        let width = UIScreen.mainScreen().bounds.width / 3
        let container = UIView()
        let back = UIImageView(image: UIImage(imageLiteral: "Rectangle"))
        back.contentMode = .ScaleToFill
        back.frame = CGRectMake((width-86)/2-3,2,86,86)
        container.addSubview(back)
        
        let drug = UIImageView(image: UIImage(imageLiteral: "drug"))
        drug.contentMode = .ScaleToFill
        drug.frame = CGRectMake((width-72)/2-3,9,72,72)
        container.addSubview(drug)
        
        let title = UILabel(frame: CGRectMake((width-86)/2-3,88,86,13))
        title.textAlignment = .Center
        title.font = UIFont.systemFontOfSize(13)
        title.text = ["Goserlin","Gentamicin","Ketoprofen"].random()
        container.addSubview(title)
        
//        container.backgroundColor = UIColor.random
        container.frame = CGRectMake(width * CGFloat(index),0,width,102)
        view.addSubview(container)
    }
    override func viewDidLoad() {
        addMedication(0)
        addMedication(1)
        addMedication(2)
    }
}
class MyMedicationViewController: HomeTableViewCellViewController , UIPageViewControllerDataSource , UIPageViewControllerDelegate  {
    var viewCount:Int = 0
    var pageViewController:UIPageViewController!
    var medicationItemViewControllers = [MyMedicationItemViewController]()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!

    private func itemWithIndex(index:Int) -> MyMedicationItemViewController? {
        if index < 0 || index >= viewCount {
            return nil
        }
        (index - medicationItemViewControllers.count + 1).forEach { i,total in
            let item = MyMedicationItemViewController()
            item.index = medicationItemViewControllers.count
            medicationItemViewControllers.append(item)
        }
        return medicationItemViewControllers[index]
    }

    override func viewDidLoad() {
        cellHeight = 200
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
        pageControl.addTarget(self, action: #selector(MyMedicationViewController.onPageChange(_:)), forControlEvents: .ValueChanged)
        
    }
    func onPageChange(sender:AnyObject) {
        let cindex = (pageViewController.viewControllers![0] as! MyMedicationItemViewController).index
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
        return itemWithIndex((viewController as! MyMedicationItemViewController).index - 1)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return itemWithIndex((viewController as! MyMedicationItemViewController).index + 1)
        
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageControl.currentPage = (pageViewController.viewControllers![0] as! MyMedicationItemViewController).index
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
