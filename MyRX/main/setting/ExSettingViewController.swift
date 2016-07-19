//
//  ExSettingViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/29.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class ExSettingViewController: BaseFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("Alert Setting")
            <<< SwitchRow("alert") {
                $0.title = "Alert Switch"
                $0.value = true
        }
            <<< SwitchRow("sound") {
                $0.title = "Sound Switch"
                $0.hidden = Condition.Function(["alert"], { (form) -> Bool in
                    let row:RowOf<Bool>! = form.rowByTag("alert")
                    return row.value ?? false == false
                })
        }
            <<< SwitchRow("shake") {
                $0.title = "Shake Switch"
                $0.hidden = Condition.Function(["alert"], { (form) -> Bool in
                    let row:RowOf<Bool>! = form.rowByTag("alert")
                    return row.value ?? false == false
                })
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
