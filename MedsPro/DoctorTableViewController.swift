//
//  DoctorTableViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class DoctorTableViewController: UITableViewController {

    

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var refreshData: UIRefreshControl = UIRefreshControl()
    var doctorList = [CKRecord]()
    var doctorSearch = [CKRecord]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()     
        // menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.loadData()
            self.tableView.reloadData()
        }
        
        //Pull to refresh
        refreshData.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshData.addTarget(self, action: #selector(DoctorTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshData)
    }
    
    
    
    //refresh function
    func refresh (){
        dispatch_async(dispatch_get_main_queue()) {
            //Clear medicineList otherwise medicineList.count will be doubled. Pull refresh will duplicate data
            self.doctorList.removeAll()
            self.loadData()
            self.tableView.reloadData()
            self.refreshData.endRefreshing()
        }
    }
    
    

    //Load data from cloudKit
    func loadData(){
        let publicDB = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Doctor", predicate: predicate)
        //sorting
        query.sortDescriptors = [NSSortDescriptor(key: "docName", ascending: true)]
        publicDB.performQuery(query, inZoneWithID: nil) { (doctors, error) in
            if error != nil{
                print(error)
            }else{
                for doctor in doctors!{
                    self.doctorList.append(doctor)
                }
                print(self.doctorList.count)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctorList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DoctorCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! DoctorInfoCell
        let record: CKRecord
        record = doctorList[indexPath.row]
    
        cell.nameLabel.text! = record.valueForKey("docName") as! String
        cell.specialtyLabel.text! = record.valueForKey("docSpecialty") as! String
        cell.clinicLabel.text!  = String(record.valueForKey("docClinic")!)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            //IF search bar is being used
            
                deleteData([doctorList[indexPath.row].recordID])
                doctorList.removeAtIndex(indexPath.row)
            
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


}
