//
//  Models.swift
//  MyRX
//
//  Created by EagleForce on 16/2/25.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Eureka

public enum WeekDay : Int {
    case Sun=0,Mon,Tue,Wed,Thu,Fri,Sat,Not
    
    var description : String {
        return WeekDay.DESCRIPTIONS[rawValue]
    }
    var desc : String {
        return WeekDay.DESCS[rawValue]
    }
    static var DESCRIPTIONS : [ String ] = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    static var DESCS : [String] = {
        var ret:[String] = []
        for var d in WeekDay.DESCRIPTIONS {
            ret.append(d[0...2])
        }
        return ret
    }()
}

public enum Month : Int {
    case Jan = 0 , Feb , Mar , Apr , May , Jun , Jul , Aug , Sep , Oct , Nov , Dec
    var description : String {
        return Month.DESCRIPTIONS[rawValue]
    }
    var desc : String {
        return Month.DESCS[rawValue]
    }
    static var DESCRIPTIONS : [String] = ["January" , "February" , "March" , "April" , "May" , "June" , "July" , "August" , "September" , "October" , "November" , "December"]
    static var DESCS : [String] = {
        var ret:[String] = []
        for var d in Month.DESCRIPTIONS {
            ret.append(d[0...2])
        }
        return ret
    }()
}

public enum APM : Int {
    case AM = 0 , PM
    var description : String {
        return APM.DESCRIPTIONS[rawValue]
    }
    static var DESCRIPTIONS : [ String ] = [ "AM","PM" ]
}

public enum FUNIT : Int {
    case Daily=0, Weekly
    
    var description : String {
        return FUNIT.DESCRIPTIONS[rawValue]
    }
    static var DESCRIPTIONS : [String] = [ "Daily" ,"Weekly"]
}

struct SeqDictionary<K : Hashable,V> {
    var array : [(K,V)]!
    var  dict : [K:V] {
        var ret=[K:V]()
        for (key,value) in self.array {
            ret[key] = value
        }
        return ret
    }
    init() {
        self.array = []
    }
    init(array:[(K,V)]) {
        self.array = array
    }
    init(items:(K,V)...) {
        self.init(array:items)
    }
    mutating func append(item:(K,V)) {
        array.append(item)
    }
    mutating func append(value:V,forKey key:K) {
        array.append((key,value))
    }
    subscript(key:K) -> V {
        get {
            for (_key,value) in self.array {
                if key == _key {
                    return value
                }
            }
            assert(false,"Index out of range")
        }
        set {
            if array.count > 0 {
                for index in (0...self.array.count-1) {
                    if self.array[index].0 == key {
                        self.array[index] = (key,newValue)
                        return
                    }
                }
                
            }
            array.append((key,newValue))
        }
    }
}

// -------- 
public class CombineTransform<F:TransformType,S:TransformType where F.JSON == S.Object> : TransformType {
    public typealias Object = F.Object
    public typealias JSON = S.JSON
    private var first:F
    private var second:S
    
    public init(first:F,second:S) {
        self.first = first
        self.second = second
    }
    public func transformFromJSON(value: AnyObject?) -> Object? {
        return first.transformFromJSON(second.transformFromJSON(value) as? AnyObject)
    }
    public func transformToJSON(value: Object?) -> JSON? {
        return second.transformToJSON(first.transformToJSON(value))
    }
    
}

public class Int64Transform : TransformType {
    public typealias Object = Int64
    public typealias JSON = NSNumber
    
    public func transformFromJSON(value: AnyObject?) -> Object? {
        return (value as? JSON)?.longLongValue
    }
    public func transformToJSON(value: Object?) -> JSON? {
        guard let value = value else {
            return nil
        }
        return NSNumber(longLong: value)
    }
    
}

public class MDObjectIDTransform : TransformType {
	public typealias Object = Int64
	public typealias JSON = NSNumber
	
	public func transformFromJSON(value: AnyObject?) -> Object? {
		return (value as? JSON)?.longLongValue
	}
	public func transformToJSON(value: Object?) -> JSON? {
		guard let value = value else {
			return nil
		}
		if ( value > ID_THRESHOLD ) {
			return NSNumber(longLong: -1)
		}
		return NSNumber(longLong: value)
	}
	
}

class MDObject : Object {
    dynamic var id:Int64 = 0
    dynamic var pending = true

    dynamic var version: Int64 = 0
    dynamic var is_archived: Bool = false
    dynamic var batch_id: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    func save() {
        
    }
}

protocol MDMappable : Mappable {
    func exclude() -> [String]?
    func mdmap(map:Map)
}
extension MDMappable where Self : MDObject {
    final func mapping(map:Map) {
        //-----------------------------
        var opened = false
        if let realm = self.realm where !realm.inWriteTransaction {
            realm.beginWrite()
            opened = true
        }
        defer {
            if opened {
                map.mappingType == .FromJSON ? try! self.realm?.commitWrite() : self.realm?.cancelWrite()
            }
        }
        //-----------------------------
        if map.mappingType == .ToJSON {
            var id = self.id
            id <- (map["id"],MDObjectIDTransform())
        }
        else {
            id <- (map["id"],MDObjectIDTransform())
        }
        //id <- map["id"] //,Int64Transform())
        version <- (map["version"],Int64Transform())
        is_archived <- map["is_archived"]
        pending = false
        
        let bases = ["id","version","is_archived","pending"]
        let dateFormatter = DateFormatterTransform(dateFormatter: DATEFORMAT)
        //        let properties = self.objectSchema.properties.map { $0.name }
        //        let context : MDContext? = map.context as? MDContext
        self.objectSchema.properties.forEach { (prop) in
            if bases.contains(prop.name) {
                return
            }
            guard let exc = exclude() where exc.contains(prop.name) else {
                return
            }
            
            if self[prop.name] is NSDate? || self[prop.name] is NSDate {
                if map.mappingType == .ToJSON {
                    var date = self[prop.name] as? NSDate
                    date <- (map[prop.name],dateFormatter)
                }
                else {
                    var date:NSDate?
                    date <- (map[prop.name],dateFormatter)
                    if let date = date {
                        setValue(date, forKey: prop.name)
                    } else if self[prop.name] is NSDate? {
                        setValue(nil,forKey: prop.name)
                    }
                }
            } else if let _ = self[prop.name] as? Object {
                
            } else if let _ = self[prop.name] as? ListBase {
                
            }
            else {
                self[prop.name] <- map[prop.name]
            }
        }
        self.mdmap(map)
    }
    func exclude() -> [String]? {
        return nil
    }
    final func mapping<T:MDObject where T : MDMappable>(map:Map,inout _ left: T?) {
        if ( map.mappingType == .ToJSON ) {
            if ( self.id > ID_THRESHOLD ) {
                var data = left
                data <- map
            }
        } else {
            var data:Int64?
            data <- map
            if let data = data {
                currentRealm().objectForPrimaryKey(T.self, key: NSNumber(longLong: data))
            }
        }
    }
}

enum ModelResult<T:Object where T : MDMappable> {
    case Ok(T)
    case Error(field:String,message:String)
}

class PackDatas<T:MDObject where T : MDMappable> : Mappable {
	var isContinue = false
	var datas : [T]?
	required convenience init?(_ map: Map) {
		self.init()
	}
	static func valid(map: Map) throws {
		
	}
	func mapping(map:Map) {
		isContinue <- map["continue"]
		datas <- map["datas"]
	}
}

