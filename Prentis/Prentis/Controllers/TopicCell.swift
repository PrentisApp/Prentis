//
//  TopicCellTableViewCell.swift
//  Prentis
//
//  Created by Kevin Asistores on 11/18/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
