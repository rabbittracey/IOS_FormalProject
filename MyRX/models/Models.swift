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
    dynamic var id = 0
    dynamic var pending = true
    
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
        pending = false
        self.mdmap(map)
    }
    
}
<<<<<<< HEAD

enum ModelResult<T:Object where T : MDMappable> {
    case Ok(T)
    case Error(field:String,message:String)
}
//enum MDMapError : ErrorType {
//    case ModelError
//    case ModelFieldError(field:String)
//}
//
//enum ModelResult<T:MDMappable> {
//    case Ok(T)
//    case Error(MDMapError)
//}
//
//infix operator =~ {}
//
//func =~ (left:Map,right:String) throws {
//    guard left.mappingType == .FromJSON else {
//        return
//    }
//    if let value:String = left.value() where value.match(right) == false {
//        throw MDMapError(field: left.key() ?? "unknow")
//    }
//}
//
//func MDMapper<T:MDMappable>(context:MapContext,JSONDictionary:[String : AnyObject]) -> ModelResult<T> {
////    do {
////        try T.valid(
////    } case MDMapError(let error) {
////        
////    }
//    let map = Map(mappingType: .FromJSON, JSONDictionary: JSONDictionary, context: context)
//    do {
//        try T.valid(map)
//    } catch is MDMapError {
//        
//    }
//    // check if objectForMapping returns an object for mapping
//    if var object = T.self.objectForMapping(map) as? T {
//        object.mapping(map)
//        return object
//    }
//    
//    // fall back to using init? to create N
//    if var object = N(map) {
//        object.mapping(map)
//        return object
//    }
//    
//    return nil
//
//    if let result = Mapper<T>(context:context).map(value) {
//        return ModelResult.Ok(result)
//    }
//    return ModelResult.Error(MDMapError(field: "\(T.self)"))
//}
//
//public func <-- <lhs>(inout left: lhs, right : (Map,String?) ) {
//    let (map , _) = right
//    left <- map
//}
//
//public func <-- <lhs,Transform: TransformType where lhs >(inout left: lhs, right : ((Map,Transform),String?) ) {
//    let (map , _) = right
////    left <- map
//}

//public func <-- <lhs>(inout left: lhs?, right : (Map,String?) ) throws {
//    let (map , _) = right
//    left <- map
//}

=======
>>>>>>> 49d21ff4e79bef2f25573323b011f181f2ca864b
