//
//  AddMedicineController.swift
//  MedsPro
//
//  Created by Louis An on 22/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

private let resuseIdentifier = "PhotoCellIdentifier"

class AddMedicineController: UIViewController, addDayDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var currentReminder: NSMutableArray
    var photoList: NSMutableArray?
    var segmentedControlValue = "Before Meal"
    
    
    required init?(coder aDecoder: NSCoder){
        self.currentReminder = NSMutableArray()
        self.photoList = NSMutableArray()
        super.init(coder: aDecoder)        
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
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
    
    @IBAction func addPhoto(sender: AnyObject) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else{
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        imagePicker.delegate = self
        navigationController!.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dict = info as NSDictionary
        let img: UIImage? = dict.objectForKey(UIImagePickerControllerOriginalImage) as? UIImage
        if img != nil{
            photoList!.addObject(img!)
            collectionView?.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photoList!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> PhotoCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(resuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        let img = photoList!.objectAtIndex(indexPath.row)
        cell.photoView!.image = img as? UIImage
        return cell
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
            let controller: AddReminderViewController = segue.destinationViewController as! AddReminderViewController
            controller.delegate = self
        }
        if segue.identifier == "viewPhotoSegue"{
            let controller: PhotoViewController  = segue.destinationViewController as! PhotoViewController
            let indexPath = self.collectionView?.indexPathForCell(sender as! PhotoCell)
            controller.photoToView = self.photoList?.objectAtIndex(indexPath!.row) as? UIImage
        }
}
    
    
    
    func addDay(reminder: Reminder) {
        currentReminder.addObject(reminder)
        self.tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        roundedButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Rounded button
    @IBOutlet weak var btnRounded: UIButton!
    func roundedButton()
    {
       btnRounded.layer.borderColor = UIColor(red: 81/255, green: 159/255, blue: 243/255, alpha: 1).CGColor
       btnRounded.layer.borderWidth = 1
       btnRounded.layer.cornerRadius = 5
       
    }
  
}
