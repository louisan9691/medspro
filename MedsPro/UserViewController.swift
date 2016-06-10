//
//  UserViewController.swift
//  MedsPro
//
//  Created by Louis An on 26/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFNameText: UITextField!
    @IBOutlet weak var userLNameText: UITextField!
    @IBOutlet weak var userDOBText: UITextField!
    @IBOutlet weak var userPhoneText: UITextField!
    @IBOutlet weak var segmentedValue: UISegmentedControl!
    @IBOutlet weak var userAddressText: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var segmentedGenderValue = "Female"
    var currentUser = [CKRecord]()
    var photoList = NSMutableArray()
    
    @IBAction func segmentedAction(sender: UISegmentedControl) {
        switch segmentedValue.selectedSegmentIndex{
        case 0:
            segmentedGenderValue = "Female"
            break
        case 1:
            segmentedGenderValue = "Male"
            break
        case 2:
            segmentedGenderValue = "Other"
            break
        default:
            break
    }
}
    
    
    
    // Add photo button
    @IBAction func addPhoto(sender: AnyObject) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        imagePicker.delegate = self
        navigationController!.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dict = info as NSDictionary
        let img: UIImage? = dict.objectForKey(UIImagePickerControllerOriginalImage) as? UIImage
        if img != nil{
            userImage.image = img
            photoList.addObject(img!)           
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    //Save button
    @IBAction func saveButton(sender: AnyObject) {
        
        //Check if an user is exsisted or not 
        //If there is not, add new one
        if currentUser.count == 0 {
        let newUser = CKRecord(recordType: "User")
        newUser["userFName"] = userFNameText.text!
        newUser["userLName"] = userLNameText.text!
        newUser["userDOB"] = userDOBText.text!
        newUser["userAddress"] = userAddressText.text!
        newUser["userPhone"] = Int(userPhoneText.text!)
        newUser["userGender"] = segmentedGenderValue
            
                //Change UIimage to CK asset
                //Save imageAsset to CLoudkit
                let image = self.photoList[0] as! UIImage
                let fileManager = NSFileManager.defaultManager()
                let dir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
                let file = dir[0].URLByAppendingPathComponent("image").path
                UIImagePNGRepresentation(image)?.writeToFile(file!, atomically: true)
                let imageURL = NSURL.fileURLWithPath(file!)
                let imageAsset = CKAsset(fileURL: imageURL)
                newUser["userImage"] = imageAsset
         
            
         
        
        publicDB.saveRecord(newUser, completionHandler: {(record:CKRecord?, error:NSError?) -> Void in
            if error == nil{
                print("New User is inserted into the database")
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController =  UIAlertController(title: "Successfully adding user", message: "New user is inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                    
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
            
            //If there is, edit the old one
            currentUser[0].setObject(self.userFNameText.text!, forKey: "userFName")
            currentUser[0].setObject(self.userLNameText.text!, forKey: "userLName")
            currentUser[0].setObject(self.userDOBText.text!, forKey: "userDOB")
            currentUser[0].setObject(segmentedGenderValue, forKey: "userGender")
            currentUser[0].setObject(self.userAddressText.text!, forKey: "userAddress")
            currentUser[0].setObject(Int(self.userPhoneText.text!), forKey: "userPhone")
            
            // Change UIimage to CKAsset
            let image = self.photoList[0] as! UIImage
            let fileManager = NSFileManager.defaultManager()
            let dir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let file = dir[0].URLByAppendingPathComponent("image").path
            UIImagePNGRepresentation(image)?.writeToFile(file!, atomically: true)
            let imageURL = NSURL.fileURLWithPath(file!)
            let imageAsset = CKAsset(fileURL: imageURL)
            
            currentUser[0].setObject(imageAsset, forKey: "userImage")
            
            
            publicDB.saveRecord(currentUser[0], completionHandler: { (savedRecord, saveError) in
                if saveError != nil {
                    print("Error saving record: \(saveError!.localizedDescription)")
                } else {
                    print("Successfully updated record!")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully editting current user", message: "Modified user is inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
         dispatch_async(dispatch_get_main_queue()) {
        self.loadData()
        }
    }

    
    
    
    //load data from Cloudkit
    func loadData(){
        
       
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "User", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (users, error) in
            if error != nil{
                print(error)
            }else{
                if users!.count > 0 {
                    let user = users!.first
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentUser.append(user!)
                        self.segmentedGenderValue = String(user!.objectForKey("userGender")!)
                        
                        //Check if CKREcordValue is nil
                        // If it is, set textFiled = " "
                        // If it is not, set textField to the correct value
                        if String(user!.objectForKey("userFName")) == "nil"{
                            self.userFNameText.text! = ""
                        }else{
                            
                            self.userFNameText.text! = String(user!.objectForKey("userFName")!)
                        }
                        
                        if String(user!.objectForKey("userLName")) == "nil"{
                            self.userLNameText.text! = ""
                        }else{
                            
                            self.userLNameText.text! = String(user!.objectForKey("userLName")!)
                        }
                        
                        if String(user!.objectForKey("userDOB")) == "nil"{
                            self.userDOBText.text! = ""
                        }else{
                            
                            self.userDOBText.text! = String(user!.objectForKey("userDOB")!)
                        }
                        
                        if String(user!.objectForKey("userAddress")) == "nil"{
                            self.userAddressText.text! = ""
                        }else{
                            
                            self.userAddressText.text! = String(user!.objectForKey("userAddress")!)
                        }
                        
                        if String(user!.objectForKey("userPhone")) == "nil"{
                            self.userPhoneText.text! = ""
                        }else{
                            
                            self.userPhoneText.text! = String(user!.objectForKey("userPhone")!)
                        }
                        
                        //Run this on main thread. It is supposed to help dowloading the picture quicker
                        dispatch_async(dispatch_get_main_queue()) {                 
                            let photo =
                                user!.objectForKey("userImage") as! CKAsset
                            
                            let image = UIImage(contentsOfFile:
                                photo.fileURL.path!)
                            
                            self.userImage.image = image
                            
                        }
                        
                        switch self.segmentedGenderValue{
                        case "Female" :
                            self.segmentedValue.selectedSegmentIndex = 0
                            break
                        case "Male" :
                            self.segmentedValue.selectedSegmentIndex = 1
                            break
                        case "Other" :
                            self.segmentedValue.selectedSegmentIndex = 2
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
