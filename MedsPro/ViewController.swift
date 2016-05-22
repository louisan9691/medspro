//
//  ViewController.swift
//  MedsPro
//
//  Created by Louis An on 30/04/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set colour for status bar to blue
        let proxyViewForStatusBar : UIView = UIView(frame: CGRectMake(0, 0,self.view.frame.size.width, 20))
        proxyViewForStatusBar.backgroundColor = UIColor(red: 0.2314, green: 0.349, blue: 0.5961, alpha: 1.0)
        self.view.addSubview(proxyViewForStatusBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

