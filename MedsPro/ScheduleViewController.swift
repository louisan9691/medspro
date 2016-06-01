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
        
        
        
       // let predicate = NSPredicate(format: "%K == %@", "medName", "Vit a")
       let predicate = NSPredicate(format: "TRUEPREDICATE", argumentArray: nil) 
        let query = CKQuery(recordType: "Medicine", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (medicine, error) in
            if error != nil{
                print(error)
                }else{
                    for i in 0 ..< medicine!.count{
                    let currentReminder: CKRecord = medicine![i]
                 //   print(currentReminder.objectForKey("medName")!)
                        
                        
                    let predicate = NSPredicate(format: "med == %@", currentReminder)
                    let query = CKQuery(recordType: "Reminder", predicate: predicate)
                    self.publicDB.performQuery(query, inZoneWithID: nil) { (reminders, error) in
                        if error != nil{
                            print(error)
                        }else{
                            for reminder in reminders!{
                                print(reminder.objectForKey("Day")!)
                                print(reminder.objectForKey("Time")!)
                            }
                            
                        }
                        print(currentReminder.objectForKey("medName")!)
                   }
               }
                
            }
        }
        self.tableView.reloadData()

    }
    

}

//var objects = [
//    ["name" : "Item 1", "image": "image1.png"],
//    ["name" : "Item 2", "image": "image2.png"],
//    ["name" : "Item 3", "image": "image3.png"]]
//
//override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return objects.count
//}
//
//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    
//    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//    
//    let object = objects[indexPath.row]
//    
//    cell.textLabel?.text =  object["name"]!
//    cell.imageView?.image = UIImage(named: object["image"]!)
//    cell.otherLabel?.text =  object["otherProperty"]!
//}
//
//}