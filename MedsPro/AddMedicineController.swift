//
//  AddMedicineController.swift
//  MedsPro
//
//  Created by Louis An on 22/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class AddMedicineController: UIViewController, addDayDelegate {
    
    var currentReminder: NSMutableArray
    var segmentedControlValue = "Before Meal"
    
    
    required init?(coder aDecoder: NSCoder){
        self.currentReminder = NSMutableArray()
        super.init(coder: aDecoder)        
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var medNameLabel: UITextField!
    @IBOutlet weak var medStrengthLabel: UITextField!
    @IBOutlet weak var medDosageLabel: UITextField!
    @IBOutlet weak var medNoteLabel: UITextField!
    @IBOutlet weak var medPrescriptionDateLabel: UITextField!
    @IBOutlet weak var medNumberOfPillsLabel: UITextField!
 
    //SegmentedControl outlet for Before or After Meal
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    //SegmentedControl action for Before or After Meal
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        switch segmentedControlOutlet.selectedSegmentIndex{
        case 0:
            segmentedControlValue = "Before Meal"
            break
        case 1:
            segmentedControlValue = "After Meal"
            break
        default:
            break
        }
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        if (medNameLabel.text!.isEmpty) || (medDosageLabel.text!.isEmpty){
            let alertController =  UIAlertController(title: "Missing Field", message: "Please enter you medicine details", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
          self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentReminder.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Configure table cell
        let cellIdentifier = "ReminderCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! ReminderCell
        
        let r: Reminder = self.currentReminder[indexPath.row] as! Reminder
        cell.reminderLabel.text = r.day!
        cell.timeLabel.text = r.getFormattedDate()
   
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == .Delete{
            
            self.currentReminder.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addReminderSegue"
        {
            let vcontroller: AddReminderViewController = segue.destinationViewController as! AddReminderViewController
            vcontroller.delegate = self
        }
    }
    
    
    
    
    
    func addDay(reminder: Reminder) {
        currentReminder.addObject(reminder)
        print(currentReminder)
        self.tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
}
