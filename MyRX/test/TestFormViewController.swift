//
//  TestFormViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/7.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class TestFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        form +++ Section("Test")
            <<< FaceRow()
            <<< LabelRow("email") {
                $0.title = "Email"
                $0.value = "elaine@gmail.com"
        }
            <<< ButtonRow() {
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
