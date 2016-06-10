//
//  MedicineViewController.swift
//  MedsPro
//
//  Created by Louis An on 26/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class MedicineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var medicineList = [CKRecord]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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
        
        //Clear medicineList otherwise medicineList.count will be doubled. Pull refresh will duplicate data
        self.medicineList.removeAll()
        self.loadData()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
}


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medicineList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MedicineCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! MedicineCell
        let record: CKRecord = medicineList[indexPath.row]

        cell.medNameLabel.text! = record.valueForKey("medName") as! String
        cell.medStrengthLabel.text! = record.valueForKey("medStrength") as! String
        cell.medPillLabel.text!  = String(record.valueForKey("medDosage")!)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            
            deleteData([medicineList[indexPath.row].recordID])
            medicineList.removeAtIndex(indexPath.row)
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
                                self.medicineList.append(medicine)
                    }
                    print(self.medicineList.count)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
}


