//
//  FeelingTodayViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/3/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class FeelingTodayViewController: HomeTableViewCellViewController {
    @IBOutlet weak var face0: MDSwipeImageView!
    @IBOutlet weak var face1: MDSwipeImageView!
    @IBOutlet weak var face2: MDSwipeImageView!
    @IBOutlet weak var face3: MDSwipeImageView!
    @IBOutlet weak var face4: MDSwipeImageView!
    @IBOutlet weak var note: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var uparrow: UIImageView!

    private enum ViewType {
        case NOMSG ,MSG
    }
    
    private var viewType : ViewType = .NOMSG
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.hidden = true
        cellHeight = 160
        update()
    }

    func update() {
        if viewType == .NOMSG {
            textView.hidden = true
            note.hidden = false
            uparrow.hidden = true
            textView.resignFirstResponder()
        } else {
            textView.hidden = false
            note.hidden = true
            uparrow.hidden = false
            textView.becomeFirstResponder()
        }
    }
    @IBAction func onFaceClick(sender: UITapGestureRecognizer) {
        face0.value = ( face0 == sender.view )
        face1.value = ( face1 == sender.view )
        face2.value = ( face2 == sender.view )
        face3.value = ( face3 == sender.view )
        face4.value = ( face4 == sender.view )

    }
    @IBAction func onUparrowClick(sender: UITapGestureRecognizer) {
        viewType = .NOMSG
        cellHeight = 160
        update()
        updateTableViewCell()
    }
    @IBAction func onTxtClick(sender: UITapGestureRecognizer) {
        viewType = .MSG
        cellHeight = 240
        update()
        updateTableViewCell()
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
