//
//  ActivationCodeViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/7.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class ActivationCodeViewController: BaseFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        form +++ Section()
            <<< TextFloatLabelRow("code") {
                $0.title = "Activation Code"
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
