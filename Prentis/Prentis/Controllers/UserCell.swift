//
//  UserCell.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/2/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import FirebaseStorage


class UserCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var expertiseCollection: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var expertiseArr: [String] = []
    
    
    var mentor: Mentor! {
        didSet {
            usernameLabel.text = mentor.username
            bioLabel.text = mentor.bio
            expertiseArr = mentor.expertise as! [String]
            imageForPath(path: mentor.imagePath!)
        }
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        expertiseCollection.delegate = self
        expertiseCollection.dataSource = self
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
    }
    

    func imageForPath(path: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path )
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error: \(error)")
            } else {
                let image = UIImage(data: data!)
                self.profileImage.image = image
                self.profileImage.contentMode = UIViewContentMode.scaleAspectFill
                self.profileImage.clipsToBounds = true
                self.profileImage.focusOnFaces = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expertiseArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpertiseCell", for: indexPath) as! ExpertiseCell
        cell.expertiseLabel.text = expertiseArr[indexPath.row] as! String
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let word = expertiseArr[indexPath.row] as! String
        let labelWord = UILabel()
        labelWord.text = word
        labelWord.font = labelWord.font.withSize(17.0)
        labelWord.sizeToFit()
        let width = labelWord.intrinsicContentSize.width + 25
        
        return CGSize(width: width, height: 27)


    }
}
