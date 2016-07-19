//
//  MyrxViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class MyrxViewController: BaseTableViewController {
    
    private var objVersion = -1
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if objVersion != User.current.objVersion {
            tableView.reloadData()
            objVersion = User.current.objVersion
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addDrug(sender:AnyObject) {
        self.performSegueWithIdentifier("AddDrug", sender: self)
    }
    //TableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objVersion = User.current.objVersion
        return User.current.reminders.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! MyRxTableViewCell
        cell.updateWithData(User.current.reminders[indexPath.row])
        cell.setNeedsLayout()
        return cell
    }
    func update() {
        tableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            if let rxdetail = segue.destinationViewController as? RxDetailViewController {
                rxdetail.reminder = User.current.reminders[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

}
