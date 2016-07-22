//
//  SettingViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import Alamofire
import AlamofireObjectMapper
import RealmSwift

class SettingViewController: BaseFormViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.update()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            // Information form
            +++ Section("information") {
                $0.tag="information"
            }
            <<< FaceRow()
            <<< LabelRow("email") {
                $0.title = "Email"
                $0.value = currentAccount().email
                } .cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "mail")
                })
            <<< ButtonRow() {
                $0.title = "Update Information"
                $0.presentationMode = .SegueName(segueName: "InformationViewControllerSegue",completionCallback:nil)
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "Information")
                })
            <<< ButtonRow() {
                $0.title = "Change Password"
                $0.presentationMode = .SegueName(segueName: "changePasswordSegue",completionCallback:nil)
                
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "changePassword")
                })
            <<< ButtonRow() {
                $0.title = "Activation Code"
                $0.presentationMode = .SegueName(segueName: "ActivationCodeSegue",completionCallback:nil)
                
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "activation_code")
                })

            <<< ButtonRow() {
                $0.title = "Logout"
                }.cellSetup({(cell,row) in
                    cell.imageView?.image = UIImage(named: "logout")
                }).onCellSelection({ [weak self] (cell,row) in
                    try! currentRealm().write {
                        currentAccount().islogin = false
                    }
                    logout()
                    self?.update()
            })
            +++ Section() {
                $0.tag="synchronize"
            }
            <<< ButtonRow() {
                $0.title = "Synchronize"
                
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "synchronize")
                }).onCellSelection({ (cell, row) in
                })
        form +++ Section("login form") {
                $0.tag="login"
            }
            <<< TextAreaRow("desciption") {
                $0.disabled = true
                $0.value = Account_Description
                }.cellSetup({ (cell, row) in
                    cell.textView.font = UIFont.systemFontOfSize(12)
                })
            <<< ButtonRow("login") {
                $0.title = "Login/Register"
                $0.presentationMode = .SegueName(segueName: "LoginViewControllerSegue",completionCallback:nil)
                
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "icon_account")
                })
        
        form +++ Section("Ex Application")
            <<< ButtonRow("setting") {
                $0.title = "Setting"
                $0.presentationMode = .SegueName(segueName: "ExSettingViewControllerSegue",completionCallback:nil)
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named:"icon_setting")
                })
            <<< LinkRow("rateEx") {
                $0.title = "Rate Ex"
                $0.linkUrl = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(AppDelegate.properties.valueForKey("ApplicationID")!)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named:"icon_rate")
                })
            <<< ButtonRow("aboutUs") {
                $0.title = "About us"
                $0.presentationMode = .SegueName(segueName: "AboutUsViewControllerSegue",completionCallback:nil)
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named:"icon_aboutus")
                })
            +++ Section("Test")
            <<< ButtonRow("Test") {
                $0.title = "About us"
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named:"icon_aboutus")
                }).onCellSelection({ (cell,row) in
                })
        
        self.update()
    }
    func update() {
        let islogin = currentAccount().islogin
        if let section = form.sectionByTag("information") {
            section.hidden = Condition(booleanLiteral:!islogin)
            section.evaluateHidden()
            if islogin {
                form.rowByTag("email")!.value = currentAccount().email
                form.rowByTag("email")!.updateCell()
            }
        }
        if let section = form.sectionByTag("synchronize") {
            section.hidden = Condition(booleanLiteral:!islogin)
            section.evaluateHidden()
        }
        if let section = form.sectionByTag("login") {
            section.hidden = Condition(booleanLiteral:islogin)
            section.evaluateHidden()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
