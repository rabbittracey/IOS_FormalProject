//
//  InformationViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import ObjectMapper
import Alamofire

class InformationViewController: BaseFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        form +++ Section("Basic Information")
            <<< EmailFloatLabelRow("email") {
                $0.title = "Email Address"
                $0.value = currentAccount().email
                $0.disabled = true
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
            <<< DateRow("dob") {
                $0.title = "Date of Birth"
                let formatter = NSDateFormatter()
                formatter.locale = .currentLocale()
                formatter.dateStyle = .FullStyle
                $0.dateFormatter = formatter
                $0.value = currentAccount().dob
            }
            <<< PostalAddressRow("address"){
                $0.title = "Address"
                $0.streetPlaceholder = "Street1"
                $0.statePlaceholder = "Street2"
                $0.postalCodePlaceholder = "ZipCode"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "State"
                $0.value = PostalAddress(street: currentAccount().address1, state: currentAccount().address2, postalCode: currentAccount().zipcode, city: currentAccount().city, country: currentAccount().state)
            }
        +++ Section()
            <<< ButtonRow("submit") {
                $0.title="Submit"
                }.onCellSelection({ [weak self] (row,cell) in
                    self!.updateValues()
                })
        
    }
    private func updateValues() {
        var values = form.values()
        values["email"] = currentAccount().email
        switch Account.instance(values) {
        case .Error(let field,let message):
            notification_top.showNotification(field, body: message, onTap: { (Void) in
                
            })
        case .Ok(let account):
            try! currentRealm().write({
                currentAccount().copyfrom(account)
            })
            updateAccount().responseObject(completionHandler: { (response:Response<Account,NSError>) in
                switch response.result {
                case .Failure:
                    notification_top.showNotification("Update account error", body: "Please check your network,and try it again", onTap: nil)
                case .Success:
                    break
                }
            })
            self.navigationController?.popViewControllerAnimated(true)
            
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
