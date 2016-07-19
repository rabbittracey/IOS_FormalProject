//
//  ChangePasswordViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/14.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import ObjectMapper
import Alamofire
import SwiftSpinner

class ChangePasswordViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Password")
            <<< PasswordFloatLabelRow("password") {
                $0.title = "Password"
            }
            <<< PasswordFloatLabelRow("password_again") {
                $0.title = "Confirm Password"
            }
        +++ Section()
            <<< ButtonRow("submit") {
                $0.title="Submit"
                }.onCellSelection({ [weak self] (row,cell) in
                    self?.updateValues()
                })
        
    }
    private func updateValues() {
        let values = form.values()
        guard let password = values["password"] as? String where password.match(Account.password_reg) else {
            notification_top.showNotification("password", body: "Password error", onTap:nil)
            return
        }
        guard values["password"] as? String == values["password_again"] as? String else {
            notification_top.showNotification("password", body: "These passwords don't match. Try again.", onTap:nil)
            return
        }
        changePassword(password).responseObject(completionHandler: { (response:Response<Account,NSError>) in
            switch response.result {
            case .Failure:
                notification_top.showNotification("Update password error", body: "Please check your network,and try it again", onTap: nil)
            case .Success:
                break
            }
        })
        self.navigationController?.popViewControllerAnimated(true)
    }

}
