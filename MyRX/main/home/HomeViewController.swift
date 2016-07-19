//
//  HomeViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class HomeTableViewCellViewController : BaseViewController {
    weak var parent : HomeViewController!
    var cellHeight:CGFloat = 0
    func updateTableViewCell() {
        parent.tableView.beginUpdates()
        parent.tableView.endUpdates()
    }
}
class HomeTableViewCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.shadowColor = UIColor(white: 0.3, alpha: 1).CGColor
        contentView.layer.shadowOffset = CGSizeMake(0, 2)
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.shadowRadius = 2
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(white: 0.7, alpha: 1).CGColor
        contentView.backgroundColor = UIColor.redColor() //UIColor.clearColor()
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-4-[view]-4-|", options: [], metrics: nil, views: [ "view":contentView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[view]-4-|", options: [], metrics: nil, views: [ "view":contentView]))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addContent(view:UIView) {
        if subviews.contains(view) {
            return
        }
        view.removeFromSuperview()
//        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: [ "view":view ] ))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: [ "view":view ] ))
    }
}
class HomeViewController: BaseTableViewController  {

    private var cellHeights : [ Int:CGFloat ] = [:]
    private var cellVCDatas : [String] = []
    private var cellViews : [Int:HomeTableViewCellViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cellVCDatas = [
            "schedule",
            "feeling",
            "mymedications","homeinbox","homehistory"
//            HomeTableViewCellData(name: "feeling", height: 160,data:0),
//            HomeTableViewCellData(name: "feeling", height: 160,data:0),
//            HomeTableViewCellData(name: "feeling", height: 160,data:0),
//            HomeTableViewCellData(name: "feeling", height: 160,data:0),
//            HomeTableViewCellData(name: "feeling", height: 160,data:0),
        ]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellVCDatas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? HomeTableViewCell
        if cell == nil {
            cell = HomeTableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        var cview = cellViews[indexPath.row]
        if cview == nil {
            cview = storyboard!.instantiateViewControllerWithIdentifier(cellVCDatas[indexPath.row]) as? HomeTableViewCellViewController
            cellViews[indexPath.row] = cview
            cview!.parent = self
            self.addChildViewController(cview!)
            cview?.didMoveToParentViewController(self)
        }
        cell!.addContent(cview!.view)
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let cellView = cellViews[indexPath.row] {
            return cellView.cellHeight
        }
        return 1
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
