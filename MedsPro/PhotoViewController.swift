//
//  PhotoViewController.swift
//  MedsPro
//
//  Created by Louis An on 23/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    var photoToView: UIImage?
    //var scrollView: UIScrollView!
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       self.photoView.image = self.photoToView
       scrollView.backgroundColor = UIColor.blackColor()
       scrollView.minimumZoomScale = 1.0
       scrollView.maximumZoomScale = 5.0
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Delegate func
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }

}
