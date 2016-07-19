//
//  AboutUsViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/29.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class AboutUsViewController: BaseFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("Eagleforce Inc.")
            <<< ButtonRow() {
                $0.title = "Company Overview"
                $0.value = "companyOverview"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Code of Conduct"
                $0.value = "codeofConduct"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Corporate Governance"
                $0.value = "corporateGovernance"
               $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Corporate Responsibility"
                $0.value = "corporateResponsibility"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Diversity"
                $0.value = "diversity"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Employee Ownership"
                $0.value = "employeeOwership"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
            <<< ButtonRow() {
                $0.title = "Management Team"
                $0.value = "managementTeam"
                $0.presentationMode = .SegueName(segueName: "AboutUsWebViewControllerSegue",completionCallback:nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let buttonRow = sender as? ButtonRow {
            if let brower = segue.destinationViewController as? BrowserViewController {
                brower.target = NSBundle.mainBundle().URLForResource(buttonRow.value, withExtension: ".html")
            }
        }
    }


}
