//
//  MedicineCell.swift
//  MedsPro
//
//  Created by Louis An on 8/06/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class MedicineCell: UITableViewCell {

    @IBOutlet weak var medPillLabel: UILabel!
    
    @IBOutlet weak var medStrengthLabel: UILabel!

    @IBOutlet weak var medNameLabel: UILabel!
   
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
