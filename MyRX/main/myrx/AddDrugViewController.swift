//
//  AddDrugViewController.swift
//  rx
//
//  Created by EagleForce on 16/2/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit

class AddDrugViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITableViewDataSource , UITableViewDelegate {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var hidenImageSourceView: UITapGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var imageSourceView: UIView!
    @IBOutlet var labelDrugname: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var __drugName:String = ""
    
    private var itemModels:[ScheduleItemModel] = []
    private var lastFrequency:Int = Int.max
    private var quantity : NumberItemModel!
    private var dose : NumberItemModel!
    private var frequency : FrequencyItemModel!
    private var reminders : [ ReminderItemModel ] = []
    private var selectItem:NSIndexPath?
    
    var drugName:String {
        get {
            return __drugName
        }
        set {
            if newValue.characters.count > 0 {
                labelDrugname.text = newValue
                labelDrugname.textColor = UIColor(white: 0.7, alpha: 1)
                
                tableView.hidden = false
                navigationItem.prompt = nil
                // model
                quantity = NumberItemModel(title: "Quantity" , count: 30, unit: DRUG_UNIT)
                dose = NumberItemModel(title: "Dose", count: 1, unit: DRUG_UNIT)
                frequency = FrequencyItemModel(times: 1 , funit: .Daily )
                setSelectItem(nil)
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(AddDrugViewController.onSave(_:)))

            } else {
                labelDrugname.text = "Tap to input"
                labelDrugname.textColor = UIColor(white: 0.3, alpha: 1)
                tableView.hidden = true
                lastFrequency = Int.max
            }
            __drugName = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddDrugViewController.onGoback(_:)))
        tableView.hidden = true
    }
    func onSave(sender:AnyObject) {
        if self.quantity.count < self.dose.count {
            navigationItem.prompt = "Quantity must greater than Dose"
            return
        }
        navigationItem.prompt = "Saving ....."
        
        let reminder:Reminder = Reminder(drugName: self.drugName, quantity: self.quantity.count, dose: self.dose.count, reminders: self.reminders)
        reminder.image = self.imageView.image
        User.current.reminders.append(reminder)
        User.save()
        goback(self)
        
    }
    func onGoback(sender:AnyObject) {
        self.goback(sender)
    }
    @IBAction func takeAPhoto(sender: AnyObject) {
        setSelectItem(nil)
        var frame = CGRectMake(72, 8, 1, 1)
        imageSourceView.frame = frame
        imageSourceView.center = imageView.center
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            frame.size = CGSizeMake(252,198)
            self.imageSourceView.frame = frame
            }, completion: { (Bool) -> Void in
                self.hidenImageSourceView.enabled = true
                
        })
        
        view.addSubview(imageSourceView)
        
    }
    @IBAction func takeDrugName(sender: AnyObject) {
        setSelectItem(nil)
        self.insertViewControllerWithId("SearchDrug", inView: view)
    }
    func takePhoto() {
    }
    private func showImagePickerController(type:UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        presentViewController(imagePicker,animated: true , completion: nil )
        
    }
    @IBAction func takePhotoFromCamera(sender: AnyObject) {
        ImageSourceCancel(sender)
        showImagePickerController(.Camera)
    }
    @IBAction func takePhotoFromAlbum(sender: AnyObject) {
        ImageSourceCancel(sender)
        showImagePickerController(.PhotoLibrary)
    }
    @IBAction func ImageSourceCancel(sender: AnyObject) {
        if view.subviews.contains(self.imageSourceView) {
            imageSourceView.removeFromSuperview()
        }
        hidenImageSourceView.enabled = false
        setSelectItem(nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // schedule item
    func setSelectItem(indexPath:NSIndexPath?) {
        if tableView.hidden {
            return
        }
        var updateIndexes: [NSIndexPath] = []
        if let selected = selectItem {
            if selected == indexPath {
                selectItem = nil
            } else {
                selectItem = indexPath
                updateIndexes.append(selected)
            }
        } else {
            selectItem = indexPath
        }
        if frequency.count != lastFrequency {
            let values = frequency.values
            reminders = []
            if FUNIT(rawValue: values[1]) == .Daily {
                (values[0]+1).forEach({ (index:Int, total:Int) in
                    let (hour , apm) = DailyReminder[index].toAPM()
                    reminders.append(DailyReminderItemModel(hour: hour, tenMinute: 0, apm: apm)!)
               })
            } else {
                let (hour , apm) = DailyReminder[0].toAPM()
                (values[0]+1).forEach({ (index:Int, total:Int) in
                    reminders.append(WeeklyReminderItemModel(weekday: WeekDay(rawValue: WeeklyReminder[index])!, hour: hour, tenMinute: 0, apm: apm)!)
               })
            }
            reminders.sortInPlace({ $0.count < $1.count })
            itemModels = [ quantity , dose , frequency ] + reminders
            tableView.reloadData()
            lastFrequency = frequency.count
            return
        }
        
        if let selected = indexPath {
            updateIndexes.append(selected)
        }
        tableView.reloadRowsAtIndexPaths(updateIndexes, withRowAnimation: .Automatic)
        if selectItem == nil {
            self.view.endEditing(true)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = itemModels[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(model.type + "Cell", forIndexPath: indexPath)
        if let itemCell = cell as? ScheduleItemCell {
            itemCell.initWithModel(model, isSelected: selectItem==indexPath)
        }
        
        return cell
    }
    
    // tableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        setSelectItem(indexPath)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath != selectItem {
            return 50
        }
        switch itemModels[indexPath.row] {
        case _ as PickerItemModel:
            return 120
        default:
            return 50
        }
    }
    
    
}
