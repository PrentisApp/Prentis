//
//  UserCell.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/2/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var expertiseCollection: UICollectionView!
    
    let arr:[String] = ["guitar", "piano", "tennis"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertiseCell", for: indexPath) as! ExpertiseCell
        
        cell.expertiseLabel.text = arr[indexPath.row]
        
        return cell
    }
    

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("heeeeeeeeY")
        expertiseCollection.delegate = self
        expertiseCollection.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
