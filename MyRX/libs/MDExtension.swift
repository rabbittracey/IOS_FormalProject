//
//  MDExtension.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

extension Int {
    var random:Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
    func toAPM() -> (Int,APM) {
        switch self {
        case 1..<12:
            return (self,.AM)
        case 0:
            return (12,.AM)
        case 12:
            return (12,.PM)
        case 13..<24:
            return (self-12,.PM)
        default:
            fatalError("Hour 0..23")
        }
    }
    var am:Int {
        if self == 12 { return 0 }
        return self
    }
    var pm:Int {
        if self == 12 { return 12 }
        return self + 12
    }
    func apm(apm:APM) -> Int {
        switch apm {
        case .AM:
            return self.am
        case .PM:
            return self.pm
        }
    }
    func forEach(@noescape body: (Int,total:Int) throws -> ()) rethrows {
        if self < 1 { return }
        for index in 1...self {
            do {
                try body(index-1,total:self)
            } catch {
                break
            }
        }
    }
}

extension CGFloat {
    static var random:CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
}
extension Float {
    static var random:Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }
}
extension Double {
    static var random:Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
}
extension Array {
    func random() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    subscript (r: Range<Int>) -> Array {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            return self[startIndex..<endIndex]
        }
    }
}

enum Horizontal : Int {
    case Left , Center , Right
}
enum Vertical : Int {
    case Top , Center , Bottom
}

extension CGPoint {
    func asCenter(width:CGFloat,_ height:CGFloat) -> CGRect {
        return CGRectMake(x - width / 2, y - height/2, width, height)
    }
    func offset(dx:CGFloat , _ dy:CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    var center : CGPoint {
        return origin.offset( size.width / 2, size.height / 2)
    }
    subscript(h:Horizontal,v:Vertical) -> CGPoint {
        return origin.offset(CGFloat(h.rawValue) * size.width / 2, CGFloat(v.rawValue) * size.height / 2)
    }
    func offset(dx : CGFloat , _ dy:CGFloat) -> CGRect {
        return CGRect(origin: origin.offset(dx, dy), size: size)
    }
}

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[startIndex..<endIndex]
        }
    }
    func regex (pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
            let nsstr = self as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : [String] = [String]()
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: all) {
                (result : NSTextCheckingResult?, _, _) in
                if let r = result {
                    let result = nsstr.substringWithRange(r.range) as String
                    matches.append(result)
                }
            }
            return matches
        } catch {
            return [String]()
        }
    }
    func match(pattern:String) -> Bool {
        let mtch = self.regex(pattern)
        return mtch.count > 0
    }
    func dateFormatter() -> NSDateFormatter {
        let format = NSDateFormatter()
        format.dateFormat = self
        return format
    }
}

extension UIColor {
    static var random:UIColor {
        return UIColor(red: CGFloat.random, green: CGFloat.random, blue: CGFloat.random, alpha: 1)
    }
}

extension UIViewController {
    func insertViewControllerWithId(sd_id:String , inView parentView:UIView) ->UIViewController? {
        return self.insertViewControllerWithId(sd_id, inView: parentView, atFrame: CGRect(origin: CGPointZero, size: parentView.frame.size))
    }
    func insertViewControllerWithId(sd_id:String , inView parentView:UIView , atFrame frame: CGRect) ->UIViewController? {
        if let storyboard = self.storyboard {
            let uvc = storyboard.instantiateViewControllerWithIdentifier(sd_id)
            addChildViewController(uvc)
            uvc.view.frame = CGRect(origin: CGPointMake(parentView.frame.size.width,frame.origin.y), size: frame.size)
            parentView.addSubview(uvc.view)
            uvc.didMoveToParentViewController(self)
            UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
                uvc.view.frame = frame
                }, completion: nil)
            
            return uvc
        }
        return nil
    }
    func dismissViewControllerFromParentController() {
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            var frame = self.view.frame
            frame.origin.x = -frame.size.width
            self.view.frame = frame
            }, completion: { (Bool) -> Void
                in
                //                self.removeFromParentViewController()
                //                self.view.removeFromSuperview()
                
        })
    }
}
extension UIView {
    func firstAvailableUIViewController() -> UIViewController? {
        if let nextResponder = self.nextResponder() {
            switch nextResponder {
            case let controller as UIViewController:
                return controller
            case let view as UIView:
                return view.firstAvailableUIViewController()
            default:
                return nil
            }
        }
        return nil
    }
    func insertViewControllerWithId(sd_id:String) ->UIViewController? {
        if let controller = self.firstAvailableUIViewController() {
            return controller.insertViewControllerWithId(sd_id, inView: self)
        }
        
        return nil
    }
    func offsetByParentView(parent:UIView) -> CGPoint {
        var ret = self.frame.origin
        var p = self
        while let _p = p.superview where _p != parent {
            ret = CGPointMake(ret.x+_p.frame.origin.x,ret.y+_p.frame.origin.y)
            p = _p
        }
        return ret
    }
    
    func hide(flag:Bool , completion : ((Bool) -> Void)? = nil) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            self.alpha = flag ? 0 : 1
            }, completion: completion)
    }
}

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
typealias BlockButtonActionBlock = (sender: UIButton) -> Void

class ActionBlockWrapper : NSObject {
    var block : BlockButtonActionBlock
    init(block: BlockButtonActionBlock) {
        self.block = block
    }
}

extension UIButton {
    func block_setAction(block: BlockButtonActionBlock) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: #selector(UIButton.block_handleAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender: sender)
    }
}


