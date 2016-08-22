//
//  SearchDrugViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class SearchDrugViewController: UIViewController , UITextFieldDelegate , NSURLConnectionDataDelegate , UITableViewDataSource , UITableViewDelegate {
    private var httpConnect:NSURLConnection?
    private var tipNames:[String]?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tipNamesTableView: UITableView!

    private static let drugQueue = dispatch_queue_create("com.eagleforce.drug", nil)
    
    private func clearTips() {
        tipNames = nil
        tipNamesTableView.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        clearTips()
        tipNamesTableView.delegate = self
        tipNamesTableView.dataSource = self
        nameTextField.becomeFirstResponder()
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("-" + textField.text!)
    }

    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("Clear")
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Enter")
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
       var text = ""
        if let _text = textField.text {
            text = _text
            text.replaceRange(text.rangeFromNSRange(range)!, with: string)
        } else {
            text = string
        }
        if let conn = self.httpConnect {
            conn.cancel()
        }
        self.clearTips()

        if text.characters.count > 0 {
            dispatch_async(SearchDrugViewController.drugQueue) { () -> Void in
                var ret = [String]()
                let _text = text.lowercaseString
                for name in DrugNames {
                    let _name = name.lowercaseString
                    if _name.hasPrefix(_text) {
                        ret.append(name)
                        if ret.count >= 10 { break }
                    }
                }
                if ret.count < 5 {
                    for name in DrugNames {
                        let _name = name.lowercaseString
                        if _name.containsString(_text) {
                            ret.append(name)
                            if ret.count >= 10 { break }
                        }
                    }
                    
                }
                if ret.count > 0 {
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.setTipNames(ret)
                    })
                }
            }
            
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(SERVER_URL)/tipsDrugName/" + text)!)
//            request.HTTPMethod = "GET"
//            self.httpConnect = NSURLConnection(request: request, delegate: self)
        }
        return true
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.httpConnect = nil
        setTipNames(NSString(data: data, encoding: NSUTF8StringEncoding)?.componentsSeparatedByString("\n"))
    }
    func setTipNames(tipNames:[String]?) {
        self.tipNames = tipNames
        if self.tipNames?.count > 0 {
            self.tipNamesTableView.hidden = false
            self.tipNamesTableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.tipNames {
            return data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = self.tipNames![indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let parent = self.parentViewController as? AddDrugViewController {
            parent.drugName = tipNames![indexPath.row]
            nameTextField.resignFirstResponder()
            self.dismissViewControllerFromParentController()
		} else if let parent = self.parentViewController as? MedicationDetailViewController {
//			parent.patient_medication?.name = tipNames![indexPath.row]
			parent.updateMedicationName( tipNames![indexPath.row])
			self.dismissViewControllerFromParentController()
		}
    }

}
