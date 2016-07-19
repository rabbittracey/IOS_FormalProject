//
//  MDPickerView.swift
//  MyRX
//
//  Created by EagleForce on 16/2/26.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

protocol MDPickerViewDelegate {
    func pickerView(pickerView: MDPickerView, didSelectRow row: Int, inComponent component: Int, andValue value:[Int]);
}
class MDPickerView : UIPickerView, UIPickerViewDataSource,UIPickerViewDelegate {
    var datasource : [[String]]?
    var md_delegate : MDPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        _init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    private func _init() {
        self.delegate = self
        self.dataSource = self
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return datasource?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource?[component].count ?? 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource?[component][row] ?? "-"
    }
    
    var value : [Int]? {
        get {
            var ret : [Int] = []
            if let datas = datasource {
                for i in 0...datas.count-1 {
                    ret.append(self.selectedRowInComponent(i))
                }
            }
            return ret.count > 0 ? ret : nil
        }
        set {
            if let datas = datasource {
                for i in 0...datas.count-1 {
                    if let value = newValue where value.count > i {
                        self.selectRow(value[i], inComponent: i, animated: false)
                    }
                    else {
                        self.selectRow(0, inComponent: i, animated: false)
                    }
                }
            }
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        md_delegate?.pickerView(self, didSelectRow: row, inComponent: component,andValue: self.value!)
    }
}
