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
    
   
    
//    required init?(coder aDecoder: NSCoder) {
//        self.list = Array<CKRecord>()
//        super.init(coder: aDecoder)
//    }
    
    //Initialise database container
    
    
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Configure table cell
        
        let cellIdentifier = "ScheduleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ScheduleCell
        let record: CKRecord = list[indexPath.row]
        cell.medNameLabel.text! = record.valueForKey("Day") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm"
        cell.medNoOfPillsLabel.text! = dateFormatter.stringFromDate(record.valueForKey("Time") as! NSDate)
        
        
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
        
        
//        let predicate = NSPredicate(format: "%K == %@", "Day", "Tuesday")
//        let query = CKQuery(recordType: "Reminder", predicate: predicate)
//        publicDB.performQuery(query, inZoneWithID: nil) {
//            (records, error) in
//            if error != nil{
//                print(error)
//                
//            }else{
//                print(records)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tableView.reloadData()
//                })
//            }
//            
//            
//            for records in records!{
//                self.list.append(records)
//            }
//            
//            print("Found \(self.list.count) records matching query")
//            let a = self.list[0].valueForKey("med")!
//            print(a)
//            print(self.list[0].valueForKey("Day")!)
//            
//        }
//        print(list)
        
//        let predicate = NSPredicate(format: "%K == %@", "medName", "999")
//       // let predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
//        let query = CKQuery(recordType: "Medicine", predicate: predicate)
//        publicDB.performQuery(query, inZoneWithID: nil) { (records, error) in
//            if error != nil{
//                print(error)
//                }else{
//                print(records)
//                }
//            
//            
//            
//            let record : CKRecord = records![0]
//            let predicate = NSPredicate(format: "med == %@", record)
//
//            let query1 = CKQuery(recordType: "Reminder", predicate: predicate)
//            self.publicDB.performQuery(query1, inZoneWithID: nil) { (records, error) in
//                if error != nil{
//                    print(error)
//                    
//                }else{
//                    for record in records!{
//                        print(record.objectForKey("Day")!)
//                        print(record.objectForKey("Time")!)
//                    }
//
//            
//        
//                }}}
//        
                let predicate = NSPredicate(format: "%K == %@", "Day", "Sunday")
               // let predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)
                let query = CKQuery(recordType: "Reminder", predicate: predicate)
                publicDB.performQuery(query, inZoneWithID: nil) { (records, error) in
                    if error != nil{
                        print(error)
                        }else{
                        print(records)
                        }
        
        
        
                    let record : CKRecord = records![0]
                    let predicate = NSPredicate(format: "recordID == %@", record)
        
                    let query1 = CKQuery(recordType: "Medicine", predicate: predicate)
                    self.publicDB.performQuery(query1, inZoneWithID: nil) { (records, error) in
                        if error != nil{
                            print(error)
        
                        }else{
                            for record in records!{
                                print(record.objectForKey("medName")!)
                               // print(record.objectForKey("Time")!)
                            }
        
                    
                
                        }}}
                

        
 
    }
}