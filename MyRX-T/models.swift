//
//  models.swift
//  MyRX
//
//  Created by yaowei on 16/8/18.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Alamofire
import Realm
import RealmSwift
import ObjectMapper


extension String {
    func dateFormatter() -> NSDateFormatter {
        let format = NSDateFormatter()
        format.dateFormat = self
        return format
    }

}
let DATEFORMAT = "yyyy-MM-dd".dateFormatter()
let DATETIMEFORMAT = "yyyy-MM-dd HH:mm:ss".dateFormatter()
let TIMEFORMAT = "HH:mm:ss".dateFormatter()

//class MObject : Object {
//    dynamic var id = 0
//    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
//}
//extension Object {
//    func toDictionary(aa:Int) -> NSDictionary {
//        let properties = self.objectSchema.properties.map { $0.name }
//        let dictionary = self.dictionaryWithValuesForKeys(properties)
//        
//        let mutabledic = NSMutableDictionary()
//        mutabledic.setValuesForKeysWithDictionary(dictionary)
//        
//        for prop in self.objectSchema.properties as [Property]! {
//            // find lists
//            if let nestedObject = self[prop.name] as? Object {
//                mutabledic.setValue(nestedObject.toDictionary(3), forKey: prop.name)
//            } else if let nestedListObject = self[prop.name] as? ListBase {
//                var objects = [AnyObject]()
//                for index in 0..<nestedListObject._rlmArray.count  {
//                    let object = nestedListObject._rlmArray[index] as AnyObject
//                    objects.append(object.toDictionary(3))
//                }
//                mutabledic.setObject(objects, forKey: prop.name)
//            }
//            
//        }
//        return mutabledic
//    }
//    
//}
//extension Object {
//    func toDictionary(inout store:Set<Object>) -> NSDictionary {
//        let properties = self.objectSchema.properties.map { $0.name }
//        let dictionary = self.dictionaryWithValuesForKeys(properties)
//        var circles:Set<Object>!
////        print(NSString(data:try! NSJSONSerialization.dataWithJSONObject(dictionary, options: .PrettyPrinted),encoding: NSUTF8StringEncoding))
//        store.insert(self)
//        let mutabledic = NSMutableDictionary()
//        mutabledic.setValuesForKeysWithDictionary(dictionary)
//        
//        for prop in self.objectSchema.properties as [Property]! {
//            // find lists
//            if let nestedObject = self[prop.name] as? Object where circles.contains(nestedObject) == false {
//                mutabledic.setValue(nestedObject.toDictionary(&store), forKey: prop.name)
//            } else if let nestedListObject = self[prop.name] as? ListBase {
//                var objects = [NSDictionary]()
//                for index in 0..<nestedListObject._rlmArray.count  {
//                    if let object = nestedListObject._rlmArray[index] as? AnyObject {
//                        objects.append(object.toDictionary(&store))
//                    }
//                    
//                }
//                mutabledic.setObject(objects, forKey: prop.name)
//            }
//            
//        }
//        return mutabledic
//    }
//    
//}
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
        if ( value > 0x100000000 ) {
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
//            if let nestedObject = self[prop.name] as? Object {
//                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
//            } else if let nestedListObject = self[prop.name] as? ListBase {
//                var objects = [AnyObject]()
//                for index in 0..<nestedListObject._rlmArray.count  {
//                    let object = nestedListObject._rlmArray[index] as AnyObject
//                    objects.append(object.toDictionary())
//                }
//                mutabledic.setObject(objects, forKey: prop.name)
//            }
//            if self[prop.name] is NSDate {
//                if var date = self[prop.name] as? NSDate {
//                    date <- (map[prop.name],dateFormatter)
//                    if map.mappingType == .FromJSON {
//                        date <- (map[prop.name],dateFormatter)
//                    } else {
//                        date <-
//                    }
//                }
//                self[prop.name] <- (map[prop.name],)
//            } else {
//                self[prop.name] <- map[prop.name]
//            }
        }
        self.mdmap(map)
    }
    func exclude() -> [String]? {
        return nil
    }
}
enum MDContext : MapContext {
    case exclude([String])
    case include([String])
    case excludeObject([String]?)
    case includeObject([String]?)
}
class Dog: MDObject , MDMappable {
    dynamic var name = ""
    dynamic var owner: Person? // Properties can be optional
//    let owners = LinkingObjects(fromType: Person.self, property: "dogs")
    required convenience init?(_ map: Map) {
        self.init()
    }
    func mdmap(map: Map) {
        name <- map["name"]
    }
}

// Person model
class Person: MDObject , MDMappable {
    dynamic var name = ""
    dynamic var birthdate:NSDate?
    let dogs = List<Dog>()
    required convenience init?(_ map: Map) {
        self.init()
    }
    func mdmap(map: Map) {
//        name <- map["name"]
//        birthdate <- (map["birthdate"],DateFormatterTransform(dateFormatter: DATEFORMAT))
//        dogs <- map["dogs"]
    }
}

