//
//  RxDetailViewController.swift
//  MyRX
//
//  Created by EagleForce on 16/2/26.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class RxDetailViewController: BaseViewController,MDTabBarViewDataSource {
    @IBOutlet var chartsView: UIView!
    @IBOutlet var scheduleView: MedScheduleView!
    @IBOutlet weak var contentView: MDTabBarView!
    @IBOutlet weak var lifetimePercentView:MDPercentView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentPercentView: MDPercentView!
    @IBOutlet weak var communityPercentView: MDPercentView!
    @IBOutlet weak var bestMonthPercentView: MDPercentView!
    @IBOutlet weak var drugImageView: UIImageView!
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var remainingLabel: UILabel!
    
    private var contentViews=[MDScrollView]()
    var reminder:Reminder!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.dataSource = self
        contentView.reloadData()
        scheduleView.initWithReminder(reminder)
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(RxDetailViewController.edit(_:)))
        let content = MDScrollView()
        content.addContentView( chartsView )
        contentViews.append(content)
        
        lifetimePercentView.count = 100.random
        currentPercentView.count = 100.random
        communityPercentView.count = 100.random
        bestMonthPercentView.count = 100.random

//        contentViews.append(scheduleView)
        scheduleView.translatesAutoresizingMaskIntoConstraints = false
        let nf = NSDateFormatter()
        nf.dateFormat = "MMM"
        
        currentLabel.text = nf.stringFromDate(NSDate())
        
        drugImageView.layer.cornerRadius = 8
        drugImageView.layer.masksToBounds = true
        if let image = reminder.image {
            drugImageView.image = image
        }
        drugNameLabel.text = reminder.drugName
    }
    func edit(sender:AnyObject) {
        print("---")
    }
    func numberOfItemsInSwipeView(swipeView: MDSwipeView) -> Int {
        return 3
    }
    func tabViewTitleByIndex(index: Int) -> String {
        return ["Charts","Schedule","Alerts"][index]
    }
    func swipeView(swipeView: MDSwipeView, viewForItemAtIndex index: Int, reusingView view: UIView) -> UIView {
        if index == 0 {
            let _view:UIView = contentViews[index]
            _view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(_view)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: ["view" : _view]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view" : _view]))
            
        } else if index == 1 {
            view.addSubview(scheduleView)
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: ["view" : scheduleView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: ["view" : scheduleView]))
            
        }
        else {
            view.insertViewControllerWithId("InboxTable")
        }
        return view
    }

}
