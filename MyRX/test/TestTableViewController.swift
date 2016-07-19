//
//  TestTableViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/3/4.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

struct Model {
    let height:CGFloat
    let type:String
    let background:UIColor
}
class TestTableViewController: UITableViewController {
    
    var rows:Int  = 10 ;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        3.forEach {
//            let model = Model(height: CGFloat($0.0*20 + 100), type: "\($0.0)", background: UIColor.random)
//            tableDatas.append(model)
//            
//        }
//        self.tableView.separatorStyle = .None
//        self.tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows + 1
    }
    
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return tableDatas[indexPath.row].height
//    }
//    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("test")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "test")
        }
        if indexPath.row == rows {
            cell?.textLabel?.text = "Load more ... "
            
        }
        else {
            cell?.textLabel?.text = "\(indexPath.row)"
        }
        
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == rows {
            rows += 10;
            tableView.reloadData()
        }
    }
//    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y <= 10.0 {
//            print("----");
//            
//            rows += 10;
//            tableView.reloadData()
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
