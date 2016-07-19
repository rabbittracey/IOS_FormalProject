//
//  MessageViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit


class MessageViewController: BaseViewController , UIWebViewDelegate {
    @IBOutlet weak var contentView: MDScrollView!
    @IBOutlet weak var act_indicator: UIActivityIndicatorView!
    var webView:UIWebView!
    private var message:Message!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func updateWithData(message:Message) {
        self.message = message
        self.message.unread = false
        webView = UIWebView(frame: CGRectMake(0,0,320,240))
        
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("message", withExtension: "html")!))
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString("setContent(\"" + self.message.title + "\",\"" + BODIES.random() + "\");")
        let sh:NSString = webView.stringByEvaluatingJavaScriptFromString("bodyHeight()")!
        contentView.addContentView(webView,height: sh.floatValue * 1.1)
        act_indicator.stopAnimating()
    }
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
}
