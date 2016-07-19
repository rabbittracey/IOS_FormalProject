//
//  LoginViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/27.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import SwiftSpinner
import Alamofire

class LoginViewController: BaseFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form = Section("Please login")
            <<< EmailRow("email") {
                $0.title = "Email:"
        }
            <<< PasswordRow("password") {
                $0.title = "Password:"
        }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Login"
        }.onCellSelection({ [weak self] (cell, row) in
            let email = (self!.form.rowByTag("email") as! EmailRow).value
            let password = (self!.form.rowByTag("password") as! PasswordRow).value
            if email == nil {
                notification_top.showNotification("Email:", body: "Email is not blank", onTap:{
                    self?.form.rowByTag("email")?.baseCell.setSelected(true, animated: false)
                })
                return
                
            }
            if !(email?.match(Account.email_reg))! {
                notification_top.showNotification("Email:", body: "Email is error format", onTap:{
                    self?.form.rowByTag("email")?.baseCell.setSelected(true, animated: false)
                })
                return
            }
            if password == nil {
                notification_top.showNotification("Password:", body: "Password is not blank", onTap:{
                    self?.form.rowByTag("password")?.baseCell.setSelected(true, animated: false)
                })
                return
                
            }
            if !(password!.match(Account.password_reg)) {
                notification_top.showNotification("Password:", body: "Password is error", onTap:{
                    self?.form.rowByTag("password")?.baseCell.setSelected(true, animated: false)
                })
                return
            }
            SwiftSpinner.show("Login to server...")
            login(email!,password: password!).responseObject { (response:Response<Account,NSError>) in
                    switch response.result {
                    case .Success(let result):
                        SwiftSpinner.hide()
                        try! currentRealm().write({
                            let account = currentAccount()
                            account.copyfrom(result)
                            account.islogin = true
                            })
                        self?.navigationController?.popViewControllerAnimated(true)
                    case .Failure(let error):
                        SwiftSpinner.show(error.localizedDescription).addTapHandler({
                            SwiftSpinner.hide()
                        })
                    }                    
            }
            
            
        })
    }
}
