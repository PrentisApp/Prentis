//
//  UserCell.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/2/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    //@IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
