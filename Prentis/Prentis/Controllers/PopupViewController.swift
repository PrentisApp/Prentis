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
    //static let API_ENDPOINT = "http://localhost:4000";
    static let API_ENDPOINT = "http://192.168.0.6:4000";
    var pusher : Pusher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            self.popupTopConst.isActive = false
            self.popupView.centerYAnchor.constraint(equalTo: (self.popupView.superview?.centerYAnchor)!).isActive = true
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: {res in
                
            })
        })

    }
    
    @IBAction func call(_ sender: Any) {
        callRequest()
        listenForAnswer()
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
    
    public func callRequest() {
        let params: Parameters = ["channel": mentor!.uid!, "caller": Auth.auth().currentUser!.uid, "username": UserDefaults.standard.string(forKey: "username")!]
        
        Alamofire.request(PopupViewController.API_ENDPOINT + "/call", method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                _ = "Updated"
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
    private func listenForAnswer() {
        let key = "200b87f4cd87ab883b75"
        let cluster = "us2"
        let channelName = (mentor?.uid)! + Auth.auth().currentUser!.uid
        pusher = Pusher(key: key, options: PusherClientOptions(host: .cluster(cluster)))

        let channel = pusher.subscribe("answers")
        let _ = channel.bind(eventName: channelName, callback: { (data: Any?) -> Void in
            
            if let data = data as? [String: AnyObject] {
                
                if data["answer"] as! String == "accept" {
                    self.performSegue(withIdentifier: "onAcceptSegue", sender: self)
                    
                } else if data["answer"] as! String == "decline" {
                    self.onDecline()
                    
                }
            }
        })
        
        pusher.connect()
        
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
