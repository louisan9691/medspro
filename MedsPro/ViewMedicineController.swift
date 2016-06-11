//
//  ViewMedicineController.swift
//  MedsPro
//
//  Created by Louis An on 10/06/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class ViewMedicineController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let publicDB = CKContainer.defaultContainer().publicCloudDatabase

    @IBOutlet weak var medImage: UIImageView!
    @IBOutlet weak var notesText: UITextField!
    @IBOutlet weak var prescriptionText: UITextField!
    @IBOutlet weak var doctorName: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var medLeftText: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medStregthText: UITextField!
    @IBOutlet weak var medDosageText: UITextField!
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    
    var medDetail = [CKRecord]()
    var segmentedValue: String = ""
    var photoList = NSMutableArray()
    
    
    
    
    //Share function
    @IBAction func shareButton(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let reminder = "Reminder: \n Take \(medDetail.first?.valueForKey("medDosage") as! Int) pills of \((medDetail.first?.valueForKey("medName") as! String).lowercaseString) at \(String(dateFormatter.stringFromDate(medDetail.first!.valueForKey("Time") as! NSDate))) on \(medDetail.first?.valueForKey("Day") as! String) \((medDetail.first?.valueForKey("medWhen") as! String).lowercaseString)"
         dispatch_async(dispatch_get_main_queue()) {
        let share = UIActivityViewController(activityItems: [reminder], applicationActivities: nil)
        self.presentViewController(share, animated: true, completion: nil)
        }
    }
   
    
    
    
    @IBAction func segmentedAction(sender: UISegmentedControl) {
        switch segmentedOutlet.selectedSegmentIndex{
        case 0:
            segmentedValue = "Before Meal"
            break
        case 1:
            segmentedValue = "After Meal"
            break
        default:
            break
        }
    }
 
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        //Add photo
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
            medImage.image = img
            photoList.addObject(img!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    @IBAction func clearButton(sender: AnyObject) {
        medImage.image = nil
        photoList.removeAllObjects()
    }
  
    
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
            // Update medicine's details
            
            medDetail[0].setObject(self.medNameLabel.text!, forKey: "medName")
            medDetail[0].setObject(self.medStregthText.text!, forKey: "medStrength")
            medDetail[0].setObject(Int(self.medDosageText.text!), forKey: "medDosage")
            medDetail[0].setObject(segmentedValue, forKey: "medWhen")
            medDetail[0].setObject(Int(self.medLeftText.text!), forKey: "medNumberOfPills")
           // medDetail[0].setObject(self.doctorName.text!, forKey: "Doctor")
            medDetail[0].setObject(self.prescriptionText.text!, forKey: "medPrescription")
            medDetail[0].setObject(Int(self.notesText.text!), forKey: "medNote")
 
        
        // Change UIimage to CKAsset
        // If a photo is picked, convert UIimage to CKAsset then store in cloudkit
        // If no photo is picked, store NIL into cloudkit
        if self.photoList.count == 1{
            let image = self.photoList[0] as! UIImage
            let fileManager = NSFileManager.defaultManager()
            let dir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let file = dir[0].URLByAppendingPathComponent("image").path
            UIImagePNGRepresentation(image)?.writeToFile(file!, atomically: true)
            let imageURL = NSURL.fileURLWithPath(file!)
            let imageAsset = CKAsset(fileURL: imageURL)
            medDetail[0].setObject(imageAsset, forKey: "medImage")
        }else{
            medDetail[0].setObject(nil, forKey: "medImage")
        }

        
        
        
            publicDB.saveRecord(medDetail[0], completionHandler: { (savedRecord, saveError) in
                if saveError != nil {
                    print("Error saving record: \(saveError!.localizedDescription)")
                } else {
                    print("Successfully updated medicine detail!")
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController =  UIAlertController(title: "Successfully editting current medicine", message: "Modified medicine details are inserted into the database", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    

  
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedButton()
        loadData()
    }

    
    
    
    func loadData(){
        print(medDetail)
        self.title = String(medDetail.first!.valueForKey("medName")!)
        self.medNameLabel.text! = String(medDetail.first!.valueForKey("medName")!)
        self.medDosageText.text = String(medDetail.first!.valueForKey("medDosage")!)
        
        
        if String(medDetail.first!.objectForKey("medStrength")) == "nil" {
            self.medStregthText.text = ""
        }else{
            self.medStregthText.text = String(medDetail.first!.valueForKey("medStrength")!)
        }
        
        if String(medDetail.first!.valueForKey("medWhen")!) == "After Meal" {
            self.segmentedOutlet.selectedSegmentIndex = 1
        }else{
            self.segmentedOutlet.selectedSegmentIndex = 0
        }
       
        if String(medDetail.first!.objectForKey("medNumberOfPills")) == "nil" {
            self.medLeftText.text = ""
        }else{
            self.medLeftText.text = String(medDetail.first!.valueForKey("medNumberOfPills")!)
        }
        
        if String(medDetail.first!.objectForKey("medPrescription")) == "nil" {
            self.prescriptionText.text = ""
        }else{
            self.prescriptionText.text = String(medDetail.first!.valueForKey("medPrescription")!)
        }
        
        if String(medDetail.first!.objectForKey("medNote")) == "nil" {
            self.notesText.text = ""
        }else{
            self.notesText.text = String(medDetail.first!.valueForKey("medNote")!)
        }
        
        self.doctorName.text = "None"
        self.dayLabel.text = String(medDetail.first!.valueForKey("Day")!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy, hh:mm a"
        self.timeLabel.text = String(dateFormatter.stringFromDate(medDetail.first!.valueForKey("Time") as! NSDate))
        
        
        //Run this on main thread. It is supposed to help dowloading the picture quicker
        if String(medDetail.first!.objectForKey("medImage")) != "nil" {
            dispatch_async(dispatch_get_main_queue()) {
                let photo = self.medDetail.first!.objectForKey("medImage") as! CKAsset
                let image = UIImage(contentsOfFile: photo.fileURL.path!)
                self.medImage.image = image
            }
        }
    }
    
    
    
    
    @IBOutlet weak var btnRounded: UIButton!
    func roundedButton()
    {
        btnRounded.layer.borderColor = UIColor(red: 81/255, green: 159/255, blue: 243/255, alpha: 1).CGColor
        btnRounded.layer.borderWidth = 1
        btnRounded.layer.cornerRadius = 5
        
    }
}
