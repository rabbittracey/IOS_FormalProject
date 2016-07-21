//
//  ImmunizationDetailViewController.swift
//  MyRX
//
//  Created by yaowei on 16/7/19.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import Alamofire

class ImmunizationDetailViewController: BaseFormViewController {
    var token : RLMNotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
        <<< ButtonRow("Test") {
            $0.title = "Test"
        }.onCellSelection({ (cell, row) in
            getImmunization().responseObject { (response:Response<PackImmunization, NSError>) in
                switch(response.result) {
                case .Success(let value):
                    print(value)
                    try! currentRealm().write {
                        value.immunizations?.forEach{
                            currentRealm().add($0)
                        }
                    }
                    break
                case .Failure(let error):
                    print(error)
                }
            }
        })
        +++ Section()
        

        let results = currentRealm().objects(Immunization.self)
        token = results.addNotificationBlock({
            switch $0 {
            case .Initial(let results):
                print(results)
                break
            case .Update(let results,_,let insertions,let modifications):
                print("update")
                print(results)
                print(insertions)
                print(modifications)
                break
            case .Error:
                print("Error")
                break
            }
        })
    }
    deinit {
        token?.stop()
    }
}
