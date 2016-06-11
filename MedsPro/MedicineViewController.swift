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

    @IBOutlet weak var searchBar: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var medicineList = [CKRecord]()
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    var searchMeds = [CKRecord]()
    
    func searchContent (searchText: String){
        searchMeds = medicineList.filter{ med in
            // search for medName
            return (med.valueForKey("medName")!).lowercaseString.containsString(searchText.lowercaseString)
        }
            self.tableView.reloadData()
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
        self.tableView.reloadData()
        }
        //Pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ScheduleViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
       
        //Setup seachBar Layout
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
        
        //If searchbar is being used
        if searchController.active && searchController.searchBar.text != "" {
            return searchMeds.count
        }
        return self.medicineList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MedicineCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! MedicineCell
        let record: CKRecord
        
        //If search bar if being used
        if searchController.active && searchController.searchBar.text != "" {
            record = searchMeds[indexPath.row]
            
        }else{
            record = medicineList[indexPath.row]
        }
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
            //IF search bar is being used
            if searchController.active && searchController.searchBar.text != "" {
               deleteData([searchMeds[indexPath.row].recordID])
                searchMeds.removeAtIndex(indexPath.row)
            }else{
                deleteData([medicineList[indexPath.row].recordID])
                medicineList.removeAtIndex(indexPath.row)
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
        if segue.identifier == "showMedicineSegue"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let medDetail: CKRecord
                
                if searchController.active && searchController.searchBar.text != "" {
                    medDetail = searchMeds[indexPath.row]
                }else{
                    medDetail = medicineList[indexPath.row]
                }
                let controller: ViewMedicineController = segue.destinationViewController as! ViewMedicineController
                controller.medDetail.append(medDetail)
            }
        }
    }
    
    
    
    
    func loadData(){
        
        let publicDB = CKContainer.defaultContainer().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Medicine", predicate: predicate)
        //sorting
        query.sortDescriptors = [NSSortDescriptor(key: "medName", ascending: true)]
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

extension MedicineViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchContent(searchController.searchBar.text!)
    }
}
