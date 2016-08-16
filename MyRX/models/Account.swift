//
//  Account.swift
//  MyRX
//
//  Created by yaowei on 16/7/8.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Eureka

func currentRealm() -> Realm {
    return cachedThreadLocalObjectWithKey("com.eagleforce.myrx.realm", create: {
//        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
		print(Realm.Configuration.defaultConfiguration.fileURL)
        return try! Realm()
		
    })
    
}
func currentAccount() -> Account {
    return cachedThreadLocalObjectWithKey("com.eagleforce.myrx.account", create: {
        let realm = currentRealm()
        let acc = realm.objects(Account.self)
        if (acc.count == 0) {
            let _acc = Account()
            try! realm.write({
                realm.add(_acc)
            })
            return _acc
        } else if ( acc.count == 1 ) {
            return acc.first!
        }
        try! realm.write {
            ( acc.count - 1 ).forEach({ (index,total) in
                realm.delete(acc[index])
            })
        }
        return acc.last!
    })
}

class Account: MDObject,MDMappable {
    static let email_reg = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
    static let password_reg = "^.{2,}$"
    dynamic var fname:String?
    dynamic var lname:String?
    dynamic var gender:String?
    dynamic var dob:NSDate?
    // ------- address -----------
    dynamic var address1:String?
    dynamic var address2:String?
    dynamic var city:String?
    
    dynamic var state:String?
    dynamic var zipcode:String?
    // ----------------------------
    dynamic var email = ""
    
    dynamic var islogin:Bool = false
    
    dynamic var token = NSUUID().UUIDString
    
    required convenience init?(_ map: Map) {
        self.init()
    }
        
    func mdmap(map:Map) {
        fname <- map["fname"]
        lname <- map["lname"]
        gender <- map["gender"]
        dob <- (map["dob"],DateFormatterTransform(dateFormatter:DATEFORMAT))
        // ------- address -----------
        address1 <- map["address1"]
        address2 <- map["address2"]
        state <- map["state"]
        zipcode <- map["zipcode"]
        city <- map["city"]
        // ----------------------------
        email <- map["email"]
        
    }
    static func instance(values:[String:Any?]) -> ModelResult<Account> {
        let account = Account()
        guard let email = values["email"] as? String where email.match(Account.email_reg) else {
            return .Error(field: "email",message: "Email cannot allow to blank")
        }

        account.email = email
        account.fname = values["fname"] as? String
        account.lname = values["lname"] as? String
        account.gender = values["gender"] as? String
        account.dob = values["dob"] as? NSDate
        if let address = values["address"] as? PostalAddress {
            account.address1 = address.street
            account.address2 = address.state
            account.city = address.city
            account.zipcode = address.postalCode
            account.state = address.country
        } else {
            account.address1 = values["address1"] as? String
            account.address2 = values["address2"] as? String
            account.city = values["city"] as? String
            account.zipcode = values["zipcode"] as? String
            account.state = values["state"] as? String
        }
        return .Ok(account)
    }
    func copyfrom(let account:Account) {
        if self.email != account.email {
            self.email = account.email
        }
        if self.fname != account.fname {
            self.fname = account.fname
        }
        if self.lname != account.lname {
            self.lname = account.lname
        }
        if self.gender != account.gender {
            self.gender = account.gender
        }
        if self.dob != account.dob {
            self.dob = account.dob
        }
        if self.address1 != account.address1 {
            self.address1 = account.address1
        }
        if self.address2 != account.address2 {
            self.address2 = account.address2
        }
        if self.city != account.city {
            self.city = account.city
        }
        if self.zipcode != account.zipcode {
            self.zipcode = account.zipcode
        }
        if self.state != account.state {
            self.state = account.state
        }
    }
// Specify properties to ignore (Realm won't persist these)
    
//    override static func ignoredProperties() -> [String] {
//        return ["isupdate"]
//    }
    
    override class func primaryKey() -> String? {
        return "token"
    }
}
