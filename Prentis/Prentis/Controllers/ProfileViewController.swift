//
//  ProfileViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 11/3/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FaceAware

class ProfileViewController: UIViewController {
    var docRef: DocumentReference!
    var db = Firestore.firestore()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let docRef = db.collection("User").document((Auth.auth().currentUser?.uid)!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print(document["profileImage"] as! String)
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imageRef = storageRef.child(document["profileImage"] as! String)
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
                self.usernameLabel.text = document["username"] as? String
                self.bioLabel.text = document["bio"] as? String
            } else {
                print("Document does not exist")
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
