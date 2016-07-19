//
//  FaceCell.swift
//  MyRX
//
//  Created by yaowei on 16/7/7.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class FaceCell: Cell<String>, CellType {

    @IBOutlet weak var iconView: UIImageView!
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        iconView.layer.cornerRadius = 10.0
//    }
    override func setup() {
        height = { 120 }
        row.title = nil
        iconView.layer.borderColor = UIColor.whiteColor().CGColor
        iconView.clipsToBounds = true
        iconView.layer.borderWidth = 3.0
        iconView.layer.cornerRadius = iconView.frame.size.width / 2

        super.setup()
        selectionStyle = .None
    }
    override func update() {
        row.title = nil
        super.update()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

final class FaceRow: Row<String, FaceCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<FaceCell>(nibName: "FaceCell")
    }
}

