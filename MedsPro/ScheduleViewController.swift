//
//  ScheduleViewController.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Click menu button to slide out side menu
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

  
    @IBOutlet weak var menuButton: UIBarButtonItem!

}
