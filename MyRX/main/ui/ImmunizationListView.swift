//
//  FaceCell.swift
//  MyRX
//
//  Created by yaowei on 16/7/7.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka

class ImmunizationListCell: Cell<Immunization>, CellType {
    
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var title: UILabel!
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        iconView.layer.cornerRadius = 10.0
    //    }
    override func setup() {
        height = { 120 }
        row.title = nil
        title.text = row.value?.name
        super.setup()
        selectionStyle = .None
    }
    override func update() {
        row.title = nil
        title.text = row.value?.name
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

final class ImmunizationListRow: Row<Immunization, ImmunizationListCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<ImmunizationListCell>(nibName: "ImmunizationListView")
    }
}

