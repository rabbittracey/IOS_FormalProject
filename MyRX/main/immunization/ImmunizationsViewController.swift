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
import RealmSwift
import Alamofire

class ImmunizationsViewController: BaseFormViewController {
    var token : RLMNotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
        <<< ButtonRow("Test") {
            $0.title = "Test"
        }.onCellSelection({ (cell, row) in
        })
        +++ Section()
        

        let results = currentRealm().objects(Immunization.self)
        token = results.addNotificationBlock({ [ weak self ] in
            switch $0 {
            case .Initial(let results):
                print(results)
                self?.update(results)
                break
            case .Update(let results,_,let insertions,let modifications):
                print("update")
                print(results)
                print(insertions)
                print(modifications)
                self?.update(results,insertions: insertions,modifications: modifications)
                break
            case .Error:
                print("Error")
                break
            }
        })
    }
    func update(result : Results<Immunization>,insertions:[Int]?=nil,modifications:[Int]?=nil) {
        result.forEach { (immunization) in
            print(immunization)
            form.last! <<< ButtonRow() { [immunization]
                $0.title = immunization.name
            }
        }
    }
    deinit {
        token?.stop()
    }
}
