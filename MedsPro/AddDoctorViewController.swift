//
//  AddDoctorViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class AddDoctorViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var specialtyText: UITextField!
    @IBOutlet weak var clinicText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var workingHourText: UITextField!
    
    
    @IBAction func saveButton(sender: AnyObject) {
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
