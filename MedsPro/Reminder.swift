//
//  Reminder.swift
//  MedsPro
//
//  Created by Louis An on 22/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class Reminder: NSObject {
    
    var day:String?
    var time: NSDate?
    
    init (newDay:String, newTime:NSDate){
        day = newDay
        time = newTime
    }
    
    //Convert NSDate to String
    func getFormattedDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let strDate = dateFormatter.stringFromDate(self.time!)
        return strDate
    }

}
