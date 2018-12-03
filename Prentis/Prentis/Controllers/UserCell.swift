//
//  UserCell.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/2/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


class UserCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var expertiseCollection: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var expertiseArr: [String] = []
    
    var categories: [String: UIColor] = ["Art": UIColor(displayP3Red: 220/255, green: 20/255, blue: 60/255, alpha: 1), "Food": UIColor(displayP3Red: 1, green: 196/255, blue: 12/255, alpha: 1), "Sports": UIColor(displayP3Red: 30/255, green: 144/255, blue: 1, alpha: 1), "Music": UIColor(displayP3Red: 153/255, green: 50/255, blue: 204/255, alpha: 1), "Gaming": UIColor(displayP3Red: 32/255, green: 178/255, blue: 170/255, alpha: 1), "Pop Culture": UIColor(displayP3Red: 1, green: 127/255, blue: 80/255, alpha: 1), "Technology": UIColor(displayP3Red: 49/255, green: 79/255, blue: 79/255, alpha: 1)]
    var db = Firestore.firestore()
    
    
    
    
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
        var m = expertiseArr[indexPath.row] as! String
        m.capitalizeFirstLetter()
        print("Hey this is Kevin \(m)")
        let docRef = db.collection("Interexpertestis").document(m)
        
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("yes \(m)")
                let k = document["Category"] as! String
                print(k)
                cell.expertiseLabel.backgroundColor = self.categories[k]
            } else {
                print("no \(m)")
                cell.expertiseLabel.backgroundColor = self.categories["Technology"]
            }
        }
        
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
