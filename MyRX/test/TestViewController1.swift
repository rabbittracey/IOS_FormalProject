//
//  TestViewController1.swift
//  MyRX
//
//  Created by EagleForce on 16/3/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class TestViewController1: UIViewController {
    var index:Int = 0
    @IBOutlet weak var label:UILabel!
    
    @IBOutlet weak var mmm: MDGrayImageView!
    @IBAction func onClick(sender: AnyObject) {
        mmm.notColor = !mmm.notColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = "\(index)"
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
