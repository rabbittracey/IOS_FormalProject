//
//  GlobalData.swift
//  MyRX
//
//  Created by yaowei on 16/7/26.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import Alamofire

class GlobalData : Object {
    dynamic var uuids:Int64 = 0x1000000000
    
    func getUUID() -> Int64 {
        objc_sync_enter(GlobalData)
        defer { objc_sync_exit(GlobalData) }
		if (  self.realm?.inWriteTransaction == true ) {
			uuids += 1
		} else {
			try! self.realm?.write{
				uuids += 1
			}
		}
        return uuids
    }
}

func globalData() -> GlobalData {
    return cachedThreadLocalObjectWithKey("com.eagleforce.myrx.GlobalData", create: {
        let realm = currentRealm()
        let datas = realm.objects(GlobalData.self)
        if (datas.count == 0) {
            let data = GlobalData()
            try! realm.write({
                realm.add(data)
            })
            return data
        } else if ( datas.count == 1 ) {
            return datas.first!
        }
        try! realm.write {
            ( datas.count - 1 ).forEach({ (index,total) in
                realm.delete(datas[index])
            })
        }
        return datas.last!
    })
}
