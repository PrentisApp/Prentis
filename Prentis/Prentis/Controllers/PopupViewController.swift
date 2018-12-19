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
import Alamofire
import PusherSwift

class PopupViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var declineLabel: UILabel!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    
    @IBOutlet weak var popupTopConst: NSLayoutConstraint!
    var mentor: Mentor? = nil
    var db = Firestore.firestore()
    static let API_ENDPOINT = "http://localhost:4000";
    var pusher : Pusher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForRealtimeEvents()
        
        // --- Update online presence at intervals --- //
        let date = Date().addingTimeInterval(0)
        let timer = Timer(fireAt: date, interval: 1, target: self, selector: #selector(postOnlinePresence), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 1
        popupView.layer.shadowOffset = CGSize.zero
        popupView.layer.shadowRadius = 5
        
        declineLabel.isHidden = true
        
        usernameLabel.text = mentor?.username!
        bioLabel.text = mentor?.bio!
        
        imageForPath(path: (mentor?.imagePath!)!)
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        popupView.layer.cornerRadius = 10
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            // Put your code which should be executed with a delay here
            self.popupTopConst.isActive = false
            self.popupView.centerYAnchor.constraint(equalTo: (self.popupView.superview?.centerYAnchor)!).isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: {res in
                print("did it work?")
            })
        })

    }
    
    @IBAction func call(_ sender: Any) {
        postStatusUpdate(message: "hi this is a message")
        
        
        
        
        
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
        line1.isHidden = true
        line2.isHidden = true
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
    
    public func postStatusUpdate(message: String) {
        let params: Parameters = ["username": "hello", "status": message]
        
        Alamofire.request(PopupViewController.API_ENDPOINT + "/status", method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                print("hey this was a success")
                _ = "Updated"
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc public func postOnlinePresence() {
        let params: Parameters = ["username": "hello"]
        
        Alamofire.request(PopupViewController.API_ENDPOINT + "/online", method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                _ = "Online"
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func listenForRealtimeEvents() {
        pusher = Pusher(key: "200b87f4cd87ab883b75", options: PusherClientOptions(host: .cluster("us2")))
        
        let channel = pusher.subscribe("new_status")
        let _ = channel.bind(eventName: "online", callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                let username = data["username"] as! String
                print("hey I just got some shit")
                //let index = self.friends.index(where: { $0["username"] == username })
                

            }
        })
        
        pusher.connect()
    }
    

}
