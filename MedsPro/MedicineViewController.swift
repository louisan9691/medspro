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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        loadData()
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
                                for medicine in medicines!{
                                  
                                    self.medicineList.append(medicine)
                                }
                                print(self.medicineList)
                
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                        self.tableView.reloadData()
                
                                    })
                                    
                                }
                            }
                        }
                    }


