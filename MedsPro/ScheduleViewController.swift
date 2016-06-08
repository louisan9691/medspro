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
    
    
    
    var reminderDict = [String:NSDate]()
    var scheduleDict = [String:[String:NSDate]]()
   // var scheduleDict = [String:String]()
    var arrNotes: Array<CKRecord> = []
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        
        loadData()
        print(arrNotes)
        
    }
    

    
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ScheduleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ScheduleCell
        //let record: CKRecord = arrNotes[indexPath.row]
            let key   = Array(self.scheduleDict.keys)[indexPath.row]
           // let value = Array(self.reminderDict.keys)[indexPath.row]
           // print(key)
       // print(value)
        cell.medNameLabel.text! = key
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm"
        //cell.medNoOfPillsLabel.text! = value
        
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


  
    
    func loadData(){

       let publicDB = CKContainer.defaultContainer().publicCloudDatabase
       let predicate = NSPredicate(value: true)
       let query = CKQuery(recordType: "Medicine", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (medicines, error) in
            if error != nil{
                        print(error)
                }else{
//                for medicine in medicines!{
//                   // print(medicines)
//                    self.arrNotes.append(medicine)
//                }
//                print(self.arrNotes)
//                    
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        self.tableView.reloadData()
//                        
//                    })
//                    
//                }
//            }
//        }
//    }



                    for i in 0 ..< medicines!.count{
                        let currentReminder: CKRecord = medicines![i]
                        print(currentReminder.objectForKey("medName") as! String)
                        let predicate = NSPredicate(format: "med == %@", currentReminder)
                        let query = CKQuery(recordType: "Reminder", predicate: predicate)
                        
                        
                        publicDB.performQuery(query, inZoneWithID: nil) { (reminders, error) in
                            if error != nil{
                                print(error)
                            }else{
                                    for reminder in reminders!{

                                        self.reminderDict[reminder.objectForKey("Day") as! String] = reminder.objectForKey("Time") as? NSDate
                                       
                                }
                            
                                self.scheduleDict[currentReminder.objectForKey("medName") as! String] = self.reminderDict
                            
                                //This is the magic !
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.tableView.reloadData()
                                print(self.scheduleDict)
                            })
                            
                        }
                    }
                
            }
        }
    }
}
               }