//  InfoTableViewCell.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.

import UIKit

/**
 The cell that is inserted into the table view to display information there
 */
class InfoTableViewCell: UITableViewCell {
    
    // The left side label that contains the name for the value
    @IBOutlet weak var nameLabel: UILabel!
    
    // The right side label that contains the value for the given name
    @IBOutlet weak var valueLabel: UILabel!
    
    /**
     No further configuration needed here
     */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
