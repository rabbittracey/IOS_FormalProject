//
//  BaseTabBarController.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController , UITabBarControllerDelegate {
    let top_home = UIImageView(image:UIImage(named: "top_home"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabSwitchAnimationController(direct: viewControllers!.indexOf(fromVC) < viewControllers!.indexOf(toVC))
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

class TabSwitchAnimationController: NSObject , UIViewControllerAnimatedTransitioning {
    let direct:Bool
    init(direct:Bool) {
        self.direct = direct
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toVC!.view
        let fromView = fromVC!.view
        let containerView = transitionContext.containerView()!
        
        containerView.addSubview(toView)
        let frame = transitionContext.finalFrameForViewController(toVC!)
        toView.frame.origin.x = direct ? frame.size.width : -frame.size.width
        UIView.animateWithDuration(transitionDuration(transitionContext) , delay: 0.0 , usingSpringWithDamping: 1 , initialSpringVelocity: 0.0 ,
            options: .AllowUserInteraction , animations: {() -> Void in
                fromView.frame.origin.x = self.direct ? -frame.size.width : frame.size.width
                toView.frame.origin.x = frame.origin.x
            } , completion:  { (finished : Bool) -> Void in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
        })
    }
}
