//
//  Server.swift
//  MyRX
//
//  Created by yaowei on 16/7/13.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper


public func request(
    method: Alamofire.Method,
    _ apiurl: String,
      _ parameters: [String: AnyObject] = [:])
    -> Request
{
    switch method {
    case .GET:
        return Manager.sharedInstance.request(
            method,
            SERVERURL + apiurl,
            parameters: parameters + ["token" : parameters["token"] as? String ?? currentAccount().token],
            encoding: .URL
        ).validate()
    default:
        print(parameters + ["token" : parameters["token"] as? String ?? currentAccount().token])
        return Manager.sharedInstance.request(
            method,
            SERVERURL + apiurl,
            parameters: parameters + ["token" : parameters["token"] as? String ?? currentAccount().token],
            encoding: .JSON
        ).validate()
    }
}

public func request<T:Mappable>(
    method: Alamofire.Method,
    _ apiurl: String,
      object: T,key:String,attack:[String:AnyObject]?=nil)
    -> Request
{
    let data = Mapper<T>().toJSON(object)
    return request(method, apiurl,[key : (data+attack)!])
}
public func request<T:Mappable>(
	method: Alamofire.Method,
	_ apiurl: String,
	  objects: [T],key:String,attack:[String:AnyObject]?=nil)
	-> Request
{
	let data = Mapper<T>().toJSONArray(objects)
	return request(method, apiurl,([key : data]+attack)!)
}


func login(email:String,password:String) -> Request {
    return request(.POST, "/api/sessions",["email":email,"password":password])
}
func updateAccount() -> Request {
    let account = currentAccount()
    return request(.PATCH,"/api/users/update",object: account,key:"user")
}
func signup(account:Account,password:String) ->Request {
    return request(.POST,"/api/users",object: account,key:"user",attack:["password":password])
}
func changePassword(password:String) -> Request {
    return request(.PATCH, "/api/users/update_password", ["user":["password":password]])
}
func logout() -> Request {
    return request(.DELETE,"/api/sessions/destroy",[:])
}
func getImmunization(version:Int64 = 0) -> Request {
    return request(.GET,"/api/patient_immunizations",["version":NSNumber(longLong:version)])
}
func getDatas<T:MDObject where T : MDMappable>(updates:[T],version:Int64 = 0 ) -> Request {
    return request(.POST,"/api/" + T.self.className(),objects:updates,key:"datas",attack : ["table": T.self.className().lowercaseString,"version":NSNumber(longLong:version)])
}

func applyIDs(table:String,count:Int = 50) -> Request {
    return request(.POST,"/api/mobiles/apply_range",["table_name":table,"count":count])
}
