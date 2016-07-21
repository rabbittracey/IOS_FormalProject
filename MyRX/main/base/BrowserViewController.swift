//
//  BrowserViewController.swift
//  MyRX
//
//  Created by yaowei on 16/6/29.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class BrowserViewController: BaseViewController , UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var target : NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.hidden = true
        webView.delegate = self
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
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        return true
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        
    }

}
