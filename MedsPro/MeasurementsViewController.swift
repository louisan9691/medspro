//
//  MeasurementsViewController.swift
//  MedsPro
//
//  Created by Louis An on 26/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class MeasurementsViewController: UIViewController {

    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        switch segmentedControlValue.selectedSegmentIndex{
        case 0:
            segmentedBloodValue = "O-"
            break
        case 1:
            segmentedBloodValue = "O+"
            break
        case 2:
            segmentedBloodValue = "A-"
            break
        case 3:
            segmentedBloodValue = "A+"
            break
        case 4:
            segmentedBloodValue = "B-"
            break
        case 5:
            segmentedBloodValue = "B+"
            break
        case 6:
            segmentedBloodValue = "AB-"
            break
        case 7:
            segmentedBloodValue = "AB+"
            break
        default:
            break
        }
    }
    @IBOutlet weak var segmentedControlValue: UISegmentedControl!
    @IBOutlet weak var allergiesTextField: UITextField!
    @IBOutlet weak var insulinLevel: UITextField!
    @IBOutlet weak var pulseTextField: UITextField!
    @IBOutlet weak var cholesterolLevel: UITextField!
    @IBOutlet weak var bloodPressureTextField: UITextField!
    @IBOutlet weak var glucoseTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var segmentedBloodValue = "O-"
    var currentMeasurement = [CKRecord]()
    
    
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    
    @IBAction func saveButton(sender: AnyObject) {
        
        //Check if there is any measurement exists. If there is none then add new measurements
        if currentMeasurement.count == 0 {
            let newMeasurement = CKRecord(recordType: "Measurement")
            newMeasurement["weight"] = Int(weightTextField.text!)
            newMeasurement["height"] = Int(heightTextField.text!)
            newMeasurement["glucoseLevel"] = Int(glucoseTextField.text!)
            newMeasurement["bloodType"] = segmentedBloodValue
            newMeasurement["pressure"] = Int(bloodPressureTextField.text!)
            newMeasurement["cholesterol"] = Int(cholesterolLevel.text!)
            newMeasurement["pulse"] = Int(pulseTextField.text!)
            newMeasurement["insulin"] = Int(insulinLevel.text!)
            newMeasurement["allergy"] = allergiesTextField.text!
            publicDB.saveRecord(newMeasurement, completionHandler: {(record:CKRecord?, error:NSError?) -> Void in
                if error == nil{
                    print("New measurement is inserted into the database")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully adding measurements", message: "New measurements are inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                    
                }else{
                    print("Error saving data on the icloud" + error.debugDescription)
                    let alertController =  UIAlertController(title: "Login required", message: "Please login using your Apple ID", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            })

            
        }else{
            
            // If there is a current measurements. Edit them
            
            currentMeasurement[0].setObject(Int(self.weightTextField.text!), forKey: "weight")
            currentMeasurement[0].setObject(Int(self.heightTextField.text!), forKey: "height")
            currentMeasurement[0].setObject(Int(self.glucoseTextField.text!), forKey: "glucoseLevel")
            currentMeasurement[0].setObject(segmentedBloodValue, forKey: "bloodType")
            currentMeasurement[0].setObject(Int(self.bloodPressureTextField.text!), forKey: "pressure")
            currentMeasurement[0].setObject(Int(self.cholesterolLevel.text!), forKey: "cholesterol")
            currentMeasurement[0].setObject(Int(self.pulseTextField.text!), forKey: "pulse")
            currentMeasurement[0].setObject(Int(self.insulinLevel.text!), forKey: "insulin")
            currentMeasurement[0].setObject(self.allergiesTextField.text!, forKey: "allergy")
            
            publicDB.saveRecord(currentMeasurement[0], completionHandler: { (savedRecord, saveError) in
                if saveError != nil {
                    print("Error saving record: \(saveError!.localizedDescription)")
                } else {
                    print("Successfully updated record!")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully editting current measurements", message: "Modified measurements are inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })
    }
}
    
    

    func loadData(){
        
        let publicDB = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Measurement", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (measurements, error) in
            if error != nil{
                print(error)
            }else{
                if measurements!.count > 0 {
                    let measurement = measurements!.first
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentMeasurement.append(measurement!)
                        
                        
                        //Check if CKREcordValue is nil
                        // If it is, set textFiled = " "
                        // If it is not, set textField to the correct value

                        self.segmentedBloodValue = String(measurement!.objectForKey("bloodType")!)
                        

                        if String(measurement!.objectForKey("weight")) == "nil"{
                            self.weightTextField.text! = ""
                        }else{
                            
                            self.weightTextField.text! = String(measurement!.objectForKey("weight")!)
                        }
                        
                        if String(measurement!.objectForKey("height")) == "nil"{
                            self.heightTextField.text! = ""
                        }else{
                            
                            self.heightTextField.text! = String(measurement!.objectForKey("height")!)
                        }
                        
                        if String(measurement!.objectForKey("glucoseLevel")) == "nil"{
                            self.glucoseTextField.text! = ""
                        }else{
                            
                            self.glucoseTextField.text! = String(measurement!.objectForKey("glucoseLevel")!)
                        }
                        
                        if String(measurement!.objectForKey("pressure")) == "nil"{
                            self.bloodPressureTextField.text! = ""
                        }else{
                            
                            self.bloodPressureTextField.text! = String(measurement!.objectForKey("pressure")!)
                        }
                        
                        if String(measurement!.objectForKey("cholesterol")) == "nil"{
                            self.cholesterolLevel.text! = ""
                        }else{
                            
                            self.cholesterolLevel.text! = String(measurement!.objectForKey("cholesterol")!)
                        }
                        
                        if String(measurement!.objectForKey("pulse")) == "nil"{
                            self.pulseTextField.text! = ""
                        }else{
                            
                            self.pulseTextField.text! = String(measurement!.objectForKey("pulse")!)
                        }
                        
                        if String(measurement!.objectForKey("insulin")) == "nil"{
                            self.insulinLevel.text! = ""
                        }else{
                            
                            self.insulinLevel.text! = String(measurement!.objectForKey("insulin")!)
                        }
                        
                        if String(measurement!.objectForKey("allergy")) == "nil"{
                            self.allergiesTextField.text! = ""
                        }else{
                            
                            self.allergiesTextField.text! = String(measurement!.objectForKey("allergy")!)
                        }
                        
                        
                        
                        
                        switch self.segmentedBloodValue{
                        case "O-" :
                            self.segmentedControlValue.selectedSegmentIndex = 0
                            break
                        case "O+" :
                            self.segmentedControlValue.selectedSegmentIndex = 1
                            break
                        case "A-" :
                            self.segmentedControlValue.selectedSegmentIndex = 2
                            break
                        case "A+" :
                            self.segmentedControlValue.selectedSegmentIndex = 3
                            break
                        case "B-" :
                            self.segmentedControlValue.selectedSegmentIndex = 4
                            break
                        case "B+" :
                            self.segmentedControlValue.selectedSegmentIndex = 5
                            break
                        case "AB-" :
                            self.segmentedControlValue.selectedSegmentIndex = 6
                            break
                        case "AB+" :
                            self.segmentedControlValue.selectedSegmentIndex = 7
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}
