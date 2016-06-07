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
    
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    var list = [CKRecord]()
    var reminderDict = [String:NSDate]()
    var scheduleDict = [String:[String:NSDate]]()
    var abc = ["a":"ant","b":"bee","c":"chicken"]
    var a = String()
    
   
    
    
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.abc.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Configure table cell
        
        let cellIdentifier = "ScheduleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ScheduleCell
            let key   = Array(self.abc.keys)[indexPath.row]
            let value = Array(self.abc.values)[indexPath.row]
        cell.medNameLabel.text! = key
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm"
        cell.medNoOfPillsLabel.text! = value
        
        //dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }


  
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
    
    
    func loadData(){
        reminderDict = [String:NSDate]()
        scheduleDict = [String:[String:NSDate]]()
        
       let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Medicine", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (medicine, error) in
            if error != nil{
                        dispatch_async(dispatch_get_main_queue()) {
                        print("Cloud Error")
                    }
                }else{

                    for i in 0 ..< medicine!.count{
                        let currentReminder: CKRecord = medicine![i]
                        print(currentReminder.objectForKey("medName") as! String)
                        let predicate = NSPredicate(format: "med == %@", currentReminder)
                        let query = CKQuery(recordType: "Reminder", predicate: predicate)
                        self.publicDB.performQuery(query, inZoneWithID: nil) { (reminders, error) in
                            if error != nil{
                                dispatch_async(dispatch_get_main_queue()) {
                                    print("Cloud Error")
                                }
                            }else{
                                    for reminder in reminders!{
                                        self.a = "ACASD"
                                        self.reminderDict[reminder.objectForKey("Day") as! String] = reminder.objectForKey("Time") as? NSDate
                                        //print(self.reminderDict)
                                    }
                                }
                                self.scheduleDict[currentReminder.objectForKey("medName") as! String] = self.reminderDict
                                print(self.scheduleDict)
                        }
                    }
                }
            }
        
        
        dispatch_async(dispatch_get_main_queue()) {
            print(self.reminderDict)
            print(self.scheduleDict)
            self.tableView.reloadData()
        }
       

    }
    

}

//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
//    
//    var key   = Array(self.dic.keys)[indexPath.row]
//    var value = Array(self.dic.values)[indexPath.row]
//    cell.text = key + value
//}

