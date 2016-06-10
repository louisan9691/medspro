//
//  ScheduleViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit


class ScheduleViewController: UIViewController {

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
        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm a"

        
        
        switch segmentedControlOutlet.selectedSegmentIndex {
        case 0:
            let record: CKRecord = Monday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 1:
            let record: CKRecord = Tuesday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 2:
            let record: CKRecord = Wednesday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 3:
            let record: CKRecord = Thursday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 4:
            let record: CKRecord = Friday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 5:
            let record: CKRecord = Saturday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
            break
        case 6:
            let record: CKRecord = Sunday[indexPath.row]
            cell.medNameLabel.text! = String(record.valueForKey("medName")!)
            cell.medNoOfPillsLabel.text! = String(dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate))
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
    
    
    
    func loadData(){

       let publicDB = CKContainer.defaultContainer().publicCloudDatabase
       let predicate = NSPredicate(value: true)
       let query = CKQuery(recordType: "Medicine", predicate: predicate)
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