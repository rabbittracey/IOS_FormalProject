//
//  BrowserViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/29.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class BrowserViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var target : NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.hidden = true
        
        webView.loadRequest(NSURLRequest(URL:target))
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
