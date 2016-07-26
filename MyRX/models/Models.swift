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

class MDObject : Object {
    dynamic var cid = 0
    dynamic var id = 0
    dynamic var pending = true

    dynamic var version: Int64 = 0
    dynamic var is_archived: Bool = false
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

protocol MDMappable : Mappable {
    func mdmap(map:Map)
}
extension MDMappable where Self : MDObject {
    final func mapping(map:Map) {
        var opened = false
        if let realm = self.realm where !realm.inWriteTransaction {
            realm.beginWrite()
            opened = true
        }
        defer { if opened { map.mappingType == .FromJSON ? try! self.realm?.commitWrite() : self.realm?.cancelWrite() } }
        id <- map["id"]
        version <- map["version"]
        is_archived <- map["is_archived"]
        pending = false
        self.mdmap(map)
    }
    
}

enum ModelResult<T:Object where T : MDMappable> {
    case Ok(T)
    case Error(field:String,message:String)
}
