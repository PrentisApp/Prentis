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

class ProfileViewController: UIViewController, UITextViewDelegate {
    var docRef: DocumentReference!
    var db = Firestore.firestore()

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameText: UITextView!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var bioLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bioText.isScrollEnabled = false
        userNameText.isScrollEnabled = false
        userNameText.textContainer.maximumNumberOfLines = 10
        userNameText.textContainer.lineBreakMode = .byTruncatingTail
        userNameText.layer.cornerRadius = 4
        userNameText.layer.borderWidth = 0.5
        userNameText.layer.borderColor = UIColor.lightGray.cgColor
        bioText.layer.cornerRadius = 4
        bioText.layer.borderWidth = 0.5
        bioText.layer.borderColor = UIColor.lightGray.cgColor
//
        signOutButton.layer.cornerRadius = 4
        signOutButton.layer.borderWidth = 1
        signOutButton.layer.borderColor = UIColor.lightGray.cgColor

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
                self.userNameText.text = document["username"] as? String
                self.bioText.text = document["bio"] as? String
                self.emailLabel.text = document["email"] as? String

            } else {
                print("Document does not exist")
            }
        }
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Kevin Assitores This was called")
        let docRef = db.collection("User").document((Auth.auth().currentUser?.uid)!)
        docRef.updateData([
            "bio": bioText.text,
            ])
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try! Auth.auth().signOut()
        }
        catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInPage = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(signInPage, animated: true, completion: nil)
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
