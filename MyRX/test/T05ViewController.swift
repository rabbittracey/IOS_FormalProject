//
//  T05ViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/3/16.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class T05ViewController: UIPageViewController , UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([viewControllerAtIndex(0)], direction: .Forward , animated: true, completion: nil)
        // Do any additional setup after loading the view.
        view.frame = UIScreen.mainScreen().bounds
        view.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func viewControllerAtIndex(index:Int) -> TestViewController1 {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("Test02") as! TestViewController1
        vc.index = index
        return vc
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TestViewController1).index
        if index == 0 {
            return nil
        }
        index -= 1 ;
        return viewControllerAtIndex(index)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TestViewController1).index
        if ( index == 4 ) {
            return nil
        }
        index += 1
        return viewControllerAtIndex(index)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 5
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
