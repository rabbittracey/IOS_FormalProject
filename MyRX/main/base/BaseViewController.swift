//
//  BaseViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

protocol BaseProtocol {
    var appearDuration:Double { get set }
    var appearCurve:Int { get set }
    var appearTransition:Int { get set }
    var disappearDuration:Double { get set }
    var disappearCurve:Int { get set }
    var disappearTransition:Int { get set }
    var hidesBackButton:Bool { get set }
    var rightBarButton:UIButton? { get set }
    var leftBarButton:UIButton? { get set }
    var backToRoot:Bool { get set }
    func goback(sender:AnyObject)
}
extension BaseProtocol where Self:UIViewController {
    func baseViewDidLoad() {
    }
    func baseViewWillAppear(animated: Bool) {
        if let _ = self as? HomeViewController {
            navigationItem.titleView = UIImageView(image:UIImage(named: "top_home"))
        } else if let title = self.title {
            navigationItem.title = title
        }
        navigationController?.navigationBar.translucent = false
        tabBarController?.tabBar.translucent = false
        if BaseViewController.tabBarFrame == nil {
            BaseViewController.tabBarFrame = tabBarController?.tabBar.frame
        }
        if let navi = navigationController {
            if let button = rightBarButton {
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
            }
            if navi.viewControllers.count > 1 {
                if !hidesBackButton {
                    let button = leftBarButton ?? BaseViewController.backBarButton
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
                    button.block_setAction({ [weak self] (sender) in
                        self?.goback(sender)
                    })
                }
                tabBarController?.tabBar.frame = BaseViewController.tabBarFrame!.insetBy(dx: 0, dy: 100)
            }
            else {
                tabBarController?.tabBar.frame = BaseViewController.tabBarFrame!
            }
        }
    }
    
    func goback(sender:AnyObject) {
        UIView.beginAnimations("MDNavigationBack", context: nil)
        UIView.setAnimationDuration(disappearDuration)
        UIView.setAnimationRepeatAutoreverses(false)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue:disappearCurve)!)
        UIView.setAnimationTransition(UIViewAnimationTransition(rawValue: disappearTransition)! , forView: navigationController!.view, cache: true)
        UIView.commitAnimations()
        navigationController?.popViewControllerAnimated(false)
    }
    func basePrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segue01 = segue as? MDSegue01 {
            if let destination = segue01.destinationViewController as? BaseProtocol {
                segue01.duration = destination.appearDuration
                segue01.curve = destination.appearCurve
                segue01.transition = destination.appearTransition
                segue01.backToRoot = destination.backToRoot
            }
        }
    }
}

class BaseViewController: UIViewController,BaseProtocol {
    static var backBarButton:UIButton {
        let button = UIButton(type: .Custom)
        let image = UIImage(named: "back")!
        button.bounds = CGRect(origin: CGPointZero, size: image.size)
        button.setImage(image, forState: .Normal)
        return button
    }
    var hidesBackButton:Bool = false {
        didSet {
            navigationItem.hidesBackButton = hidesBackButton
        }
    }
    @IBInspectable var appearDuration:Double = 0.5
    @IBInspectable var appearCurve:Int = 0
    @IBInspectable var appearTransition:Int = 1
    @IBInspectable var disappearDuration:Double = 0.5
    @IBInspectable var disappearCurve:Int = 0
    @IBInspectable var disappearTransition:Int = 2
    
    private static var tabBarFrame:CGRect?
    
    @IBOutlet var rightBarButton:UIButton?
    @IBOutlet var leftBarButton:UIButton?
    @IBInspectable var backToRoot:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.baseViewWillAppear(animated)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.basePrepareForSegue(segue, sender: sender)
    }

}

class BaseTableViewController: UITableViewController,BaseProtocol {
    var hidesBackButton:Bool = false {
        didSet {
            navigationItem.hidesBackButton = hidesBackButton
        }
    }
    @IBInspectable var appearDuration:Double = 0.5
    @IBInspectable var appearCurve:Int = 0
    @IBInspectable var appearTransition:Int = 1
    @IBInspectable var disappearDuration:Double = 0.5
    @IBInspectable var disappearCurve:Int = 0
    @IBInspectable var disappearTransition:Int = 2
    
    @IBOutlet var rightBarButton:UIButton?
    @IBOutlet var leftBarButton:UIButton?
    @IBInspectable var backToRoot:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.baseViewWillAppear(animated)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.basePrepareForSegue(segue, sender: sender)
    }
}
class BaseFormViewController: FormViewController,BaseProtocol {
    var hidesBackButton:Bool = false {
        didSet {
            navigationItem.hidesBackButton = hidesBackButton
        }
    }
    @IBInspectable var appearDuration:Double = 0.5
    @IBInspectable var appearCurve:Int = 0
    @IBInspectable var appearTransition:Int = 3
    @IBInspectable var disappearDuration:Double = 0.5
    @IBInspectable var disappearCurve:Int = 0
    @IBInspectable var disappearTransition:Int = 4
    
    @IBOutlet var rightBarButton:UIButton?
    @IBOutlet var leftBarButton:UIButton?
    @IBInspectable var backToRoot:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.baseViewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.baseViewWillAppear(animated)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.basePrepareForSegue(segue, sender: sender)
    }
}


