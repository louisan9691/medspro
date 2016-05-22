//
//  AddReminderViewController.swift
//  MedsPro
//
//  Created by Louis An on 22/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

protocol addDayDelegate {
    func addDay(reminder: Reminder)
}

class AddReminderViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var dayList = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var selectedDay = [String]()
    var delegate: addDayDelegate?
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Configure table cell
        let cellIdentifier = "DayCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:  indexPath) as! DayCell
        let row = indexPath.row
        cell.dayLabel.text = dayList[row]
        return cell
    }
    
    
    
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
      
        selectedDay.append(self.dayList[indexPath.row])
        print(selectedDay)
    }
    
    func tableView (tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        let index = selectedDay.indexOf(dayList[indexPath.row])
        selectedDay.removeAtIndex(index!)
        print(selectedDay)
    }
    
    //Save button
    @IBAction func saveReminder(sender: AnyObject) {
        for i in 0 ..< self.selectedDay.count{
            let day = selectedDay[i]
            let reminder = Reminder(newDay: day, newTime: self.datePicker.date)
            self.delegate!.addDay(reminder)
        }
        self.navigationController!.popViewControllerAnimated(true)
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
