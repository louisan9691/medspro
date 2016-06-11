//
//  ScheduleViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit
import LocalAuthentication


class ScheduleViewController: UIViewController {

    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    var refreshControl: UIRefreshControl = UIRefreshControl()

  
    let date = NSDate()
    let calendar = NSCalendar.currentCalendar()
   

    var Monday: Array<CKRecord> = []
    var Tuesday: Array<CKRecord> = []
    var Wednesday: Array<CKRecord> = []
    var Thursday: Array<CKRecord> = []
    var Friday: Array<CKRecord> = []
    var Saturday: Array<CKRecord> = []
    var Sunday: Array<CKRecord> = []
    
    
    
    // Done button after user drank their medicine
    // No of pill decreasees by medicine Dosage
    func doneButton (sender: UIButton){
        
            // get indexPath of a button
            let index = sender.tag
            let medDetail: CKRecord
            if segmentedControlOutlet.selectedSegmentIndex == 0 {
                medDetail = Monday[index]
            }
            else if segmentedControlOutlet.selectedSegmentIndex == 1{
                medDetail = Tuesday[index]
            }
            else if segmentedControlOutlet.selectedSegmentIndex == 2{
                medDetail = Wednesday[index]
            }
            else if segmentedControlOutlet.selectedSegmentIndex == 3{
                medDetail = Thursday[index]
            }
            else if segmentedControlOutlet.selectedSegmentIndex == 4{
                medDetail = Friday[index]
            }
            else if segmentedControlOutlet.selectedSegmentIndex == 5 {
                medDetail = Saturday[index]
            }else{
                medDetail = Sunday[index]
            }
        //Retrieve dosage value
        let dosage = medDetail.objectForKey("medDosage") as! Int
        var pills: Int = 0
        var total: Int
        
        
        //Check if number of pills is valid
        // If not, let total pill left is 0
        // If it is valid, (no of pills) - (dosage)
        if medDetail.objectForKey("medNumberOfPills") == nil || medDetail.objectForKey("medNumberOfPills") as! Int == 0 {
            total = 0
        }else{
            pills = medDetail.objectForKey("medNumberOfPills") as! Int
            total = pills - dosage
        }
            print (total)
        
            //Update number of pills
            medDetail.setObject(total, forKey: "medNumberOfPills")
            publicDB.saveRecord(medDetail, completionHandler: { (savedRecord, saveError) in
            if saveError != nil {
                print("Error saving record: \(saveError!.localizedDescription)")
            } else {
                print("Successfully updated record!")
                dispatch_async(dispatch_get_main_queue()) {
                    let alertController =  UIAlertController(title: "Great Job!", message: "You have finished your pills for today", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    )
}
    
    






    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //Preselect segmentedControl based on current day
        let components = calendar.components([.Weekday], fromDate: date)
        let day = components.weekday
        if day == 2 {
            self.segmentedControlOutlet.selectedSegmentIndex = 0
        }
        if day == 3 {
            self.segmentedControlOutlet.selectedSegmentIndex = 1
        }
        if day == 4{
            self.segmentedControlOutlet.selectedSegmentIndex = 2
        }
        if day == 5 {
            self.segmentedControlOutlet.selectedSegmentIndex = 3
        }
        if day == 6 {
            self.segmentedControlOutlet.selectedSegmentIndex = 4
        }
        if day == 7 {
            self.segmentedControlOutlet.selectedSegmentIndex = 5
        }
        if day == 1 {
            self.segmentedControlOutlet.selectedSegmentIndex = 6
        }

        loadData()
        tableView.reloadData()
        
        
        //Pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ScheduleViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    
    //refresh function
    func refresh (){
         dispatch_async(dispatch_get_main_queue()) {
        self.Monday.removeAll()
        self.Tuesday.removeAll()
        self.Wednesday.removeAll()
        self.Thursday.removeAll()
        self.Sunday.removeAll()
        self.Saturday.removeAll()
        self.Friday.removeAll()
        self.loadData()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
        }
    }
    
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch segmentedControlOutlet.selectedSegmentIndex {
        case 0:
            returnValue = Monday.count
            break
        case 1:
            returnValue = Tuesday.count
            break
        case 2:
            returnValue = Wednesday.count
            break
        case 3:
            returnValue = Thursday.count
            break
        case 4:
            returnValue = Friday.count
            break
        case 5:
            returnValue = Saturday.count
            break
        case 6:
            returnValue = Sunday.count
            break
        default:
            returnValue = 0
            break
        }
        return returnValue
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ScheduleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ScheduleCell
      
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy, hh:mm a"

        switch segmentedControlOutlet.selectedSegmentIndex {
        case 0:
            let record: CKRecord = Monday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            
            //get indexPath for a button
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 1:
            let record: CKRecord = Tuesday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 2:
            let record: CKRecord = Wednesday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 3:
            let record: CKRecord = Thursday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 4:
            let record: CKRecord = Friday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 5:
            let record: CKRecord = Saturday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        case 6:
            let record: CKRecord = Sunday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            cell.doneButton.tag = indexPath.row
            cell.doneButton.addTarget(self, action: #selector(doneButton), forControlEvents: UIControlEvents.TouchUpInside)
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            
            //Delete record in cloudKit using recordID
            if segmentedControlOutlet.selectedSegmentIndex == 0{
                deleteData([self.Monday[indexPath.row].recordID])
                self.Monday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 1{
                deleteData([self.Tuesday[indexPath.row].recordID])
                self.Tuesday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 2{
                deleteData([self.Wednesday[indexPath.row].recordID])
                self.Wednesday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 3{
                deleteData([self.Thursday[indexPath.row].recordID])
                self.Thursday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 4{
                deleteData([self.Friday[indexPath.row].recordID])
                self.Friday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 5{
                deleteData([self.Saturday[indexPath.row].recordID])
                self.Saturday.removeAtIndex(indexPath.row)
            }
            if segmentedControlOutlet.selectedSegmentIndex == 6{
                deleteData([self.Sunday[indexPath.row].recordID])
                self.Sunday.removeAtIndex(indexPath.row)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)            
        }
    }

    //Delete data func
    //Input array of recordID
    func deleteData(deleteRecord: [CKRecordID]){
        let publicDB = CKContainer.defaultContainer().publicCloudDatabase
        let operation = CKModifyRecordsOperation (recordsToSave: nil, recordIDsToDelete: deleteRecord)
        operation.savePolicy = .AllKeys
        operation.modifyRecordsCompletionBlock = { added, deleted, error in
            if error != nil {
                print(error) // print error if any
            } else {
                print("Deleted Successfully")
            }
        }
        publicDB.addOperation(operation)
    }
    
    
    
    
    
    //Segue to ViewMedicineController
    //Pass CKRecord of chosen Medicine
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewMedicineSegue"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let medDetail: CKRecord
                
                if segmentedControlOutlet.selectedSegmentIndex == 0 {
                    medDetail = Monday[indexPath.row]
                }
                else if segmentedControlOutlet.selectedSegmentIndex == 1{
                    medDetail = Tuesday[indexPath.row]
                }
                else if segmentedControlOutlet.selectedSegmentIndex == 2{
                    medDetail = Wednesday[indexPath.row]
                }
                else if segmentedControlOutlet.selectedSegmentIndex == 3{
                    medDetail = Thursday[indexPath.row]
                }
                else if segmentedControlOutlet.selectedSegmentIndex == 4{
                    medDetail = Friday[indexPath.row]
                }
                else if segmentedControlOutlet.selectedSegmentIndex == 5 {
                    medDetail = Saturday[indexPath.row]
                }else{
                    medDetail = Sunday[indexPath.row]
                }
                let controller: ViewMedicineController = segue.destinationViewController as! ViewMedicineController
                controller.medDetail.append(medDetail)

            }
        }
    }
    
    
    
    
    
    func loadData(){

      
       let predicate = NSPredicate(value: true)
       let query = CKQuery(recordType: "Medicine", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "Time", ascending: true)]
        publicDB.performQuery(query, inZoneWithID: nil) { (medicines, error) in
            if error != nil{
                        print(error)
                }else{
                for medicine in medicines!{
                    if (medicine.valueForKey("Day") as? String) == "Monday"{
                        self.Monday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Tuesday"{
                        self.Tuesday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Wednesday"{
                        self.Wednesday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Thursday"{
                        self.Thursday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Friday"{
                        self.Friday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Saturday"{
                        self.Saturday.append(medicine)
                        
                    }else if (medicine.valueForKey("Day") as? String) == "Sunday"{
                        self.Sunday.append(medicine)
                    }
                }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
        }
    
    //Login button
    @IBAction func loginButton(sender: AnyObject) {
        touchID()
    }
    
    //Setup touchID
    func touchID()
    {
        let authContext = LAContext()
        let authReason = "Please use Touch ID to access User tab"
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError){
            
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: {(success,error) -> Void in
                if success{
                print(" Authenticate successfully")
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.tabBarController?.selectedIndex = 3
                    })
                }else{
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.reportTouchIDError(error)
                        })
                    }
                }
            })
            }else{
            print(authError?.localizedDescription)
        }
    }
    
    //Touch ID error in a more friendly way
    func reportTouchIDError(error: NSError){
        switch error.code{
        case LAError.AuthenticationFailed.rawValue:
            print("Authentication Failed")
        case LAError.PasscodeNotSet.rawValue:
            print("Passcode has not been set")
        case LAError.SystemCancel.rawValue:
            print("User canceled")
        case LAError.TouchIDNotEnrolled.rawValue:
            print("User has not register their fingers with touch ID")
        case LAError.TouchIDNotAvailable.rawValue:
            print("Touch ID is not available")
        case LAError.UserFallback.rawValue:
            print("User opted to enter password")
        default:
            print(error.localizedDescription)
        }
    }
}


//                    for i in 0 ..< medicines!.count{
//                        let currentReminder: CKRecord = medicines![i]
//                        
//                        
//                        let predicate1 = NSPredicate(format: "med == %@", currentReminder)
//                        let query = CKQuery(recordType: "Reminder", predicate: predicate1)
//                        publicDB.performQuery(query, inZoneWithID: nil) { (reminders, error) in
//                            if error != nil{
//                                print(error)
//                            }else{
//                                    for reminder in reminders!{
//                                        self.reminderDict[reminder.objectForKey("Day") as! String] = reminder.objectForKey("Time") as? NSDate
//                                }
//                               
//                                self.scheduleDict[currentReminder.objectForKey("medName") as! String] = self.reminderDict
//                                self.reminderDict.removeAll()
//
//                                //This is the magic !
//                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                                self.tableView.reloadData()
//
//                                    
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//}