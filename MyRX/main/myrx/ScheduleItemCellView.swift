//
//  ScheduleItemCellView.swift
//  rx
//
//  Created by EagleForce on 16/2/9.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

protocol ScheduleItemCell {
    func initWithModel(model: ScheduleItemModel,isSelected:Bool)
}
class NumberItemCell : UITableViewCell , ScheduleItemCell,UITextFieldDelegate {
    var model:ScheduleItemModel!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var value_textfield: UITextField!
    @IBOutlet weak var value_line: UIView!
    func initWithModel(model:ScheduleItemModel,isSelected:Bool) {
        self.model = model
        title_label.text = model.title
        if isSelected {
            value_textfield.text = "\(model.count)"
            value_textfield.delegate = self
            value_textfield.becomeFirstResponder()
        } else {
            value_label.text = model.toString()
        }
        value_label.hidden = isSelected
        value_textfield.hidden = !isSelected
        value_line.hidden = !isSelected
        
    }
    var contentViewOffset : CGFloat = 0
    weak var _contentView:UIView?
    // textfield
    func textFieldDidBeginEditing(textField: UITextField) {
        if let cview = self.firstAvailableUIViewController()?.view {
            let origin = textField.offsetByParentView(cview)
            let frame = cview.frame
            let offset = frame.size.height - origin.y
            if -216 + offset - textField.frame.size.height < 0 {
                contentViewOffset = -216 + offset - value_textfield.frame.size.height
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    cview.frame = CGRectOffset(frame, 0, self.contentViewOffset)
                })
                
            }
            _contentView = cview
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let cview = _contentView {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cview.frame = CGRectOffset(cview.frame, 0, -self.contentViewOffset)
            })
            contentViewOffset = 0
            
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var text = ""
        if let _text = textField.text {
            text = _text
            text.replaceRange(text.rangeFromNSRange(range)!, with: string)
        } else {
            text = string
        }
        model.count=Int(text) ?? 0
        return true
    }

}
class PickerItemCell : UITableViewCell , ScheduleItemCell, MDPickerViewDelegate {
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var value_label: UILabel!
    @IBOutlet weak var data_pickerView: MDPickerView!
    
    var model:PickerItemModel!
    func initWithModel(model:ScheduleItemModel,isSelected:Bool) {
        self.model = model as! PickerItemModel
        
        if isSelected {
            data_pickerView.datasource = self.model.datasource
            data_pickerView.reloadAllComponents()
            data_pickerView.value = model.values
            data_pickerView.md_delegate = self
        }
        data_pickerView.hidden = !isSelected
        title_label.text = model.title
        value_label.text = model.toString()
    }
    func pickerView(pickerView: MDPickerView, didSelectRow row: Int, inComponent component: Int, andValue value:[Int]) {
        model.values = value
        value_label.text = model.toString()
    }
    
}
