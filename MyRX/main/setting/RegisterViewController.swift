//
//  RegisterViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/28.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import ObjectMapper
import Alamofire
import SwiftSpinner

class RegisterViewController: BaseFormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Basic Information")
            <<< EmailFloatLabelRow("email") {
                $0.title = "Email Address"
                $0.value = currentAccount().email
            }
            <<< PasswordFloatLabelRow("password") {
                $0.title = "Password"
            }
            <<< PasswordFloatLabelRow("password_again") {
                $0.title = "Confirm Password"
            }
            <<< TextFloatLabelRow("fname") {
                $0.title = "First Name"
                $0.value = currentAccount().fname
            }
            <<< TextFloatLabelRow("lname") {
                $0.title = "Last Name"
                $0.value = currentAccount().lname
            }
            <<< SegmentedRow<String>("gender") {
                $0.title = "Gender   "
                $0.options = ["M","F","U"]
                $0.displayValueFor = {
                    guard let value = $0 else {
                        return nil
                    }
                    return GENDER_ADAPT[value]
                }
                $0.value = currentAccount().gender
            }
            +++ Section("External Information")
            <<< DateRow("dob") {
                $0.title = "Date of Birth"
                let formatter = NSDateFormatter()
                formatter.locale = .currentLocale()
                formatter.dateStyle = .ShortStyle
                $0.dateFormatter = formatter
                
                $0.value = currentAccount().dob
            }
            <<< PostalAddressRow("address"){
                $0.title = "Address"
                $0.streetPlaceholder = "Address1"
                $0.statePlaceholder = "Address2"
                $0.postalCodePlaceholder = "ZipCode"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "State"
                
                let account = currentAccount()
                $0.value = PostalAddress(street: account.address1,state: account.address2,postalCode: account.zipcode,city: account.city,country: account.state)
            }
        form +++ Section()
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

        switch Account.instance(form.values()) {
        case .Error(let field,let message):
            notification_top.showNotification(field, body: message, onTap:nil)
        case .Ok(let account):
            SwiftSpinner.show("Signup to server...")
            signup(account,password:password).responseObject(completionHandler: { (response:Response<Account,NSError>) in
                switch response.result {
                case .Success(let result):
                    SwiftSpinner.hide()
                    try! currentRealm().write({
                        let account = currentAccount()
                        account.copyfrom(result)
                        account.islogin = true
                    })
                    self.navigationController?.popViewControllerAnimated(true)
                case .Failure(let error):
                    SwiftSpinner.show(error.localizedDescription).addTapHandler({
                        SwiftSpinner.hide()
                    })
            }
            })
        }
    }

}
