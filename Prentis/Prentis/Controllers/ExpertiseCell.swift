//
//  ExpertiseCell.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/14/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

class ExpertiseCell: UICollectionViewCell {
    
    @IBOutlet weak var expertiseLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        expertiseLabel.layer.cornerRadius = 10
        expertiseLabel.clipsToBounds = true
        expertiseLabel.sizeToFit()
        
    }
}

