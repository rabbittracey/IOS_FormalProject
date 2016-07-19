//
//  LinkRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation
import Eureka
// MARK: LinkCell

public class LinkCellOf<T: Equatable>: Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .None : .Default
        accessoryType = .None
        editingAccessoryType = accessoryType
        textLabel?.textAlignment = .Center
        textLabel?.textColor = tintColor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        textLabel?.textColor  = UIColor(red: red, green: green, blue: blue, alpha: row.isDisabled ? 0.3 : 1.0)
    }
    
    public override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

public typealias LinkCell = LinkCellOf<String>


//MARK: LinkRow

public class _LinkRowOf<T: Equatable> : Row<T, LinkCellOf<T>> {
//    public var presentationMode: PresentationMode<UIViewController>?
    public var linkUrl:String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellStyle = .Default
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            if let linkUrl = linkUrl {
                UIApplication.sharedApplication().openURL(NSURL(string: linkUrl)!)
            }
        }
    }
    
    public override func customUpdateCell() {
        super.customUpdateCell()
        cell.textLabel?.textAlignment = .Left
        cell.accessoryType = isDisabled ? .None : .DisclosureIndicator
        cell.editingAccessoryType = cell.accessoryType
        cell.textLabel?.textColor = nil
    }
}

/// A generic row with a Link. The action of this Link can be anything but normally will push a new view controller
public final class LinkRowOf<T: Equatable> : _LinkRowOf<T>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A row with a Link and String value. The action of this Link can be anything but normally will push a new view controller
public typealias LinkRow = LinkRowOf<String>
