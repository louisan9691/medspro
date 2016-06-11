//
//  EmergencyController.swift
//  MedsPro
//
//  Created by Louis An on 11/06/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class EmergencyController: UIViewController {

    @IBOutlet weak var personText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    var currentPerson = [CKRecord]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()) {
            self.loadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func saveButton(sender: AnyObject) {
        
        if (phoneText.text!.isEmpty){
            let alertController =  UIAlertController(title: "Missing Field", message: "Please enter you emergency contact number", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
        if currentPerson.count == 0 {
            let newPerson = CKRecord(recordType: "Emergency")
            newPerson["name"] = personText.text!
            newPerson["phone"] = Int(phoneText.text!)
            
         
            publicDB.saveRecord(newPerson, completionHandler: {(record:CKRecord?, error:NSError?) -> Void in
                if error == nil{
                    print("New Emegency Person is inserted into the database")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully adding emergency number", message: "New emergency detail is inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        print("Error saving data on the icloud" + error.debugDescription)
                        let alertController =  UIAlertController(title: "Login required", message: "Please login using your Apple ID", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
        }else{
            currentPerson[0].setObject(self.personText.text!, forKey: "name")
            currentPerson[0].setObject(Int(self.phoneText.text!), forKey: "phone")
            
            publicDB.saveRecord(currentPerson[0], completionHandler: { (savedRecord, saveError) in
                if saveError != nil {
                    print("Error saving record: \(saveError!.localizedDescription)")
                } else {
                    print("Successfully updated emergency person!")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully editting current emergency person", message: "Modified emergency detail is inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
}
    func loadData(){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Emergency", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (numbers, error) in
            if error != nil{
                print(error)
            }else{
                if numbers!.count > 0 {
                    let number = numbers!.first
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentPerson.append(number!)
                        
                        
                        //Check if CKREcordValue is nil
                        // If it is, set textFiled = " "
                        // If it is not, set textField to the correct value
                        if String(number!.objectForKey("name")) == "nil"{
                            self.personText.text! = ""
                        }else{
                            self.personText.text! = String(number!.objectForKey("name")!)
                        }
                        
                        self.phoneText.text! = String(number!.objectForKey("phone")!)

                    }
                }
            }
        }
    }
}