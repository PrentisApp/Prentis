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
import Alamofire
import PusherSwift

class ReceiveCallController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupTopConst: NSLayoutConstraint!
    
    var caller: Mentor? = nil
    var db = Firestore.firestore()
    var pusher : Pusher!
    static let API_ENDPOINT = "http://192.168.0.6:4000";
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 1
        popupView.layer.shadowOffset = CGSize.zero
        popupView.layer.shadowRadius = 5
        
        usernameLabel.text = caller?.username!
        
        bioLabel.text = caller?.bio!
        imageForPath(path: (caller?.imagePath!)!)

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
    
    
    @IBAction func onAccept(_ sender: Any) {
        
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
        answerRequest(channel: channelName, accept: true)
        performSegue(withIdentifier: "onCallSegue", sender: self)
        
    }
    
    @IBAction func onDecline(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "caller")
        let name = UserDefaults.standard.string(forKey: "caller")
        print("decline \(name)")
        
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
        answerRequest(channel: channelName, accept: false)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    public func answerRequest(channel: String, accept: Bool) {
        let params: Parameters = ["channel": channel]
        var endpoint: String?
        if accept {
            endpoint = "/accept"
        } else {
            endpoint = "/decline"
        }
        Alamofire.request(PopupViewController.API_ENDPOINT + endpoint!, method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                _ = "Updated"
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let channelName = Auth.auth().currentUser!.uid + (caller?.uid)!
        print("channel name is: \(channelName)")
        let localUID: UInt = 5
        let remoteUID: UInt = 6
        
        (segue.destination as! CallController).channelName = channelName
        (segue.destination as! CallController).localUID = localUID
        (segue.destination as! CallController).remoteUID = remoteUID
        
    }
}
