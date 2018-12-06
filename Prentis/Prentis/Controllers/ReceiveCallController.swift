//
//  ReceiveCallController.swift
//  Prentis
//
//  Created by Shakeeb Majid on 11/18/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class ReceiveCallController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    var caller: Mentor? = nil
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 1
        popupView.layer.shadowOffset = CGSize.zero
        popupView.layer.shadowRadius = 5
        
        usernameLabel.text = caller?.username!
        
        bioLabel.text = caller?.bio!
        imageForPath(path: (caller?.imagePath!)!)
        // Do any additional setup after loading the view.
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        popupView.layer.cornerRadius = 10
    }
    
    func imageForPath(path: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        //let imageRef = storageRef.child(document["profileImage"] as! String)
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
    
    
    @IBAction func onAccept(_ sender: Any) {
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
        print("channel name is: \(channelName)")
        self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Call").document(channelName).updateData(["status": "accepted"])
        performSegue(withIdentifier: "onCallSegue", sender: self)
    }
    
    @IBAction func onDecline(_ sender: Any) {
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
 self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Call").document(channelName).updateData(["status": "declined"])
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
        print("channel name is: \(channelName)")
        let localUID: UInt = 5
        let remoteUID: UInt = 6
        
        (segue.destination as! CallController).channelName = channelName
        (segue.destination as! CallController).localUID = localUID
        (segue.destination as! CallController).remoteUID = remoteUID
        
    }
    

}
