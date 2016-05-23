//
//  DoctorInfoCell.swift
//  MedsPro
//
//  Created by Louis An on 24/05/2016.
//  Copyright © 2016 Louis An. All rights reserved.
//

import UIKit

class DoctorInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
