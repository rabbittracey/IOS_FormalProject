//
//  ImmunizationsTableViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/23.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire

class ImmunizationsTableViewController: BaseTableViewController {
    var token : RLMNotificationToken? = nil
    var results : Results<Patient_Immunizations>!
    
	
	@IBAction func onAddNew(sender: AnyObject) {
        self.performSegueWithIdentifier("ImmunizationDetailSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        results = currentRealm().objects(Patient_Immunizations.self).filter("is_archived==false")
        token = results.addNotificationBlock({ [ weak self ] in
            switch $0 {
            case .Initial,.Update:
                self?.tableView.reloadData()
                break
            case .Error:
                print("Error")
                break
            }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImmunizationListCell",forIndexPath: indexPath) as! ImmunizationListCell
        cell.updateUI(self.results[indexPath.row])
//        cell.textLabel?.text = self.results[indexPath.row].name
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ImmunizationDetailSegue", sender: self.results[indexPath.row])
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let immunization = (sender as? Patient_Immunizations) ?? Patient_Immunizations()
        if let destine = segue.destinationViewController as? ImmunizationDetailViewController {
            destine.immunization = immunization
        }
    }
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {
			try! currentRealm().write {
				self.results[indexPath.row].is_archived = true
			}
		}
	}


}
