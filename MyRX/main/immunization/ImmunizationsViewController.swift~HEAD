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

class ImmunizationDetailViewController: BaseFormViewController {
    var token : RLMNotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
        <<< ButtonRow("Test") {
            $0.title = "Test"
        }.onCellSelection({ (cell, row) in
        })
        +++ Section("Here are your immunization information")
        let results = currentRealm().objects(Immunization.self)
        token = results.addNotificationBlock({ [ weak self ] in
            switch $0 {
            case .Initial(let results):
                print(results)
                self?.update(results)
                break
            case .Update(let results,_,let insertions,let modifications):
                print("update")
                print(results.count)
                print(results[0])
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
        result.count.forEach { (index, total) in
            form.last! <<< ImmunizationListRow() { [index,result]
                $0.value = result[index]
            }
        }
    }
    deinit {
        token?.stop()
    }
}
