//
//  EmergencyCallViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit
import CloudKit

class EmergencyCallViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    var currentNumber = [CKRecord]()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Call function
    @IBAction func callDoctor(sender: AnyObject) {
        print(currentNumber.first!.objectForKey("phone")!)
        let number = currentNumber.first!.objectForKey("phone")!
        let url: NSURL = NSURL(string :"tel://\(number)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    func loadData(){
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Emergency", predicate: predicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (numbers, error) in
            if error != nil{
                print(error)
            }else{
                if numbers!.count > 0 {
                    let number = numbers!.first
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentNumber.append(number!)

                        self.nameLabel.text! = String(number!.objectForKey("phone")!)
                        
                    }
                }
            }
        }
    }
}
