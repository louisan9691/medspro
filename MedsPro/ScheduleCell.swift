//
//  ScheduleCell.swift
//  MedsPro
//
//  Created by Louis An on 26/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

   
    @IBOutlet weak var refill: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var medNameLabel: UILabel!
    @IBOutlet weak var medNoOfPillsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
