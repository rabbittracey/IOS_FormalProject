//
//  ViewController.swift
//  MyRX-T
//
//  Created by yaowei on 16/8/18.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import ObjectMapper

class ViewController: UIViewController {
    var realm : Realm!
    var person : Person?
    var dog : Dog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = Realm.Configuration(fileURL: NSURL(fileURLWithPath: "/tmp/aa.realm"), readOnly: false)
        realm = try! Realm(configuration: config)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var text: UITextField!

    @IBAction func onCreate(sender: AnyObject) {
        if let id = Int(text.text ?? "0") where id > 0 {
            let person = Person(value: ["id":id,"name":"haha"])
            try! realm.write {
                realm.add(person)
            }
            print(realm.objects(Person.self).count)
            
        }
    }
    @IBAction func onClick(sender: AnyObject) {
        guard let id = Int(text.text ?? "0") where id > 0 else {
            return
        }
        if let person = realm.objects(Person.self).first {
            print(person.name)
            let dog = Dog(value: ["id":id,"name":"dog"])
            dog.owner = person
            try! realm.write {
                realm.add(dog)
                person.dogs.append(dog)
                print(dog.owner?.name)
            }
            print(dog.owner)
    
        }
        
//        try! realm.write {
//            let person = Person()
//            person.name = "---"
//            realm.add(person)
//        }
    }

    @IBAction func onClick03(sender: AnyObject) {
        if let person = person {
            print(Mapper<Person>().toJSONString(person))
        } else {
            person = realm.objects(Person.self).first
        }
    }
    @IBAction func onClick04(sender: AnyObject) {
//        if let dog = dog {
////            print(dog.toDictionary())
//            print(dog)
//        } else {
//            dog = realm.objects(Dog.self).first
//        }
        let person = Person()
        if person["birthdate"] is NSDate? {
            print("-------------")
        }
    }
}

