//
//  AddDoctorViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class AddDoctorViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var specialtyText: UITextField!
    @IBOutlet weak var clinicText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var workingHourText: UITextField!
    
     let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        if (nameText.text!.isEmpty){
            let alertController =  UIAlertController(title: "Missing Field", message: "Please enter you medicine details", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{

        let newDoctor = CKRecord(recordType: "Doctor")
        newDoctor["docName"] = nameText.text!
        newDoctor["docSpecialty"] = specialtyText.text!
        newDoctor["docClinic"] = clinicText.text!
        newDoctor["docAddress"] = addressText.text!
        newDoctor["docPhone"] = Int(phoneText.text!)
        newDoctor["docWorkingHours"] = workingHourText.text!
        
        publicDB.saveRecord(newDoctor, completionHandler: {(record:CKRecord?, error:NSError?) -> Void in
            if error == nil{
                print("New Doctor is inserted into the database")
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController =  UIAlertController(title: "Successfully adding a new doctor", message: "New doctor is inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        })
        self.navigationController!.popViewControllerAnimated(true)
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}
