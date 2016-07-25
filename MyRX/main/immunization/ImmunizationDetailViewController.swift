//
//  ImmunizationDetail.swift
//  MyRX
//
//  Created by yaowei on 16/7/23.
//  Copyright © 2016年 EagleForce. All rights reserved.
//

import UIKit
import Eureka
import ObjectMapper
import Realm
import RealmSwift
import Alamofire

class ImmunizationDetailViewController: BaseFormViewController {
    var immunization:Immunization!
    var isEdit : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Basic Information")
            
            
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Enabled", "Disabled"]
                $0.value = "Disabled"
            }
            
        

            <<< LabelRow() {
                $0.title = self.immunization.name
                $0.value = "----"
                $0.disabled = "$segments = 'Disabled'"

        }
            
            
            
            
                     <<< DateRow() {
                $0.value = self.immunization.date_administered
                $0.title = "Date Administered"
                $0.disabled = "$segments = 'Disabled'"
                
            }
                    <<< DateRow() {
                $0.value = self.immunization.reImmunization_due_date
                $0.title = "Reimmunization Due Date"
                $0.disabled = "$segments = 'Disabled'"
                
            }
                 <<< LabelRow() {
                $0.title = "Administrator"
                $0.value = self.immunization.administrator
                $0.disabled = "$segments = 'Disabled'"
                
            }
            <<< LabelRow() {
                $0.title = "Notes"
                $0.value = self.immunization.notes
                $0.disabled = "$segments = 'Disabled'"
                
            }
            <<< LabelRow() {
                $0.title = "Source"
                $0.value = self.immunization.source
                $0.disabled = "$segments = 'Disabled'"
                
            }
           
            <<< LabelRow() {
                $0.title = "Route Site"
                $0.value = self.immunization.route_site
                $0.disabled = "$segments = 'Disabled'"
                
            }
          
            <<< LabelRow() {
                $0.title = "Vaccine Lot"
                $0.value = self.immunization.vaccine_lot
                $0.disabled = "$segments = 'Disabled'"
                
            }
                       <<< LabelRow() {
                $0.title = "Vaccine MFR"
                $0.value = self.immunization.vaccine_mfr
                $0.disabled = "$segments = 'Disabled'"
                
            }

            <<< DateRow() {
                $0.value = self.immunization.publication_date
                $0.title = "Publication Date"
                $0.disabled = "$segments = 'Disabled'"
                
            }

            
            <<< DateRow() {
                $0.value = self.immunization.date_on_vis
                $0.title = "Date on VIS"
                $0.disabled = "$segments = 'Disabled'"
                
            }
            
            <<< DateRow() {
                $0.value = self.immunization.date_given
                $0.title = "Date Given"
                $0.disabled = "$segments = 'Disabled'"
                
            }
            <<< LabelRow() {
                $0.title = "Clinic Name"
                $0.value = self.immunization.clinic_name
                $0.disabled = "$segments = 'Disabled'"
                
            }
            
            
            <<< LabelRow() {
                $0.title = "Adverse React Log"
                $0.value = self.immunization.adverse_reaction_log
                $0.disabled = "$segments = 'Disabled'"
                
            }

            <<< LabelRow() {
                $0.title = "Clinic Address"
                $0.value = self.immunization.clinic_address
                $0.disabled = "$segments = 'Disabled'"
                
            }
        
            +++ Section("Insurance Information")
            
            <<< LabelRow() {
                $0.title = "Funding Source"
                $0.value = self.immunization.funding_source
                $0.disabled = "$segments = 'Disabled'"
                
        }
            +++ Section(" ")
            <<< ButtonRow("Submit") {
                $0.title = "Submit"
                try! currentRealm().write {
                    immunization.id = getID()
                    currentRealm().add(immunization,update: true)
                }
                navigationController?.popViewControllerAnimated(true)
                
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = UIImage(named: "icon_account")
                })

        
        







        
        
    }
}
