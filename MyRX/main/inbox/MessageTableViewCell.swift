//
//  MessageTableViewCell.swift
//  rx
//
//  Created by EagleForce on 16/2/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var lb_abstract:UILabel!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var im_type: UIImageView!
    @IBOutlet weak var im_important: UIImageView!
    @IBOutlet weak var im_unreaded: UIImageView!

    func updateWithData(message:Message) {
        if let abstract = message.abstract {
            lb_abstract.text = "  " + abstract
        }
        lb_title.text = message.title
        im_important.alpha = 1 //message.important ? 1 : 0
        im_unreaded.alpha = message.unread ? 1 : 0
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
}
