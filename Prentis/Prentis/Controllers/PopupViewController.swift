//
//  PopupViewController.swift
//  Prentis
//
//  Created by Shakeeb Majid on 11/3/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class PopupViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var declineLabel: UILabel!
    var mentor: Mentor? = nil
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        declineLabel.isHidden = true
        usernameLabel.text = mentor?.username!
        
        bioLabel.text = mentor?.bio!
        imageForPath(path: (mentor?.imagePath!)!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func call(_ sender: Any) {
        let menteeUID = Auth.auth().currentUser!.uid
        let channelName = mentor!.uid! + menteeUID
        let channel = ["menteeUID": menteeUID, "mentorUID": mentor!.uid!, "status": "calling"]
        db.collection("User").document((self.mentor?.uid)!).collection("Call")
            .document(channelName).setData(channel){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        db.collection("User").document((self.mentor?.uid)!).collection("Call").document(channelName).addSnapshotListener { DocumentSnapshot, error in
            guard let document = DocumentSnapshot else {
                print("Error fetching document: \(error)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            if data["status"] as! String == "declined" {
                print("HI YOUR CALL HAS JUST BEEN DECLINED")
                self.onDecline()
                
                
            } else if data["status"] as! String == "accepted" {
                print("HI YOUR CALL HAS JUST BEEN ACCEPTED")
                self.performSegue(withIdentifier: "onAcceptSegue", sender: self)
                
            }
            
        }
    }
    func onDecline() {
        cancelButton.isHidden = true
        callButton.isHidden = true
        declineLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageForPath(path: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let channelName = (mentor?.uid)! + Auth.auth().currentUser!.uid
        let localUID: UInt = 6
        let remoteUID: UInt = 5
        
        (segue.destination as! CallController).channelName = channelName
        (segue.destination as! CallController).localUID = localUID
        (segue.destination as! CallController).remoteUID = remoteUID
    }
    

}
