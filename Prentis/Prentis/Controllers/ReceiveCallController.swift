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
    
    var caller: Mentor? = nil
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = caller?.username!
        
        bioLabel.text = caller?.bio!
        imageForPath(path: (caller?.imagePath!)!)
        // Do any additional setup after loading the view.
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
