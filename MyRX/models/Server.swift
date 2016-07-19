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
      _ parameters: [String: AnyObject] = [:],
      headers: [String: String]? = nil)
    -> Request
{
    guard let _ = parameters["token"] else {
        return Manager.sharedInstance.request(
            method,
            SERVERURL + apiurl,
            parameters: parameters + ["token" : TOKEN],
            encoding: .JSON,
            headers: headers
        )
    }
    return Manager.sharedInstance.request(
        method,
        SERVERURL + apiurl,
        parameters: parameters,
        encoding: .JSON,
        headers: headers
    )
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
//public func request<
func login(email:String,password:String) -> Request {
    return request(.POST, "/api/sessions",[
        "email":email,
        "password":password])
}
func updateAccount() -> Request {
    let account = currentAccount()
    return request(.PATCH,"/api/users/update",object: account,key:"user")
}
func signup(account:Account,password:String) ->Request {
    return request(.POST,"/api/users",object: account,key:"user",attack:["password":password])
}
func changePassword(password:String) -> Request {
    return request(.PATCH, "/api/users/update_password", ["user":[
            "password":password
        ]])
}
func logout() -> Request {
    return request(.DELETE,"/api/sessions/destroy",[:])
}
